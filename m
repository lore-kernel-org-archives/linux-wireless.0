Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:34964 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab3CILU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 06:20:27 -0500
Received: by mail-oa0-f42.google.com with SMTP id i18so3050151oag.15
        for <linux-wireless@vger.kernel.org>; Sat, 09 Mar 2013 03:20:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5138D7D7.5020204@lwfinger.net>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
	<5138D7D7.5020204@lwfinger.net>
Date: Sat, 9 Mar 2013 12:20:26 +0100
Message-ID: <CACna6ryxn7+HqRkLJPA-k0dfR-FjVHDfZ+_uUAY_HxQrp3ODew@mail.gmail.com> (sfid-20130309_122039_911092_2E8B983E)
Subject: Re: [PATCH 00/13] b43: implement basic TX power mgmt
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/7 Larry Finger <Larry.Finger@lwfinger.net>:
> On 03/07/2013 09:47 AM, Rafał Miłecki wrote:
>>
>> After spotting a lot of N-PHY-similar functions in
>> BCM4331 dump of MMIO ops - split into names parts
>> I was able to finally improve HT-PHY code.
>>
>> It now sets TX basically, I can finally talk with devices that are few
>> meters away, not just few centimetres. It's a little patch bomb, sorry
>> for that, but I wasn't sure if my code is correct until it was complete
>> and started working.
>>
>> Rafał Miłecki (13):
>>    b43: HT-PHY: rename AFE defines
>>    b43: HT-PHY: add classifier control function
>>    b43: HT-PHY: move TX fix to the separated function
>>    b43: HT-PHY: implement spurious tone avoidance
>>    b43: HT-PHY: implement MAC reclocking
>>    b43: HT-PHY: implement CCA reset
>>    b43: HT-PHY: implement PA override
>>    b43: HT-PHY: implement controlling TX power control
>>    b43: HT-PHY: implement stopping sample tone playback
>>    b43: HT-PHY: implement playing sample tone
>>    b43: HT-PHY: implement RSSI polling
>>    b43: HT-PHY: setup TX power control
>>    b43: HT-PHY: enable basic TX power setup
>>
>>   drivers/net/wireless/b43/phy_ht.c |  603
>> +++++++++++++++++++++++++++++++++----
>>   drivers/net/wireless/b43/phy_ht.h |   77 ++++-
>>   2 files changed, 613 insertions(+), 67 deletions(-)
>
>
> What tree is used for these patches? Numbers 1-7 applied with offsets, and
> some fuzz. Number 8 failed, and I quit trying there. I am using
> wireless-testing that was a fresh pull yesterday after John rebased it.

Has anyone else tried to apply this patchset?

-- 
Rafał
