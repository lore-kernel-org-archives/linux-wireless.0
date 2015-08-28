Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36471 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbbH1W0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2015 18:26:07 -0400
Received: by oibi18 with SMTP id i18so2856886oib.3
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2015 15:26:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC560105ABD6@ORSMSX103.amr.corp.intel.com>
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
	<CAHC9VhQFDcMtvn1JU3E1rJ=9CCXT7ibUocgGS4tzfcy8oVUUMA@mail.gmail.com>
	<476DC76E7D1DF2438D32BFADF679FC560105ABD6@ORSMSX103.amr.corp.intel.com>
Date: Fri, 28 Aug 2015 18:26:05 -0400
Message-ID: <CAHC9VhRF-39ZbwawkM-aR+th2nRPEVF9-nR1NEHDPDmakpt4FQ@mail.gmail.com> (sfid-20150829_002612_210339_E70905D8)
Subject: Re: Linux Firmware Signing
From: Paul Moore <paul@paul-moore.com>
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	David Woodhouse <dwmw2@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Kees Cook <keescook@chromium.org>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Eric Paris <eparis@parisplace.org>,
	"selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Jones <pjones@redhat.com>, Takashi Iwai <tiwai@suse.de>,
	Ming Lei <ming.lei@canonical.com>, Joey Lee <jlee@suse.de>,
	=?UTF-8?Q?Vojtech_Pavl=C3=ADk?= <vojtech@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 28, 2015 at 7:20 AM, Roberts, William C
<william.c.roberts@intel.com> wrote:
>> -----Original Message-----
>> From: Paul Moore [mailto:paul@paul-moore.com]
>> Sent: Thursday, August 27, 2015 4:57 PM
>> To: Luis R. Rodriguez
>> Cc: David Woodhouse; David Howells; Mimi Zohar; Andy Lutomirski; Kees Cook;
>> Roberts, William C; linux-security-module@vger.kernel.org; linux-
>> kernel@vger.kernel.org; linux-wireless@vger.kernel.org;
>> james.l.morris@oracle.com; serge@hallyn.com; Vitaly Kuznetsov; Eric Paris;
>> selinux@tycho.nsa.gov; Stephen Smalley; Schaufler, Casey; Luis R. Rodriguez;
>> Dmitry Kasatkin; Greg Kroah-Hartman; Peter Jones; Takashi Iwai; Ming Lei; Joey
>> Lee; Vojtěch Pavlík; Kyle McMartin; Seth Forshee; Matthew Garrett; Johannes
>> Berg
>> Subject: Re: Linux Firmware Signing
>>
>> On Thu, Aug 27, 2015 at 5:29 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>> > On Thu, Aug 27, 2015 at 10:57:23AM -0000, David Woodhouse wrote:
>> >
>> > SELinux uses: security_load_policy(data, len), refer to selinuxfs sel_load_ops.
>> > Since its write operation on its file_operation is sel_write_load()
>> > and that is as follows:
>> >
>> > static ssize_t sel_write_load(struct file *file, const char __user *buf,
>> >                               size_t count, loff_t *ppos) {
>> >         ...
>> > }
>> >
>> > We should be able to add yet-another LSM hook here to let the kernel /
>> > LSM have access to the inode, is that LSM hook desirable ? But folks,
>> > before you answer note that there's a growing trend here! Its point 1
>> > Kees had made earlier.  I was hesitant to go into details as I think
>> > fw signing needs to be baked first but.. since we're reviewing all
>> > these details now it seems logical to go down the rabbit hole further.
>> >
>> > Everywhere where we fetch a file from within the kernel either
>> > directly (say firmware load, 802.11 regulatory request) or from
>> > userspace request (SELinux policy load node) we end up having to
>> > sprinkle a new LSM hook. In fact for modules and kexec there were
>> > syscalls added too. There might be a possiblity for sharing some of these
>> requests / code so some review is in order for it.
>> >
>> > Here's my review if we wanted to try sharing things, in consideration
>> > and review of:
>> >
>> >   * SELinux policy files
>> >   * modules
>> >   * firmware / system data (consider replacing CRDA)
>> >   * kexec
>> >
>> > ----
>> >
>> >   * SELinux policy files:
>> >
>> > sel_write_load() is very specific, its part of the selinuxfs and it
>> > just uses copy_from_user() to dump the data from the file onto a
>> > vmalloc'd piece of memory. We don't exactly read arbitrary files from the fs
>> then.
>> > If we *really* wanted to generalize things further we probably could
>> > but I'm not going to lead any discussion about design over selinuxfs,
>> > I'll let the folks behind it think about that themselves.
>>
>> While I question the usefulness of a SELinux policy signature in the general case,
>> there are some situations where it might make sense, e.g. embedded systems
>> with no post-build customizations, and I'm not opposed to added a signature to
>> the policy file for that reason.
>
> Even triggered updates make sense, since you can at least have some form of trust
> of where that binary policy came from.

It isn't always that simple, see my earlier comments about
customization and manipulation by the policy loading tools.  Policy
signatures are nice, I support their addition, but I believe they will
only be useful for certain usage scenarios and not really usable for
general systems.

>> However, I haven't given any serious thought yet to how we would structure the
>> new blob format so as to support both signed/unsigned policies as well as
>> existing policies which predate any PKCS #7 changes.
>
> Huh, not following? Perhaps, I am not following what your laying down here.
>
>  Right now there is no signing on the selinux policy file. We should be able
> to just use the firmware signing api's as is (I have not looked on linux-next yet)
> to unpack the blob.

I haven't looked at the existing fw signing hook in any detail to be
able to comment on its use as a policy verification hook.  As long as
we preserve backwards compatibility and don't introduce a new
mechanism/API for loading SELinux policy I doubt I would have any
objections.

> In the case of falling back to loading an unsigned blob, we could do it ala kernel
> module style. If it fails do to invalid format fall back to attempting to read it as a straight policy file.

It seems like we could aim to do a bit better than try-and-see, but
once again, I haven't looked at yet in detail so I'll defer to you
judgement at this point.

> If it fails on signature verification, we could still unpack it and pass it on. So you would want to
> be able to control if the signed unpacking from pkcs7 fails, whether or not its fatal.
>
> We would also likely want to convey this state, the ability to change this setting to userspace in a
> Controlled fashion via selinuxfs. Ie I would want to know that I can load modules without valid signatures,
> And that my current policy file is in fact invalid or valid.

That sounds reasonable to me.

>> --
>> paul moore
>> www.paul-moore.com



-- 
paul moore
www.paul-moore.com
