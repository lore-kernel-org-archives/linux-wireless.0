Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f196.google.com ([209.85.216.196]:64901 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbZHNVd7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 17:33:59 -0400
Received: by pxi34 with SMTP id 34so461843pxi.4
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 14:34:00 -0700 (PDT)
Message-ID: <4A85D844.8040805@lwfinger.net>
Date: Fri, 14 Aug 2009 16:33:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Fix sparse warnings
References: <4a84906b.+IYGhiNLKPSjrrR7%Larry.Finger@lwfinger.net> <200908142215.38112.mb@bu3sch.de>
In-Reply-To: <200908142215.38112.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Friday 14 August 2009 00:15:07 Larry Finger wrote:
>> The b43 driver generates the following sparse warnings:
>>
>>   CHECK   drivers/net/wireless/b43/phy_g.c
>> drivers/net/wireless/b43/phy_g.c:974:35: warning: cast truncates bits from constant value (ffff7fff becomes 7fff)
>>   CHECK   drivers/net/wireless/b43/wa.c
>> drivers/net/wireless/b43/wa.c:385:53: warning: cast truncates bits from constant value (ffff00ff becomes ff)
>> drivers/net/wireless/b43/wa.c:403:48: warning: cast truncates bits from constant value (ffff00ff becomes ff)
>> drivers/net/wireless/b43/wa.c:405:48: warning: cast truncates bits from constant value (ffff00ff becomes ff)
>> drivers/net/wireless/b43/wa.c:415:50: warning: cast truncates bits from constant value (ffff0fff becomes fff)
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> John,
>>
>> There is no hurry for this material.
>>
>> Larry
>> ---
>>
>> Index: wireless-testing/drivers/net/wireless/b43/phy_g.c
>> ===================================================================
>> --- wireless-testing.orig/drivers/net/wireless/b43/phy_g.c
>> +++ wireless-testing/drivers/net/wireless/b43/phy_g.c
>> @@ -971,7 +971,7 @@ b43_radio_interference_mitigation_enable
>>  		b43_phy_maskset(dev, 0x04A2, 0xFFF0, 0x000B);
>>  
>>  		if (phy->rev >= 3) {
>> -			b43_phy_mask(dev, 0x048A, (u16)~0x8000);
>> +			b43_phy_mask(dev, 0x048A, (u16)(~0x8000 & 0xFFFF));
> 
> Uh come on...
> The u16 cast already is stupid as hell, but this is becoming braindead.
> The code is perfectly fine. Sparse should instead provide an option to disable
> this fragile check.

John,

Just drop this patch. The code is OK as is.

Larry
