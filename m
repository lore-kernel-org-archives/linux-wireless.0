Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38885 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab1LQScF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 13:32:05 -0500
Received: by wgbdr13 with SMTP id dr13so8251694wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2011 10:32:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EECDB5C.6020104@lwfinger.net>
References: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
	<4EECDB5C.6020104@lwfinger.net>
Date: Sat, 17 Dec 2011 19:32:04 +0100
Message-ID: <CACna6rxwzWngg+MKwFLvg6kRVzcKVSHSKyreW6HJL8jdxoj-Sg@mail.gmail.com> (sfid-20111217_193210_973327_71103E9C)
Subject: Re: [PATCH 0/8] b43: reoder functions in phy_n.c
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 17 grudnia 2011 19:11 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> On 12/17/2011 06:57 AM, Rafał Miłecki wrote:
>>
>> [APPLYING] This patchset is based on top of wireless-next with:
>> b43: mark some vars __maybe_unused in b43_nphy_pmu_spur_avoid
>> applied.
>>
>>
>> As noted on b43-dev, we got really messy in phy_n.c. Functions were
>> implemented quite randomly, with specs appering during development,
>> sometimes without knowing real mining of the routies.
>>
>> That resulted in code hard to read and with some not-so-nice early
>> declarations.
>>
>> This patches makes some cleaning with that code. It moves tons of LOCs,
>> but I think we have to do this finally instead of going deeper and
>> deeper into that mess.
>>
>> As Larry suggested, I've made small patches and tried my best to get
>> them formatted nicely, to have diffs really clean. I've been
>> compiling b43 after each patch, so there shouldn't be any build
>> breakage between.
>>
>> Rafał Miłecki (8):
>>   b43: N-PHY: reorder functions: put basic ones at beginning
>>   b43: N-PHY: reorder functions: collect radio ones
>>   b43: N-PHY: reorder functions: collect samples ones
>>   b43: N-PHY: reorder functions: collect RSSI selects
>>   b43: N-PHY: split gain control workarounds
>>   b43: N-PHY: reorder functions: move RSSI calibration
>>   b43: N-PHY: reorder functions: move rest of workarounds
>>   b43: N-PHY: reorder functions: random clenaups
>>
>>  drivers/net/wireless/b43/phy_n.c | 4575
>> +++++++++++++++++++-------------------
>>  1 files changed, 2301 insertions(+), 2274 deletions(-)
>
>
> ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> I like all these patches, and you don't have to change anything. Note, that
> cleanups is misspelled in the subject line for #8.

Thanks for looking at this :)

John: If you wish, you can fix my typo in subject line of 0008 :)

-- 
Rafał
