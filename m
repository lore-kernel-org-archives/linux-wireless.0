Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vn0-f46.google.com ([209.85.216.46]:43573 "EHLO
	mail-vn0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbbFHT4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 15:56:46 -0400
Received: by vnbg7 with SMTP id g7so13262822vnb.10
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2015 12:56:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431996325-8840-3-git-send-email-mcgrof@do-not-panic.com>
References: <1431996325-8840-1-git-send-email-mcgrof@do-not-panic.com>
	<1431996325-8840-3-git-send-email-mcgrof@do-not-panic.com>
Date: Mon, 8 Jun 2015 12:56:44 -0700
Message-ID: <CAGXu5jJnPqgpvXd05-dtSbYeSVndcpH1_XMMczPWn5Gq-DUtcw@mail.gmail.com> (sfid-20150608_215651_072932_3F8E0486)
Subject: Re: [RFC v3 2/2] firmware: add firmware signature checking support
From: Kees Cook <keescook@chromium.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Ming Lei <ming.lei@canonical.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	seth.forshee@canonical.com, LKML <linux-kernel@vger.kernel.org>,
	Paul Bolle <pebolle@tiscali.nl>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>, jlee@suse.com,
	Takashi Iwai <tiwai@suse.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <David.Woodhouse@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 18, 2015 at 5:45 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> Systems that have module signing currently enabled may
> wish to extend vetting of firmware passed to the kernel
> as well. We can re-use most of the code for module signing
> for firmware signature verification and signing. This will
> also later enable re-use of this same code for subsystems
> that wish to provide their own cryptographic verification
> requirements on userspace data needed.
>
> Contrary to module signing the signature files are expected
> to be completely detached for practical and licensing puposes.
> If you have foo.bin, you'll need foo.bin.p7s file present
> for firmware signing.
>
> There's both a config option and a boot parameter which control
> whether we accept or fail with unsigned firmware and firmware
> that are signed with an unknown key. If firmware signing is
> enabled permissively we'll only log into the kernel ring buffer
> when use of an unsigned firmware file is used. If firmware
> signing is in enforced mode the kernel will not allow invalid
> or unsigned firmware files to be loaded into the kernel.
>
> Contrary to module signing we do not taint the kernel in
> the permissive fw signing mode due to restrictions on the
> firmware_class API, extensions to enable this are expected
> however in the future.
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Ming Lei <ming.lei@canonical.com>
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Cc: Kyle McMartin <kyle@kernel.org>
> Cc: David Woodhouse <David.Woodhouse@intel.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>  Documentation/firmware_class/signing.txt |  90 +++++++++++++
>  drivers/base/Kconfig                     |  18 +++
>  drivers/base/firmware_class.c            | 213 ++++++++++++++++++++++++++++++-
>  3 files changed, 314 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/firmware_class/signing.txt
>
> diff --git a/Documentation/firmware_class/signing.txt b/Documentation/firmware_class/signing.txt
> new file mode 100644
> index 0000000..b03f654
> --- /dev/null
> +++ b/Documentation/firmware_class/signing.txt
> @@ -0,0 +1,90 @@
> +                       ================================
> +                       KERNEL FIRMWARE SIGNING FACILITY
> +                       ================================
> +
> +CONTENTS
> +
> + - Overview.
> + - Configuring firmware signing.
> + - Using signing keys.
> + - Signing firmware files.
> +
> +
> +========
> +OVERVIEW
> +========
> +
> +Device drivers which require a firmware to be uploaded onto a device as its own
> +device's microcode use any of the following APIs:
> +
> +  * request_firmware()
> +  * request_firmware_direct()
> +  * request_firmware_nowait()
> +
> +The kernel firmware signing facility enables to cryptographically sign
> +firmware files on a system using the same keys used for module signing.
> +Firmware files's signatures consist of PKCS#7 messages of the respective
> +firmware file. A firmware file named foo.bin, would have its respective
> +signature on the filesystem as foo.bin.p7s. When firmware signature
> +checking is enabled (FIRMWARE_SIG) and when one of the above APIs is used
> +against foo.bin, the file foo.bin.p7s will also be looked for. If
> +FIRMWARE_SIG_FORCE is enabled the foo.bin file will only be allowed to
> +be returned to callers of the above APIs if and only if the foo.bin.p7s
> +file is confirmed to be a valid signature of the foo.bin file. If
> +FIRMWARE_SIG_FORCE is not enabled and only FIRMWARE_SIG is enabled the
> +kernel will be permissive and enabled unsigned firmware files, or firmware
> +files with incorrect signatures. If FIRMWARE_SIG is not enabled the
> +signature file is ignored completely.
> +
> +Firmware signing increases security by making it harder to load a malicious
> +firmware into the kernel.  The firmware signature checking is done by the
> +kernel so that it is not necessary to have trusted userspace bits.
> +
> +============================
> +CONFIGURING FIRMWARE SIGNING
> +============================
> +
> +The firmware signing facility is enabled by going to the section:
> +
> +-> Device Drivers
> +  -> Generic Driver Options
> +    -> Userspace firmware loading support (FW_LOADER [=y])
> +      -> Firmware signature verification (FIRMWARE_SIG [=y])
> +
> +If you want to not allow unsigned firmware to be loaded you should
> +enable:
> +
> +"Require all firmware to be validly signed" (FIRMWARE_SIG_FORCE [=y]),
> +under the same menu.
> +
> +==================
> +USING SIGNING KEYS
> +==================
> +
> +The same key types used for module signing can be used for firmware
> +signing. For details on that refer to Documentation/module-signing.txt.
> +
> +You will need:
> +
> +  A) A DER-encoded X.509 certificate containing the public key.
> +  B) A DER-encoded PKCS#7 message containing the signatures, these are
> +     the .p7s files.
> +  C) A binary blob that is the detached data for the PKCS#7 message, this
> +     is the firmware files
> +
> +A) is must be made available to the kernel. One way to do this is to provide a
> +DER-encoded in the source directory as <name>.x509 when you build the kernel.
> +
> +======================
> +SIGNING FIRMWARE FILES
> +======================
> +
> +To generate a DER-encoded PKCS#7 signature message for each firmware file
> +you can use openssl as follows:
> +
> +       openssl smime -sign -in $FIRMWARE_BLOB_NAME \
> +               -outform DER \
> +               -inkey $PRIVATE_KEY_FILE_IN_PEM_FORM \
> +               -signer $X509_CERT_FILE_IN_PEM_FORM \
> +               -nocerts -md $DIGEST_ALGORITHM -binary > \
> +               $(FIRMWARE_BLOB_NAME).p7s
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 98504ec..fa076ea 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -85,6 +85,24 @@ config FW_LOADER
>           require userspace firmware loading support, but a module built
>           out-of-tree does.
>
> +config FIRMWARE_SIG
> +       bool "Firmware signature verification"
> +       depends on FW_LOADER
> +       select SYSDATA_SIG
> +       help
> +         Check firmware files for valid signatures upon load: if the firmware
> +         was called foo.bin, a respective foo.bin.p7s is expected to be
> +         present as the signature. For more information see
> +         Documentation/firmware_class/signing.txt
> +
> +config FIRMWARE_SIG_FORCE
> +       bool "Require all firmware to be validly signed"
> +       depends on FIRMWARE_SIG
> +       help
> +         Reject unsigned files or signed files for which we don't have a
> +         key.  Without this, you'll only get a record on the kernel ring
> +         buffer of firmware files loaded without a signature.
> +
>  config FIRMWARE_IN_KERNEL
>         bool "Include in-kernel firmware blobs in kernel binary"
>         depends on FW_LOADER
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 134dd77..97cab65 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -29,6 +29,7 @@
>  #include <linux/syscore_ops.h>
>  #include <linux/reboot.h>
>  #include <linux/security.h>
> +#include <keys/system_keyring.h>
>
>  #include <generated/utsrelease.h>
>
> @@ -38,6 +39,11 @@ MODULE_AUTHOR("Manuel Estrada Sainz");
>  MODULE_DESCRIPTION("Multi purpose firmware loading support");
>  MODULE_LICENSE("GPL");
>
> +static bool fw_sig_enforce = IS_ENABLED(CONFIG_FIRMWARE_SIG_FORCE);
> +#ifndef CONFIG_FIRMWARE_SIG_FORCE
> +module_param(fw_sig_enforce, bool_enable_only, 0644);
> +#endif /* !CONFIG_FIRMWARE_SIG_FORCE */
> +
>  /* Builtin firmware support */
>
>  #ifdef CONFIG_FW_LOADER
> @@ -142,6 +148,9 @@ struct firmware_buf {
>         unsigned long status;
>         void *data;
>         size_t size;
> +       void *data_sig;
> +       size_t size_sig;
> +       bool sig_ok;
>  #ifdef CONFIG_FW_LOADER_USER_HELPER
>         bool is_paged_buf;
>         bool need_uevent;
> @@ -151,6 +160,7 @@ struct firmware_buf {
>         struct list_head pending_list;
>  #endif
>         const char *fw_id;
> +       const char *fw_sig;
>  };
>
>  struct fw_cache_entry {
> @@ -180,17 +190,33 @@ static struct firmware_buf *__allocate_fw_buf(const char *fw_name,
>                                               struct firmware_cache *fwc)
>  {
>         struct firmware_buf *buf;
> +       const char *sign_ext = ".p7s";
> +       char *signed_name;
> +
> +       signed_name = kzalloc(PATH_MAX, GFP_ATOMIC);
> +       if (!signed_name)
> +               return NULL;
>
>         buf = kzalloc(sizeof(*buf), GFP_ATOMIC);
> -       if (!buf)
> +       if (!buf) {
> +               kfree(signed_name);
>                 return NULL;
> +       }
>
>         buf->fw_id = kstrdup_const(fw_name, GFP_ATOMIC);
>         if (!buf->fw_id) {
> +               kfree(signed_name);
>                 kfree(buf);
>                 return NULL;
>         }
>
> +       strcpy(signed_name, buf->fw_id);
> +       strncat(signed_name, sign_ext, strlen(sign_ext));

fw_id is potentially unbounded, so using strncat hear poses an
overflow risk. Maybe better to use strlcpy?

> +       buf->fw_sig = kstrdup_const(signed_name, GFP_ATOMIC);
> +       if (!buf->fw_sig)
> +               goto out;
> +
> +
>         kref_init(&buf->ref);
>         buf->fwc = fwc;
>         init_completion(&buf->completion);
> @@ -201,6 +227,11 @@ static struct firmware_buf *__allocate_fw_buf(const char *fw_name,
>         pr_debug("%s: fw-%s buf=%p\n", __func__, fw_name, buf);
>
>         return buf;
> +out:
> +       kfree(signed_name);
> +       kfree_const(buf->fw_id);
> +       kfree(buf);
> +       return NULL;
>  }
>
>  static struct firmware_buf *__fw_lookup_buf(const char *fw_name)
> @@ -262,6 +293,7 @@ static void __fw_free_buf(struct kref *ref)
>  #endif
>                 vfree(buf->data);
>         kfree_const(buf->fw_id);
> +       kfree_const(buf->fw_sig);
>         kfree(buf);
>  }
>
> @@ -325,7 +357,84 @@ fail:
>         return rc;
>  }
>
> +#ifdef CONFIG_FIRMWARE_SIG_FORCE
> +static struct file *get_filesystem_file_sig(const char *sig_name)
> +{
> +       return filp_open(sig_name, O_RDONLY, 0);
> +}
> +
> +static bool get_filesystem_file_sig_ok(struct file *file_sig)
> +{
> +       if (IS_ERR(file_sig))
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static int read_file_signature_contents(struct file *file_sig,
> +                                       struct firmware_buf *fw_buf)
> +{
> +       int rc;
> +
> +       rc = __read_file_contents(file_sig,
> +                                 &fw_buf->data_sig,
> +                                 &fw_buf->size_sig);
> +       if (rc)
> +               return rc;
> +
> +       return 0;
> +}
> +
> +#elif CONFIG_FIRMWARE_SIG
> +static struct file *get_filesystem_file_sig(const char *sig_name)
> +{
> +       struct file *file;
> +
> +       file = filp_open(sig_name, O_RDONLY, 0);
> +       if (IS_ERR(file))
> +               pr_info("singature %s not present, but this is OK\n", sig_name);
> +
> +       return file;
> +}
> +
> +static bool get_filesystem_file_sig_ok(struct file *file_sig)
> +{
> +       return 0;
> +}
> +
> +static int read_file_signature_contents(struct file *file_sig,
> +                                       struct firmware_buf *fw_buf)
> +{
> +       int rc;
> +
> +       rc = __read_file_contents(file,
> +                                 &fw_buf->data_sig,
> +                                 &fw_buf->size_sig);
> +       if (rc)
> +               pr_info("could not read signature %s, but this is OK\n",
> +                       fw_buf->fw_sig);
> +
> +       return 0;
> +}
> +#else
> +static struct file *get_filesystem_file_sig(const char *sig_name)
> +{
> +       return NULL;
> +}
> +
> +static bool get_filesystem_file_sig_ok(struct file *file_sig)
> +{
> +       return 0;
> +}
> +
> +static int read_file_signature_contents(struct file *file_sig,
> +                                       struct firmware_buf *fw_buf)
> +{
> +       return 0;
> +}
> +#endif
> +
>  static int fw_read_file_contents(struct file *file,
> +                                struct file *file_sig,
>                                  struct firmware_buf *fw_buf)
>  {
>         int rc;
> @@ -336,6 +445,10 @@ static int fw_read_file_contents(struct file *file,
>         if (rc)
>                 return rc;
>
> +       rc = read_file_signature_contents(file_sig, fw_buf);
> +       if (rc)
> +               return rc;
> +
>         return 0;
>  }
>
> @@ -343,15 +456,20 @@ static int fw_get_filesystem_firmware(struct device *device,
>                                        struct firmware_buf *buf)
>  {
>         int i, len;
> -       int rc = -ENOENT;
> -       char *path;
> +       int rc = -ENOMEM;
> +       char *path, *path_sig = NULL;
>
>         path = __getname();
>         if (!path)
>                 return -ENOMEM;
>
> +       path_sig = __getname();
> +       if (!path_sig)
> +               goto out;
> +
>         for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
>                 struct file *file;
> +               struct file *file_sig;
>
>                 /* skip the unset customized path */
>                 if (!fw_path[i][0])
> @@ -364,18 +482,43 @@ static int fw_get_filesystem_firmware(struct device *device,
>                         break;
>                 }
>
> +               len = snprintf(path_sig, PATH_MAX, "%s/%s",
> +                              fw_path[i], buf->fw_sig);
> +               if (len >= PATH_MAX) {
> +                       rc = -ENAMETOOLONG;
> +                       break;
> +               }
> +
>                 file = filp_open(path, O_RDONLY, 0);
> -               if (IS_ERR(file))
> +               if (IS_ERR(file)) {
> +                       rc = -ENOENT;
>                         continue;
> -               rc = fw_read_file_contents(file, buf);
> +               }
> +
> +               file_sig = get_filesystem_file_sig(path_sig);
> +               rc = get_filesystem_file_sig_ok(file_sig);
> +               if (rc) {
> +                       fput(file);
> +                       if (!IS_ERR(file_sig))
> +                               fput(file_sig);
> +                       continue;
> +               }
> +
> +               rc = fw_read_file_contents(file, file_sig, buf);
> +
>                 fput(file);
> +               if (!IS_ERR(file_sig))
> +                       fput(file_sig);
> +
>                 if (rc)
>                         dev_warn(device, "firmware, attempted to load %s, but failed with error %d\n",
>                                 path, rc);
>                 else
>                         break;
>         }
> +out:
>         __putname(path);
> +       __putname(path_sig);
>
>         if (!rc) {
>                 dev_dbg(device, "firmware: direct-loading firmware %s\n",
> @@ -410,11 +553,42 @@ static void fw_set_page_data(struct firmware_buf *buf, struct firmware *fw)
>         fw->size = buf->size;
>         fw->data = buf->data;
>
> -       pr_debug("%s: fw-%s buf=%p data=%p size=%u\n",
> +       pr_debug("%s: fw-%s buf=%p data=%p size=%u sig_ok=%d\n",
>                  __func__, buf->fw_id, buf, buf->data,
> -                (unsigned int)buf->size);
> +                (unsigned int)buf->size, buf->sig_ok);
>  }
>
> +#ifdef CONFIG_FIRMWARE_SIG
> +static int firmware_sig_check(struct firmware *fw, const char *name)
> +{
> +       int err = -ENOKEY;
> +       struct firmware_buf *buf = fw->priv;
> +       const void *data = buf->data;
> +       const void *data_sig = buf->data_sig;
> +
> +       err = system_verify_data(data, buf->size, data_sig, buf->size_sig);
> +       if (!err) {
> +               buf->sig_ok = true;
> +               fw_set_page_data(buf, fw);
> +               return 0;
> +       }
> +
> +       /* Not having a signature is only an error if we're strict. */
> +       if (err == -ENOKEY && !fw_sig_enforce)
> +               err = 0;
> +
> +       fw_set_page_data(buf, fw);
> +
> +       return err;
> +}
> +#else /* !CONFIG_FIRMWARE_SIG */
> +static int firmware_sig_check(struct firmware *fw, const char *name)
> +{
> +       return 0;
> +}
> +#endif /* !CONFIG_MODULE_SIG */
> +
> +
>  #ifdef CONFIG_PM_SLEEP
>  static void fw_name_devm_release(struct device *dev, void *res)
>  {
> @@ -1120,6 +1294,22 @@ static int assign_firmware_buf(struct firmware *fw, struct device *device,
>         return 0;
>  }
>
> +#ifdef CONFIG_FIRMWARE_SIG
> +static void fw_check_sig_ok(const struct firmware *fw, const char *name)
> +{
> +       struct firmware_buf *buf = fw->priv;
> +
> +       if (!buf->sig_ok)
> +               pr_notice_once("%s: firmware verification failed: signature "
> +                                      "and/or required key missing\n", name);
> +}
> +#else
> +static void fw_check_sig_ok(const struct firmware *fw, const char *name)
> +{
> +       return;
> +}
> +#endif
> +
>  /* called from request_firmware() and request_firmware_work_func() */
>  static int
>  _request_firmware(const struct firmware **firmware_p, const char *name,
> @@ -1177,6 +1367,15 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>         usermodehelper_read_unlock();
>
>   out:
> +       if (ret >= 0) {
> +               ret = firmware_sig_check(fw, name);
> +               if (ret)
> +                       goto out_bad_sig;
> +               fw_check_sig_ok(fw, name);
> +       }
> +
> + out_bad_sig:
> +
>         if (ret < 0) {
>                 release_firmware(fw);
>                 fw = NULL;
> --
> 2.3.2.209.gd67f9d5.dirty
>

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
