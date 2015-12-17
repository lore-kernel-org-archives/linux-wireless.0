Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176AbbLQTd4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 14:33:56 -0500
Date: Thu, 17 Dec 2015 20:33:50 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
	Dmitry Kasatkin <d.kasatkin@samsung.com>,
	linux-ima-devel@lists.sourceforge.net,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Roberts@suse.de,
	William C <william.c.roberts@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Tom Gundersen <teg@jklm.no>,
	Johannes Berg <johannes@sipsolutions.net>,
	Seth Forshee <seth.forshee@canonical.com>,
	Julia Lawall <julia.lawall@lip6.fr>,
	Kyle McMartin <kyle@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Ming Lei <ming.lei@canonical.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Hannes Reinecke <hare@suse.de>, Takashi Iwai <tiwai@suse.de>,
	Rik van Riel <riel@redhat.com>,
	linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/7] ima: load policy using path
Message-ID: <20151217193350.GR20409@wotan.suse.de> (sfid-20151217_203429_152077_E69C6706)
References: <1449597684-4631-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1449597684-4631-4-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449597684-4631-4-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The subject should probably be: ima: add support to load policy from path

Cc'ing Roberts who originally wanted SELinux file policy signing capabilities.
Also Greg, who is reviewing the sysdata file changes I had proposed which would
provide a generic file loading facility for modules, and later a generic file
signing checker. Cc'ing Linus for any feedback on the possible issues he might
foresee if we all go gung-ho on "kernel file loading", as this is where it
seems some folks might be going. I *think* the user hint might help close the
semantic gap observed on using a file loader on firmware_class, but perhaps he
or other might have some other corner cases in mind we should also consider.

Note that the crux between using a generic kernel file loader and the common
"sysdata" file loader will be that sysdata file users (wireless would be one
getting rid of CRDA) and a core kernel file loader (IMA could be one, likewise
perhaps SELinux if it follows suit in design as in this patch) is that the core
kernel file loader would allow arbitrary file paths, and the sysdata users
would have stuff in /lib/firmware/ paths (and therefore also have things in the
linux-firmware tree).

On Tue, Dec 08, 2015 at 01:01:20PM -0500, Mimi Zohar wrote:
> From: Dmitry Kasatkin <d.kasatkin@samsung.com>
> 
> Currently the IMA policy is loaded by writing the policy rules to
> '<securityfs>/ima/policy'.

> That way the policy cannot be measured or appraised. This patch extends the
> policy loading interface with the possibility to load the policy using a
> pathname. The policy can be loaded like:
> 
> echo /etc/ima/ima_policy > /sys/kernel/security/ima/policy

I don't think this is as clear, you can just say something like:

---------------------------------------------------------------------
We currently cannot do appraisal or signature vetting of IMA policies
since we currently can only load IMA policies by writing the contents
of the polify directly in, as follows:

cat policy-file > <securityfs>/ima/policy

If we provide the kernel the path to the IMA policy so it can load
the policy itself it'd be able to later appraise or vet for the file
signature if it had one. This adds support to load IMA policies
with a given path as follows:

echo /etc/ima/ima_policy > /sys/kernel/security/ima/policy
---------------------------------------------------------------------

> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
>  security/integrity/iint.c       |  4 +---
>  security/integrity/ima/ima_fs.c | 39 ++++++++++++++++++++++++++++++++++++++-
>  security/integrity/integrity.h  |  2 +-
>  3 files changed, 40 insertions(+), 5 deletions(-)
> 
> diff --git a/security/integrity/iint.c b/security/integrity/iint.c
> index 2de9c82..54b51a4 100644
> --- a/security/integrity/iint.c
> +++ b/security/integrity/iint.c
> @@ -203,10 +203,8 @@ int integrity_kernel_read(struct file *file, loff_t offset,
>   * This is function opens a file, allocates the buffer of required
>   * size, read entire file content to the buffer and closes the file
>   *
> - * It is used only by init code.
> - *
>   */
> -int __init integrity_read_file(const char *path, char **data)
> +int integrity_read_file(const char *path, char **data)
>  {
>  	struct file *file;
>  	loff_t size;
> diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
> index eebb985..f902b6b 100644
> --- a/security/integrity/ima/ima_fs.c
> +++ b/security/integrity/ima/ima_fs.c
> @@ -258,6 +258,40 @@ static const struct file_operations ima_ascii_measurements_ops = {
>  	.release = seq_release,
>  };
>  
> +static ssize_t ima_read_policy(char *path)
> +{
> +	char *data, *datap;
> +	int rc, size, pathlen = strlen(path);
> +	char *p;
> +
> +	/* remove \n */
> +	datap = path;
> +	strsep(&datap, "\n");
> +
> +	rc = integrity_read_file(path, &data);
> +	if (rc < 0)
> +		return rc;
> +
> +	size = rc;
> +	datap = data;
> +
> +	while (size > 0 && (p = strsep(&datap, "\n"))) {
> +		pr_debug("rule: %s\n", p);
> +		rc = ima_parse_add_rule(p);
> +		if (rc < 0)
> +			break;
> +		size -= rc;
> +	}
> +
> +	kfree(data);
> +	if (rc < 0)
> +		return rc;
> +	else if (size)
> +		return -EINVAL;
> +	else
> +		return pathlen;
> +}
> +

Please no, instead of adding yet-another kernel file-loading facility which is
likely error prone we should consolidate *all kernel file-loading facilities*
into a *common generic shared one*. So please work to make that happen since you
need yet-another user for it. I've done some initial homework already on a few
prominent common users. I say "initial" homework as my search was rather crude on
'git grep' and not done using semantic parsers to see if I "search for file
loaders" through semantic means. This later search may be optional, but it
would help the hunt be more complete. I've listed in two separate threads now
what a few prominent file loaders are, here they are again:

    - firmware_class: fw_read_file()
    - module: kernel_read()
    - kexec: copy_file_fd()

At the last Linux security summit we discussed this and it was agreed we should
try to share these, likewise a little while ago on lkml  as well [0] [1], its
actually where some of these ideas of a common LSM hook for file reading was
brushed upon recently:

[0] http://lkml.kernel.org/r/CAGXu5jKF6CBAADoybZHRCzYAepcZYqpbck1gTAeV1p7iuOVAvw@mail.gmail.com
[1] http://lkml.kernel.org/r/1440719673.2118.84.camel@linux.vnet.ibm.com

Since you need yet-naother kernel file-loader please do the work to generalize
it, or at least try it.  In fact let me send out now my series of patches for
the system data helpers, which would later help generalizing firmware signing.
It also has a cleanup to generalize the file loading code on firmware_class,
which should make your work on making a generic file reader easier. At the
kernel summit we decided to go forward with the sysdata generic helpers first,
and then later it seems we reached some consensus on how we'd do fw signing.
The first part will just be the sysdata thing which generalizes reading files
for /lib/firmware.

I will point out a warning though -- Mimi has noted a while ago that direct
kernel file loading was not something "popular" until a little while ago. Some
interesting issues have come up due to firmware_class file loading over time on
two fronts which new file loader users should become aware of and be careful
over:

  * Fast bootup: modules that need files might take a while to load
  * Systemd: due the (to me at least) infamous 30-second timeout on the workers

*Because* of these two issues, we've added kernel asynchronous probe support,
but driver / kernel developers might get the sense that they should use async
probe for *all* things related to issues of using firmware request on init or
probe, but as discussed on lkml a little while ago, that's incorrect [2], what
we *really* need is a mechanism to *vet* from userspace that the files that
would be loaded by a specific driver loader *are* ready. So, for for instance
for firmware loading we'd need userspace to help the kernel give it a hint that
all files on /lib/firmware should be ready.

This needs a little bit further explanation:

It used be that people loaded firmware on init, and then Linus hinted that's
probably a bad idea, but some folks thought they could then just load it on
probe. That turned out to not be such a good idea *as well* given that the
kernel's driver loader called the driver's init and probe routine serially,
that's one reason why we now have async probe. So the quest for "bad" drivers
went from users of firmware loading on init to include also probe. Julia helped
me design a semantic patch to help hunt all affected users, I'll soon send
a new PATCH which has the latest version which should help find most of these
users. The *reason* its a bad idea to call firmware loading so early, whether
init *or* probe is actually because the kernel *has no semantic guarantee that
the files in /lib/firmware are ready*, so even if you *did* use async probe,
you might just end up calling probe asynchronously later, but the path may
*still* not be ready. As discussed in the thread there is also no easy way for
the kernel to come up heuristics for this, specially due to pivot_root [2],
best we can do then is devices a way for *userspace* to complete its
requirements somehow and provide guarantees of when /lib/firmware *is* ready.
Only userspace and in turn system designers, or sysadmins would know when it
*should* be ready.

[2] http://lkml.kernel.org/r/CAB=NE6UBRa0K7=PomJzKxsoj4GzAqkYrkp=O+UfVvu2fwM25pA@mail.gmail.com

So likewise, you should expect similar chicken and the egg problem for other
kernel file loaders. My recommendation to help avoid this is to have a good
discussion over prospective uses of the subsystem (in this case IMA, but
SELinux folks should consider this as well if they want file "path" loader
capability as well) now and in the far future, and decide on filesystem
requirements or at least document the implications of certain decisions.
For instance, subsystem users of a "load file from path" core facility might
want to consider what the earliest file loaded might be, document that, and
document perhaps future early users, and requirements. To avoid odd ball bugs,
such as pivot_root() changes and files being present later, one would need to
devise similar userspace feature to ensure then that when the kernel yells back
"file not found" on this path, it really means it. This might perhaps best be
done as an option for the kernel file loader, so that if it needs these
guarantees the users specify this requirement. Best also if the file loading
then can be done asynchronously, so that once such a signal comes that the
final path is ready the kernel can safely hunt for the files and return
not found and mean it.

I'm not saying you need the userspace hint/helper combo now, I'm just saying
its perhaps best we consider these things now and highlight these constraints,
so we don't get any funny surprises later.

Likewise -- let's also consider the usermode helper design on firmware_class,
although we all furiously want it dead it seems some folks keep coming up
with reasons to have it stay, that is an alternative specific loader to the
common core. Could such a use case arise on IMA / SELinux in the future? If
so perhaps we should also generalize that code. If its too early to think
about it, at least its now on the map of possibilities later to consider.

FWIW since the firmware_class specific discussions are now all scattered... but
some of this has also meant scattering a few ideas around other subsystems, I'm
keeping a wiki page up to date [3] with the latest pieces of agreed-upon things
and a few TODO things for firmware_class enhancements, and I'm throwing in
there the core kernel file loader updates as well as this userspace signal
thing, feel free to extend it as you see fit:

[3] http://kernelnewbies.org/KernelProjects/firmware-class-enhancements

>  static ssize_t ima_write_policy(struct file *file, const char __user *buf,
>  				size_t datalen, loff_t *ppos)
>  {
> @@ -288,7 +322,10 @@ static ssize_t ima_write_policy(struct file *file, const char __user *buf,
>  	if (copy_from_user(data, buf, datalen))
>  		goto out;
>  
> -	result = ima_parse_add_rule(data);
> +	if (data[0] == '/')
> +		result = ima_read_policy(data);
> +	else
> +		result = ima_parse_add_rule(data);
>  out:
>  	if (result < 0)
>  		valid_policy = 0;
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index 5efe2ec..5413f22 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -122,7 +122,7 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
>  
>  int integrity_kernel_read(struct file *file, loff_t offset,
>  			  char *addr, unsigned long count);
> -int __init integrity_read_file(const char *path, char **data);
> +int integrity_read_file(const char *path, char **data);
>  
>  #define INTEGRITY_KEYRING_EVM		0
>  #define INTEGRITY_KEYRING_IMA		1

Other than that, the idea looks fine as an option. Perhaps you may also want
to annotate the mechanism used as well, and later expose that?

  Luis
