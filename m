Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50169 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab1KWO12 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 09:27:28 -0500
Received: by vcbfk14 with SMTP id fk14so356163vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 06:27:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111123100717.GA1761@vmraj-lnx.users.atheros.com>
References: <1321985402-14257-1-git-send-email-mcgrof@qca.qualcomm.com>
 <1321985402-14257-2-git-send-email-mcgrof@qca.qualcomm.com> <20111123100717.GA1761@vmraj-lnx.users.atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 23 Nov 2011 06:27:07 -0800
Message-ID: <CAB=NE6WVVTQZ9N8rhZCUduCq8Vw-Pn7rCCmg61LBLtibWVTEcQ@mail.gmail.com> (sfid-20111123_152732_561208_07F4431B)
Subject: Re: [PATCH 1/3] cfg80211: allow following country IE power for custom
 regdom cards
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, compat@orbit-lab.org,
	Paul Stewart <pstew@google.com>,
	Senthilkumar Balasubramanian <senthilb@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 23, 2011 at 2:07 AM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> On Tue, Nov 22, 2011 at 10:10:00AM -0800, Luis R. Rodriguez wrote:
>> By definition WIPHY_FLAG_STRICT_REGULATORY was intended to allow the
>> wiphy to adjust itself to the country IE power information if the
>> card had no regulatory data but we had no way to tell cfg80211 that if
>> the card also had its own custom regulatory domain (these are typically
>> custom world regulatory domains) that we want to follow the country IE's
>> noted values for power for each channel. We add support for this and
>> document it.
>>
>> This is not a critical fix but a performance optimization for cards
>> with custom regulatory domains that associate to an AP with sends
>> out country IEs with a higher EIRP than the one on the custom
>> regulatory domain. In practice the only driver affected right now
>> are the Atheros drivers as they are the only drivers using both
>> WIPHY_FLAG_STRICT_REGULATORY and WIPHY_FLAG_CUSTOM_REGULATORY --
>> used on cards that have an Atheros world regulatory domain. Cards
>> that have been programmed to follow a country specifically will not
>> follow the country IE power. So although not a stable fix distributions
>> should consider cherry picking this.
>>
> Luis,
>
> After some testing, I noticed that the incresed power value seems to be
> remained after the disconnection. So while falling back to world
> regulatory domain the band updations are ignored at ignore_reg_update.
> If the driver follows STRICT_REGULATORY, the it should not be ignored.
> isn't it?

I'll look into this, thanks for testing. John please hold off on these
patches, I will respin them along with my stable fixes.

 Luis
