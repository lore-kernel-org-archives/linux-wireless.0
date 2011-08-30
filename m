Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49719 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1H3IbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 04:31:09 -0400
Received: by pzk37 with SMTP id 37so9922576pzk.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 01:31:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314685349.4011.17.camel@jlt3.sipsolutions.net>
References: <20110707002034.GA17885@broadcom.com>
	<20110824222801.GA5280@broadcom.com>
	<CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
	<20110827143513.GN3775@shale.localdomain>
	<20110827145003.GA9405@suse.de>
	<CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
	<20110827152144.GA10126@suse.de>
	<20110830014257.GI15771@broadcom.com>
	<20110830042802.GA15320@suse.de>
	<1314685349.4011.17.camel@jlt3.sipsolutions.net>
Date: Tue, 30 Aug 2011 10:31:08 +0200
Message-ID: <CACna6rzpce7x9cOAEbB04jTuawze5fG6cL1usNy79Yc-zExFwg@mail.gmail.com> (sfid-20110830_103116_097389_D9489030)
Subject: Re: [PATCH v2] Move brcm80211 to mainline
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg KH <gregkh@suse.de>, Henry Ptasinski <henryp@broadcom.com>,
	Dan Carpenter <error27@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/8/30 Johannes Berg <johannes@sipsolutions.net>:
> On Mon, 2011-08-29 at 21:28 -0700, Greg KH wrote:
>
>> > We understand the level of effort that it's taken for b43 to get as far as it
>> > has, and was implemented without access to proprietary information, and it has
>> > been impossible to support advanced chip features. We appreciate the difficulty
>> > of your task and respect your accomplishments tremendously!
>>
>> Then why not try to help out here?
>>
>> All other wireless companies have realized that this is the best way
>> forward over time.  Remember, b43 was here first, you need to play nice
>> with those developers.
>
> Well, truth be told, b43 was there first for older chipsets, and I
> played a major role in it existing back then. For the latest generation
> chips that are supported by the staging driver, that driver was there
> earlier and reverse engineering was ongoing even though code existed and
> could have been used. That code may not have been as clean, but the
> algorithms etc. are probably more tweaked & tuned to the chips.

That's tricky. We started implementing N-PHY code long before
brcm80211. When it was almost ready, Broadcom released brcm80211. Then
we released our version.
The interesting fast is however we duplicated N-PHY code without
supporting the same cards. b43 supported only SSB-based N-PHY cards,
while brcmsmac supported BCMA based N-PHY cards.
When we added BCMA support in b43, we automatically gained support for
BCMA & N-PHY devices like BCM43224 and BCM43225.

If you want to tell, which driver has support for 14e4:xyzq, then yes,
it can be brcmsmac. Which driver has first support for N-PHY? Both.
b43 got ~90% when brcm80211 was released.


>> You really need to work with the b43 developers here.
>
> I definitely agree with this. However, given the architectural
> differences in the device/ucode combination, I don't think support can
> be added to b43 easily.
>
>> Why can't you just do the small changes needed to the b43 driver to add
>> the missing functionality based on the fact that you know how the
>> hardware works?
>
> I don't think it would be small changes. Let me explain.
>
> What we can hope for is sharing of PHY/Radio code between b43 and
> brcmsmac. I'm sure this can be done in some way -- the PHY/Radio code
> should be taken from Broadcom's driver most likely, the code in b43
> isn't maintained by anyone with access to Si documentation & testing.
> Some form of abstraction layer exists in both drivers, but they're
> obviously not compatible at this point -- I believe this could be
> solved.
>
> However, on a higher level (MAC level) I believe that the drivers are
> quite different. There are a bunch of MAC features like multi-MAC
> support and probably soon P2P that b43 cannot support across the board
> due to the version of the uCode it is tied to, especially on older
> devices where such uCode never existed. New features, like P2P, will
> likely only be supported by new uCode on new devices -- I don't see
> Broadcom backporting & testing their new uCode, in most cases it
> probably won't even be possible due to device restrictions (*).
>
> As a result, I believe that attempting to share the MAC level code
> between b43 and brcmsmac will lead to a maintenance disaster, b43 would
> essentially be fragmented into lots of little code paths that depend on
> the uCode API in use. I don't think that's worth it -- we split
> b43/b43legacy for precisely that reason before.
>
> I'm not saying we should merge brcmsmac as is, but I do think attempting
> to push everything into b43 is bound to lead to lots of issues that we
> all don't want to see. Code sharing should be possible on some level,
> but at other levels it is fairly likely that code sharing would just
> lead to bigger problems down the road.

I got lost. You're talking a lot about ucode, but I don't know what do
you really mean. Do you have some additional info from Broadcom? Are
they going to release some new ucode not compatible with some older
cards?

At the moment b43 supports the newest known ucode which is 666.2.
brcmsmac uses older version 610.811.

-- 
Rafał
