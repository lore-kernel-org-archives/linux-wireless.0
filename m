Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33865 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbbIAUUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 16:20:38 -0400
Received: by iofb144 with SMTP id b144so15270445iof.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2015 13:20:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150827212907.GF8051@wotan.suse.de>
References: <20150824225713.GJ8051@wotan.suse.de>
	<CAGXu5jLDHCgygaVNHpuvszN6SXNKAjRW83q3-D2ZfRpO4uAmdw@mail.gmail.com>
	<476DC76E7D1DF2438D32BFADF679FC5601058E78@ORSMSX103.amr.corp.intel.com>
	<CAGXu5jJuwPfnQhu9u4-90UkmjWTBF_GLpJ7J1VaaT2D0d_-Mhg@mail.gmail.com>
	<1440462367.2737.4.camel@linux.vnet.ibm.com>
	<CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
	<1440464705.2737.36.camel@linux.vnet.ibm.com>
	<14540.1440599584@warthog.procyon.org.uk>
	<31228.1440671938@warthog.procyon.org.uk>
	<36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org>
	<20150827212907.GF8051@wotan.suse.de>
Date: Tue, 1 Sep 2015 13:20:37 -0700
Message-ID: <CAGXu5jKF6CBAADoybZHRCzYAepcZYqpbck1gTAeV1p7iuOVAvw@mail.gmail.com> (sfid-20150901_222054_324370_1F1916E9)
Subject: Re: Linux Firmware Signing
From: Kees Cook <keescook@chromium.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Andy Lutomirski <luto@amacapital.net>,
	"Roberts, William C" <william.c.roberts@intel.com>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@parisplace.org>,
	SE Linux <selinux@tycho.nsa.gov>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Jones <pjones@redhat.com>, Takashi Iwai <tiwai@suse.de>,
	Ming Lei <ming.lei@canonical.com>, Joey Lee <jlee@suse.de>,
	=?UTF-8?B?Vm9qdMSbY2ggUGF2bMOtaw==?= <vojtech@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 27, 2015 at 2:29 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Thu, Aug 27, 2015 at 10:57:23AM -0000, David Woodhouse wrote:
>> In conversation with Mimi last week she was very keen on the model where
>> we load modules & firmware in such a fashion that the kernel has access to
>> the original inode -- by passing in a fd,
>
> Sure, so let's be specific to ensure what Mimi needs is there. I though there

It's not just IMA: the loadpin LSM needs an fd also (to tie back to dm-verity).

> Right so now that firmware usermode helper is behind us (systemd ripped it) we
> do the fs lookup directly ourselves. One of my side goals with the extensible

Totally agreed: nothing uses the usermode helper any more, so we
should ignore that moving forward.

> I was under the impression that work was needed to add an LSM hook which would
> grant the LSM access to the file specific data for modules but that's already
> there with finit_module()! So Mimi needs is already there for modules as well
> now.

Nope, this was all already done. The kexec loading interface was also
designed so that I could add an LSM hook for it without lots of work.

> We have no LSM hook for kexec, even though the kernel does have access to the
> fd, so if you wanted the struct file for an LSM it should be possible as the
> syscall for kexec is:

I can send a patch to add this; it should be trivial. :) (It's not
high on my TODO list at the moment just because Chrome OS doesn't use
kexec.)

> Everywhere where we fetch a file from within the kernel either directly (say
> firmware load, 802.11 regulatory request) or from userspace request (SELinux
> policy load node) we end up having to sprinkle a new LSM hook. In fact for
> modules and kexec there were syscalls added too. There might be a possiblity
> for sharing some of these requests / code so some review is in order for it.

Those syscalls were needed because the original ones were designed a
long time ago. :)

> Here's my review if we wanted to try sharing things, in consideration and
> review of:
>
>   * SELinux policy files
>   * modules
>   * firmware / system data (consider replacing CRDA)
>   * kexec
>
> ----
>
>   * SELinux policy files:
>
> sel_write_load() is very specific, its part of the selinuxfs and it just
> uses copy_from_user() to dump the data from the file onto a vmalloc'd
> piece of memory. We don't exactly read arbitrary files from the fs then.
> If we *really* wanted to generalize things further we probably could
> but I'm not going to lead any discussion about design over selinuxfs,
> I'll let the folks behind it think about that themselves.
>
>   * modules
>   * firmware / system data
>
> modules + firmware: there seems to be some code sharing we could possibly do
> for both fw_read_file() and copy_module_from_fd(), note we are going to use
> different keys for vetting each of these. It may be possible to share the
> LSM hook here. All parties would just need to agree.

As long as the LSM know what kind of file it's loading, and has access
to the fd (and for IMA, the blob loaded from that fd), that should be
everything it needs. IMA has the name and blob, loadpin has the fd,
and a future signature-checking LSM could be able to look up signature
type from the load type, and split the key off (or fetch the key file)
itself.

If we expect to stack signature checkers, we can optimize the
signature parsing/loading infrastructure then. But since we have
neither the sigchecking LSM nor multiple ones, we can leave that to
later.

>
>   * kexec
>
> kexec works by reading files and setting up pointers for the different
> segments it needs for bootup, it does this for both the kernel and initrd
> if present. It however uses its own copy_file_from_fd() routine and no
> surprise here, there's code that can be shared as well. We'd be using
> a separate signature for kexec, so that'd be vetted on its own already.
> It may be possible to share the same LSM hook here, again all parties
> would just need to agree.
>
> ----
>
> So conclusion:
>
> After fw signing gets baked (or I'll do that as I work with the system data
> helpers) there is possible work here to consolidate firmware's fw_read_file(),
> module's fw_read_file(), and kexec's copy_file_from_fd() into a core kernel
> tiny helper that gets it done right for all. If we really wanted to we could
> also just use the same LSM hook for all, this hook would surely have the
> struct file as Mimi wants as well. Unless I misunderstood things, at the
> Linux security summit it seemed folks thought this was reasonable and
> desirable. One of the gains then would be that the kernel can grow for
> different use cases and files can be fetched as needed but we wouldn't have to
> add yet-another-LSM hook for each new purpose, we'd just be sharing the same
> fetch / LSM hook. Please discuss and let me know if this still stands, I'll
> work towards any agreed upon direction with the fw signing code.
>
> And again, there may other parts of the kernel that do similar work, just
> as we found out about SELinux policy files. Those need to be identified
> and studied separatley. I guess we can use grammar to hunt these down.
>
>   Luis

-Kees

-- 
Kees Cook
Chrome OS Security
