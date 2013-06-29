Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:57168 "EHLO
	mail.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab3F2LYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Jun 2013 07:24:19 -0400
Message-ID: <51CEC24F.3040609@openwrt.org> (sfid-20130629_132422_954579_1D416A8B)
Date: Sat, 29 Jun 2013 13:17:35 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH 02/19] rt2x00: rt2800lib: add RFCSR register initialization
 for RT3593
References: <51CE0330.7090007@gmail.com>
In-Reply-To: <51CE0330.7090007@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.06.28. 23:42 keltezéssel, Xose Vazquez Perez írta:
> Gabor Juhos wrote:
> 
>> Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
>> driver.
> 
> There is a more recent version: DPO_RT5572_LinuxSTA_2.6.1.3_20121022

Yes, I know. However I wanted to test AP mode with the vendor driver and that is
only supported in the '2.6.0.1_20120629' version.

> 
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index 32ecd1a..0041b2c 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> [...]
>> +	/* Initialize default register values */
>> +	rt2800_rfcsr_write(rt2x00dev, 1, 0x03);
>> +	rt2800_rfcsr_write(rt2x00dev, 3, 0x80);
> 
> from ./20120911_RT3573_Linux_STA_v2.5.0.0_Rev1_DPO/chips/rt3593.c
> 
> {RF_R02,                0x80}
> 
> but it was deleted in ./DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rt3593.c
> 
> Was it deliberate ? or a mistake ??

It is intentional. The patch is based on the *2.6.0.1* driver, and the value is
not present in that.

-Gabor


