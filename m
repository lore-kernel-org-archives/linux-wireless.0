Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:59522 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZBWRvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 12:51:45 -0500
Received: by wf-out-1314.google.com with SMTP id 28so2595915wfa.4
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 09:51:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c910902210731x46fab8a7qfecb276a66f7a890@mail.gmail.com>
References: <499C7DC0.4040608@lwfinger.net>
	 <1234992712.4023.60.camel@johannes.local>
	 <20090218220531.GD4246@tesla> <499C8DD2.7000800@lwfinger.net>
	 <20090218224833.GB28733@bombadil.infradead.org>
	 <69e28c910902201145h6d9fa472rc81da56ffce16dc0@mail.gmail.com>
	 <43e72e890902201233w95b4aaew1fa0bbf06196d74f@mail.gmail.com>
	 <69e28c910902201307i398b4a89na4ce0205d66ee921@mail.gmail.com>
	 <20090220234032.GB23428@bombadil.infradead.org>
	 <69e28c910902210731x46fab8a7qfecb276a66f7a890@mail.gmail.com>
Date: Mon, 23 Feb 2009 09:51:42 -0800
Message-ID: <43e72e890902230951x71e7d53fwcbcb6e89143b71d9@mail.gmail.com> (sfid-20090223_185207_645171_27CA14FF)
Subject: Re: ieee80211_regdom module parameter for cfg80211
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 21, 2009 at 7:31 AM, G=C3=A1bor Stefanik <netrolller.3d@gma=
il.com> wrote:
> On Sat, Feb 21, 2009 at 12:40 AM, Luis R. Rodriguez
> <mcgrof@bombadil.infradead.org> wrote:
>> On Fri, Feb 20, 2009 at 10:07:05PM +0100, G=C3=A1bor Stefanik wrote:
>>> On Fri, Feb 20, 2009 at 9:33 PM, Luis R. Rodriguez <mcgrof@gmail.co=
m> wrote:
>>> > On Fri, Feb 20, 2009 at 11:45 AM, G=C3=A1bor Stefanik
>>> > <netrolller.3d@gmail.com> wrote:
>>> >> On Wed, Feb 18, 2009 at 11:48 PM, Luis R. Rodriguez
>>> >> <mcgrof@bombadil.infradead.org> wrote:
>>> >>> On Wed, Feb 18, 2009 at 04:38:10PM -0600, Larry Finger wrote:
>>> >>>> Luis R. Rodriguez wrote:
>>> >>>> > On Wed, Feb 18, 2009 at 01:31:52PM -0800, Johannes Berg wrot=
e:
>>> >>>> >> On Wed, 2009-02-18 at 15:29 -0600, Larry Finger wrote:
>>> >>>> >>> On at least one forum, I have seen the recommendation that=
 a user set their
>>> >>>> >>> regulatory domain by creating the file /etc/modprobe.d/cfg=
80211 with the
>>> >>>> >>> contents "ieee80211_regdom=3DUS".
>>> >>>> >>>
>>> >>>> >>> That works as long as CONFIG_WIRELESS_OLD_REGULATORY is se=
t in their .config,
>>> >>>> >>> but will fail if it is not.
>>> >>>> >>>
>>> >>>> >>> Should the module_param statement be moved outside the ifd=
ef
>>> >>>> >>> CONFIG_WIRELESS_OLD...? Setting the module parameter that =
way might not make any
>>> >>>> >>> sense, but it surely shouldn't kill wireless.
>>> >>>> >> I actually see no reason to not just /honour/ it by calling=
 crda with
>>> >>>> >> its parameter if CONFIG_WIRELESS_OLD_REGULATORY isn't set.
>>> >>>> >
>>> >>>> > The idea was that things we want to get rid of will go in OL=
D_REG. Static regdoms
>>> >>>> > for US, JP and EU fall into that and so does the module para=
meter. I believe
>>> >>>> > it is silly to keep the module parameter around as we alread=
y have userspace
>>> >>>> > APIs to let users set this.
>>> >>>>
>>> >>>> I guess we leave it the way it is. At least the only people th=
at will get caught
>>> >>>> are those that upgrade their distro.
>>> >>>
>>> >>> Yeah, if they disable OLD_REG -- but I am curious which distrib=
utions are using this
>>> >>> themselves as well. Would you happen to know ? Or are you mostl=
y seeing just users
>>> >>> doing that themselves?
>>> >>
>>> >> Yes, I was talking about users doing this, users who upgrade the=
ir
>>> >> kernel without upgrading their distro. Keeping a modparam provid=
es an
>>> >> easy way for users to upgrade kernels without a full distro upgr=
ade -
>>> >> modparams have a much simpler syntax than init scripts. If we ke=
ep the
>>> >> modparam as a way to control CRDA, this is what an user has to d=
o to
>>> >> upgrade:
>>> >> 1. Compile and install the new kernel. (Mostly straightforward, =
as
>>> >> long as the user has a config and knows how to use make.)
>>> >> 2. Compile and install CRDA. (Straightforward.)
>>> >> 3. echo options cfg80211 ieee80211_regdom=3D"HU" >>
>>> >> /etc/modprobe.d/options (Straightforward.)
>>> >>
>>> >> Removing the modparam changes step 3 to:
>>> >> 3. Find the init scripts, and edit them to include "iw reg set H=
U",
>>> >> making sure it happens early enough, caring about the syntax, ta=
king
>>> >> into account differences between distros, etc. Possibly includes
>>> >> modifying the initramfs/initrd by hand in some odd distros. (Not
>>> >> straightforward at all, requires knowledge of the distro's inner
>>> >> workings, such as the init version used, e.g. sysvinit, bsdinit,
>>> >> upstart, etc.)
>>> >
>>> > It seems reasonable to keep the module parameter in case iw is no=
t
>>> > installed but if users went through the trouble of installing crd=
a are
>>> > we to not expect users to have iw also by 2.6.30?
>>> >
>>> >  Luis
>>> >
>>>
>>> I am not talking about the case when iw is not installed - even if =
iw
>>> is installed, it is much easier to edit the module options file tha=
n
>>> the init scripts.
>>
>> We should strive away from using module parameters and provided we h=
ave
>> a good userspace API it should be up to userspace to figure that stu=
ff out.
>>
>> Although an ieee80211_regdom module parameter may be convenient its =
not
>> productive towards what we want as well -- we shouldn't strive to le=
t your
>> module parameter be the only place to put your location information =
from
>> userspace. Say you suspend to ram, fly to another country -- you'd w=
ant
>> more of an intelligent usersapce figuring out your location for you =
and you
>> don't want it to muck with your module parameters.
>>
>>  Luis
>>
>
> In my proposal, the userspace can still override the regdom set in th=
e
> modparam - it is only for setting the initial regdomain. So, you
> suspend to ram, fly to another country, resume and if you have the
> right utilities installed, userspace will reconfigure your regdomain
> to match the current place. However, it is up to distributors to
> include such utilities, it is quite hard for users to install them
> from sources
> Distributors can also easily include the necessary CRDA command in
> their init scripts, but I am not talking about new distributions, but
> rather users who upgrade their kernel. Removing the modparam would
> amount to requiring users to either upgrade their distro or be
> absolutely confident editing all types of init scripts (be it
> sysvinit, bsdinit, upstart or some other apocryphal init program) to
> get a proper initial regdomain. (In fact, due to the lack of such
> modparam support, right now I am always doing "iw reg set HU" by hand
> on every boot, as I can't figure out how to properly edit the init
> scripts without YaST corrupting them upon the next system update!)
> New distros can do fancy userspace tricks like setting the regdomain
> based on GPS position, but for users of old distros who upgraded thei=
r
> kernel/installed compat-wireless, the choice is to either use only th=
e
> world regdomain channels (bad) or set regdomain by hand on every boot
> (inconvenient).
>
> So, here is a more "visual" approach to the proposal (in all of these
> examples, iw and crda are installed):
>
> Case 1: Compat-wireless installed on e.g. Ubuntu Intrepid, in Israel
> 1. System boots up. Cfg80211 from newly installed compat-wireless (an=
d
> NOT the one shipped by the distro) loads with regdom=3DIL.
> --- The regdomain is now Israel. Channels 12 and 13 are available. --=
-
> 2. During the init process, network startup is reached. The system
> auto-connects to ESSID "MyNET123", which is on channel 13. IP address
> assigned via DHCP.
> 3. When X starts up, the system is ready for the user to browse the w=
eb.
>
> Case 2: Same system if modparam support is removed
> 1. System boots up. Cfg80211 of compat-wireless loads. Initial
> regdomain is hardcoded to World.
> --- The regdomain is World. Only b/g channels 1-11 are available. ---
> 2. Network startup is reached. Auto-connect impossible, as channel 13
> is disabled.
> 3. X starts up, but no networking - the user must "iw reg set IL" and
> connect by hand, requiring root access.
>
> Case 3: Fedora 11 (with support for setting regdomain based on GPS - =
I
> hope it will!), in Germany (the user iften roams throughout Europe)
> 1. System boots up. Cfg80211 of the distro loads with regdom=3DEU.
> --- The regdomain is now EU. ---
> 2. The GPS device is initialized.
> 3. Upon network startup, location is identified as Darmstadt
> University, Germany, so "iw reg set DE" is called.
> --- The regdomain is now DE, which is correct. ---
> 4. Network startup continues, auto-connect to ESSID "Universit=C3=A4t=
" successful.
> 5. Upon X startup, wireless is up with regdom=3DDE.
> 6. User files to Denmark. Regdomain changes to DK.
>
> Case 4: Same system without modparam support:
> 1. System boots up. Cfg80211 of the distro loads with hardcoded "Worl=
d".
> --- The regdomain is now World. ---
> 2. The GPS device is initialized.
> 3. Upon network startup, location is identified as Darmstadt
> University, Germany, so "iw reg set DE" is called.
> --- The regdomain is now DE, which is correct. ---
> 4. Network startup continues, auto-connect to ESSID "Universit=C3=A4t=
" successful.
> 5. Upon X startup, wireless is up with regdom=3DDE.
> 6. User files to Denmark. Regdomain changes to DK.
>
> So, cases 3 and 4 (new, regdomain-aware distro) are equivalent from
> the user's standpoint - but case 1 (old, regdomain-unaware distro wit=
h
> compat-wireless adding "aftermarket" CRDA support) is much better tha=
n
> case 2.

If we enable passive scan on channels 12-14 on the world regdomain
(which it seems we should) that would cure this issue as well.
Thoughts?

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
