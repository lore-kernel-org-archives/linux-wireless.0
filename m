Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44577 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab3CIL7n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 06:59:43 -0500
Message-ID: <513B2423.6010307@hauke-m.de> (sfid-20130309_125956_055263_0857011F)
Date: Sat, 09 Mar 2013 12:59:31 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH 00/13] b43: implement basic TX power mgmt
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com> <5138D7D7.5020204@lwfinger.net> <CACna6ryxn7+HqRkLJPA-k0dfR-FjVHDfZ+_uUAY_HxQrp3ODew@mail.gmail.com>
In-Reply-To: <CACna6ryxn7+HqRkLJPA-k0dfR-FjVHDfZ+_uUAY_HxQrp3ODew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/09/2013 12:20 PM, Rafał Miłecki wrote:
> 2013/3/7 Larry Finger <Larry.Finger@lwfinger.net>:
>> On 03/07/2013 09:47 AM, Rafał Miłecki wrote:
>>>
>>> After spotting a lot of N-PHY-similar functions in
>>> BCM4331 dump of MMIO ops - split into names parts
>>> I was able to finally improve HT-PHY code.
>>>
>>> It now sets TX basically, I can finally talk with devices that are few
>>> meters away, not just few centimetres. It's a little patch bomb, sorry
>>> for that, but I wasn't sure if my code is correct until it was complete
>>> and started working.
>>>
>>> Rafał Miłecki (13):
>>>    b43: HT-PHY: rename AFE defines
>>>    b43: HT-PHY: add classifier control function
>>>    b43: HT-PHY: move TX fix to the separated function
>>>    b43: HT-PHY: implement spurious tone avoidance
>>>    b43: HT-PHY: implement MAC reclocking
>>>    b43: HT-PHY: implement CCA reset
>>>    b43: HT-PHY: implement PA override
>>>    b43: HT-PHY: implement controlling TX power control
>>>    b43: HT-PHY: implement stopping sample tone playback
>>>    b43: HT-PHY: implement playing sample tone
>>>    b43: HT-PHY: implement RSSI polling
>>>    b43: HT-PHY: setup TX power control
>>>    b43: HT-PHY: enable basic TX power setup
>>>
>>>   drivers/net/wireless/b43/phy_ht.c |  603
>>> +++++++++++++++++++++++++++++++++----
>>>   drivers/net/wireless/b43/phy_ht.h |   77 ++++-
>>>   2 files changed, 613 insertions(+), 67 deletions(-)
>>
>>
>> What tree is used for these patches? Numbers 1-7 applied with offsets, and
>> some fuzz. Number 8 failed, and I quit trying there. I am using
>> wireless-testing that was a fresh pull yesterday after John rebased it.
> 
> Has anyone else tried to apply this patchset?
> 

I just applied them on wireless-testing/master without any problems,
last commit was 14c8aaa01066072600b13b9825c571e4ecf7c0e9
I haven't seen any fuzz or wrong offset warning.

Hauke
