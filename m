Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:15855 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbZBTUdg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 15:33:36 -0500
Received: by wf-out-1314.google.com with SMTP id 28so1343331wfa.4
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 12:33:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c910902201145h6d9fa472rc81da56ffce16dc0@mail.gmail.com>
References: <499C7DC0.4040608@lwfinger.net>
	 <1234992712.4023.60.camel@johannes.local>
	 <20090218220531.GD4246@tesla> <499C8DD2.7000800@lwfinger.net>
	 <20090218224833.GB28733@bombadil.infradead.org>
	 <69e28c910902201145h6d9fa472rc81da56ffce16dc0@mail.gmail.com>
Date: Fri, 20 Feb 2009 12:33:35 -0800
Message-ID: <43e72e890902201233w95b4aaew1fa0bbf06196d74f@mail.gmail.com> (sfid-20090220_213341_358264_D073CD56)
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

On Fri, Feb 20, 2009 at 11:45 AM, G=C3=A1bor Stefanik
<netrolller.3d@gmail.com> wrote:
> On Wed, Feb 18, 2009 at 11:48 PM, Luis R. Rodriguez
> <mcgrof@bombadil.infradead.org> wrote:
>> On Wed, Feb 18, 2009 at 04:38:10PM -0600, Larry Finger wrote:
>>> Luis R. Rodriguez wrote:
>>> > On Wed, Feb 18, 2009 at 01:31:52PM -0800, Johannes Berg wrote:
>>> >> On Wed, 2009-02-18 at 15:29 -0600, Larry Finger wrote:
>>> >>> On at least one forum, I have seen the recommendation that a us=
er set their
>>> >>> regulatory domain by creating the file /etc/modprobe.d/cfg80211=
 with the
>>> >>> contents "ieee80211_regdom=3DUS".
>>> >>>
>>> >>> That works as long as CONFIG_WIRELESS_OLD_REGULATORY is set in =
their .config,
>>> >>> but will fail if it is not.
>>> >>>
>>> >>> Should the module_param statement be moved outside the ifdef
>>> >>> CONFIG_WIRELESS_OLD...? Setting the module parameter that way m=
ight not make any
>>> >>> sense, but it surely shouldn't kill wireless.
>>> >> I actually see no reason to not just /honour/ it by calling crda=
 with
>>> >> its parameter if CONFIG_WIRELESS_OLD_REGULATORY isn't set.
>>> >
>>> > The idea was that things we want to get rid of will go in OLD_REG=
=2E Static regdoms
>>> > for US, JP and EU fall into that and so does the module parameter=
=2E I believe
>>> > it is silly to keep the module parameter around as we already hav=
e userspace
>>> > APIs to let users set this.
>>>
>>> I guess we leave it the way it is. At least the only people that wi=
ll get caught
>>> are those that upgrade their distro.
>>
>> Yeah, if they disable OLD_REG -- but I am curious which distribution=
s are using this
>> themselves as well. Would you happen to know ? Or are you mostly see=
ing just users
>> doing that themselves?
>
> Yes, I was talking about users doing this, users who upgrade their
> kernel without upgrading their distro. Keeping a modparam provides an
> easy way for users to upgrade kernels without a full distro upgrade -
> modparams have a much simpler syntax than init scripts. If we keep th=
e
> modparam as a way to control CRDA, this is what an user has to do to
> upgrade:
> 1. Compile and install the new kernel. (Mostly straightforward, as
> long as the user has a config and knows how to use make.)
> 2. Compile and install CRDA. (Straightforward.)
> 3. echo options cfg80211 ieee80211_regdom=3D"HU" >>
> /etc/modprobe.d/options (Straightforward.)
>
> Removing the modparam changes step 3 to:
> 3. Find the init scripts, and edit them to include "iw reg set HU",
> making sure it happens early enough, caring about the syntax, taking
> into account differences between distros, etc. Possibly includes
> modifying the initramfs/initrd by hand in some odd distros. (Not
> straightforward at all, requires knowledge of the distro's inner
> workings, such as the init version used, e.g. sysvinit, bsdinit,
> upstart, etc.)

It seems reasonable to keep the module parameter in case iw is not
installed but if users went through the trouble of installing crda are
we to not expect users to have iw also by 2.6.30?

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
