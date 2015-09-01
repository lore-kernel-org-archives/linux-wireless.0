Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34375 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbbIACwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 22:52:07 -0400
Received: by oiex83 with SMTP id x83so76236728oie.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 19:52:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150829020301.GM8051@wotan.suse.de>
References: <1440462367.2737.4.camel@linux.vnet.ibm.com>
	<CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
	<1440464705.2737.36.camel@linux.vnet.ibm.com>
	<14540.1440599584@warthog.procyon.org.uk>
	<31228.1440671938@warthog.procyon.org.uk>
	<36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org>
	<20150827212907.GF8051@wotan.suse.de>
	<CAHC9VhQFDcMtvn1JU3E1rJ=9CCXT7ibUocgGS4tzfcy8oVUUMA@mail.gmail.com>
	<476DC76E7D1DF2438D32BFADF679FC560105ABD6@ORSMSX103.amr.corp.intel.com>
	<CAHC9VhRF-39ZbwawkM-aR+th2nRPEVF9-nR1NEHDPDmakpt4FQ@mail.gmail.com>
	<20150829020301.GM8051@wotan.suse.de>
Date: Mon, 31 Aug 2015 22:52:05 -0400
Message-ID: <CAHC9VhTTRr7N2bqU-7jm2oG72t5wgqH_SmXk4icqs3h3_=EMzg@mail.gmail.com> (sfid-20150901_045212_322584_E1C64AE4)
Subject: Re: Linux Firmware Signing
From: Paul Moore <paul@paul-moore.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Roberts, William C" <william.c.roberts@intel.com>,
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

On Fri, Aug 28, 2015 at 10:03 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Fri, Aug 28, 2015 at 06:26:05PM -0400, Paul Moore wrote:
>> On Fri, Aug 28, 2015 at 7:20 AM, Roberts, William C
>> <william.c.roberts@intel.com> wrote:
>> > Even triggered updates make sense, since you can at least have some form of trust
>> > of where that binary policy came from.
>>
>> It isn't always that simple, see my earlier comments about
>> customization and manipulation by the policy loading tools.
>
> If the customization of the data is done in kernel then the kernel
> can *first* verify the file's signature prior to doing any data
> modification. If userspace does the modification then the signature
> stuff won't work unless the tool will have access to the MOK and can
> sign it pre-flight to the kernel selinuxfs.

Yes, userspace does the modification.

>> > Huh, not following? Perhaps, I am not following what your laying down here.
>> >
>> >  Right now there is no signing on the selinux policy file. We should be able
>> > to just use the firmware signing api's as is (I have not looked on linux-next yet)
>> > to unpack the blob.
>>
>> I haven't looked at the existing fw signing hook in any detail to be
>> able to comment on its use as a policy verification hook.  As long as
>> we preserve backwards compatibility and don't introduce a new
>> mechanism/API for loading SELinux policy I doubt I would have any
>> objections.
>
> You'd just have to implement a permissive model as we are with the
> fw signing. No radical customizations, except one thing to note is
> that on the fw signing side of things we're going to have the signature
> of the file *detached* in separate file. I think what you're alluding
> to is the issue of where that signature would be stuff in the SELinux
> policy file and its correct that you'd need to address that. You could
> just borrow the kernel's model and reader / sucker that strips out the
> signature. Another possibility would be two files but then I guess
> you'd need a trigger to annotate both are in place.

Yes, there are lots of way we could solve the signed policy format
issue, I just don't have one in mind at this moment.  Also, to be
honest, there are enough limitations to signing SELinux policies that
this isn't very high on my personal SELinux priority list.

-- 
paul moore
www.paul-moore.com
