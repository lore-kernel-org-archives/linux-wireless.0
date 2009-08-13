Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:40637 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbZHMTrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:47:08 -0400
Received: by pzk34 with SMTP id 34so708855pzk.4
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 12:47:09 -0700 (PDT)
Message-ID: <4A846DB9.8080802@lwfinger.net>
Date: Thu, 13 Aug 2009 14:47:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] b43: Update dummy transmission to match V4 specs
References: <4A842887.2080109@gmail.com> <200908131923.29847.mb@bu3sch.de>
In-Reply-To: <200908131923.29847.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Thursday 13 August 2009 16:51:51 Gábor Stefanik wrote:
>> The V4 dummy transmission has two extra bools in its prototype,
>> so update all callers with the 2 bools.
>>
>> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
>> ---
>> v2: Convert all callers to v4, and drop the v3->v4 wrapper.
> 
>> -	/* Commit writes */
>> -	b43_read32(dev, B43_MMIO_MACCTL);
> 
>> -	value = ((phy->type == B43_PHYTYPE_A) ? 1 : 0);
>> +	if (dev->dev->id.revision < 11)
>> +		b43_write16(dev, 0x07C0, 0x0000);
>> +	else
>> +		b43_write16(dev, 0x07C0, 0x0100);
>> +	value = (ofdm ? 0x41 : 0x40);
>>  	b43_write16(dev, 0x050C, value);
> 
> This patch changes G-PHY codepaths. Did you test it on (at least one) G-PHY device?
> 

My device with the 0x4312 ID still works with this patch applied.

Larry
