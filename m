Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34708 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbbH0X4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 19:56:48 -0400
Received: by obbfr1 with SMTP id fr1so32387433obb.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2015 16:56:47 -0700 (PDT)
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
Date: Thu, 27 Aug 2015 19:56:47 -0400
Message-ID: <CAHC9VhQFDcMtvn1JU3E1rJ=9CCXT7ibUocgGS4tzfcy8oVUUMA@mail.gmail.com> (sfid-20150828_015706_048238_78591B97)
Subject: Re: Linux Firmware Signing
From: Paul Moore <paul@paul-moore.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Kees Cook <keescook@chromium.org>,
	"Roberts, William C" <william.c.roberts@intel.com>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Eric Paris <eparis@parisplace.org>, selinux@tycho.nsa.gov,
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

On Thu, Aug 27, 2015 at 5:29 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Thu, Aug 27, 2015 at 10:57:23AM -0000, David Woodhouse wrote:
>
> SELinux uses: security_load_policy(data, len), refer to selinuxfs sel_load_ops.
> Since its write operation on its file_operation is sel_write_load() and that
> is as follows:
>
> static ssize_t sel_write_load(struct file *file, const char __user *buf,
>                               size_t count, loff_t *ppos)
> {
>         ...
> }
>
> We should be able to add yet-another LSM hook here to let the kernel / LSM have
> access to the inode, is that LSM hook desirable ? But folks, before you answer
> note that there's a growing trend here! Its point 1 Kees had made earlier.  I
> was hesitant to go into details as I think fw signing needs to be baked first
> but.. since we're reviewing all these details now it seems logical to go down
> the rabbit hole further.
>
> Everywhere where we fetch a file from within the kernel either directly (say
> firmware load, 802.11 regulatory request) or from userspace request (SELinux
> policy load node) we end up having to sprinkle a new LSM hook. In fact for
> modules and kexec there were syscalls added too. There might be a possiblity
> for sharing some of these requests / code so some review is in order for it.
>
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

While I question the usefulness of a SELinux policy signature in the
general case, there are some situations where it might make sense,
e.g. embedded systems with no post-build customizations, and I'm not
opposed to added a signature to the policy file for that reason.
However, I haven't given any serious thought yet to how we would
structure the new blob format so as to support both signed/unsigned
policies as well as existing policies which predate any PKCS #7
changes.

-- 
paul moore
www.paul-moore.com
