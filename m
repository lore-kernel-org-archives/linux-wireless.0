Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35564 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbbENAcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2015 20:32:13 -0400
MIME-Version: 1.0
In-Reply-To: <1431541436-17007-7-git-send-email-mcgrof@do-not-panic.com>
References: <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com> <1431541436-17007-7-git-send-email-mcgrof@do-not-panic.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 14 May 2015 10:31:52 +1000
Message-ID: <CAGRGNgW3+SgOqt-env6SBp+j7S4wQcXTK0HpuiM_BYbLzpfohA@mail.gmail.com> (sfid-20150514_023248_445216_3B8C0AA4)
Subject: Re: [RFC v2 6/6] firmware: add firmware signature checking support
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: ming.lei@canonical.com, Rusty Russell <rusty@rustcorp.com.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	dhowells@redhat.com, Seth Forshee <seth.forshee@canonical.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	pebolle@tiscali.nl,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>, jlee@suse.com,
	Takashi Iwai <tiwai@suse.de>, casey@schaufler-ca.com,
	Kees Cook <keescook@chromium.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Kyle McMartin <kyle@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

On Thu, May 14, 2015 at 4:23 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> Systems that have module signing currently enabled may
> wish to extend vetting of firmware passed to the kernel
> as well. We can re-use most of the code for module signing
> for firmware signature verification and signing. This will
> also later enable re-use of this same code for subsystems
> that wish to provide their own cryptographic verification
> mechanisms on userspace data needed.
>
> As with module signing, we do a very simple search for a
> particular string appended to the firmware. There's both a
> config option and a boot parameter which control whether we
> accept or fail with unsigned firmware and firmware that are
> signed with an unknown key.
>
> If firmware signing is enabled, the kernel will be tainted
> if a firmware is loaded that is unsigned or has a signature
> for which we don't have the key.
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Ming Lei <ming.lei@canonical.com>
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Cc: Kyle McMartin <kyle@kernel.org>
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>  Documentation/firmware_class/signing.txt           |  88 +++++++++
>  drivers/base/Kconfig                               |  18 ++
>  drivers/base/firmware_class.c                      | 214 ++++++++++++++++++++-
>  .../sysdata-internal.h => include/linux/sysdata.h  |   0
>  kernel/module.c                                    |   2 +-
>  kernel/sysdata_signing.c                           |   3 +-
>  kernel/system_keyring.c                            |   2 +-
>  7 files changed, 317 insertions(+), 10 deletions(-)
>  create mode 100644 Documentation/firmware_class/signing.txt
>  rename kernel/sysdata-internal.h => include/linux/sysdata.h (100%)
>
> diff --git a/Documentation/firmware_class/signing.txt b/Documentation/firmware_class/signing.txt
> new file mode 100644
> index 0000000..6e1ce3c
> --- /dev/null
> +++ b/Documentation/firmware_class/signing.txt
> @@ -0,0 +1,88 @@
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
> +signature on the filesystem as foo.bin.pkcs7. When firmware signature
> +checking is enabled (FIRMWARE_SIG) when one of the above APIs is used
> +against foo.bin, the file foo.bin.pkcs7 will also be looked for. If
> +FIRMWARE_SIG_FORCE is enabled the foo.bin file will only be allowed to
> +be returned to callers of the above APIs if and only if the foo.bin.pkcs7
> +file is confirmed to be a valid signature of the foo.bin file. If
> +FIRMWARE_SIG_FORCE is not enabled and only FIRMWARE_SIG is enabled the
> +kernel will be permissive and enabled unsiged firmware files, or firmware
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
> +"Require all firmware to be validly signed", under the same menu.

You reference the relevant Kconfig symbols above, do you want to add
it here too?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
