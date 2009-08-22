Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57545 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751448AbZHVVDk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 17:03:40 -0400
Message-ID: <4A905D2B.9090405@gmx.de>
Date: Sat, 22 Aug 2009 23:03:39 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFT] ar9170: use eeprom's frequency calibration values
References: <200908212252.41053.chunkeey@web.de> <4A8F2F71.1010100@gmx.de> <200908220151.19792.chunkeey@web.de>
In-Reply-To: <200908220151.19792.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/22/2009 01:51 AM, Christian Lamparter wrote:
> On Saturday 22 August 2009 01:36:17 Joerg Albert wrote:
>> On 08/21/2009 10:52 PM, Christian Lamparter wrote:
>>> This patch adds some more bits from the vendor driver, which
>>> are supposed to help users with the one-stage/openfw firmwares.
>> The otus driver sets phy registers 672-703 only for the one-stage firmware -
>> hal/hpmain.c, line 3445:
>>
>>         #ifndef ZM_OTUS_LINUX_PHASE_2
>>         reg_write(regAddr + i, val);  /* CR672 */
>>         #endif
>>
>> Are you sure it doesn't hurt with the two-stage firmware?
> no idea, that's why I ask requested input, instead of posting a patch +
> sob right away.
> 
> so far, I haven't heard of or experienced any regressions or anomalies.
> Do you already have comments or complains? :)

Your patch works fine here with a WNDA3100, using the two-stage firmware, against
a 802.11g AP. After "iwconfig wlan1 rate 54M" I get approx. 22 MBit/s throughput
with iperf, same as without the patch.

> Unfortunately, my device (WNDA3100) still doesn't work properly
> with either version at phy-rates beyond the magic 18MBit barrier.

Strange, same device here (or another hw version? FCC ID: PY307300073)
and I see packets @ 54M from the dev in the sniffer. But it also has the
invalid regdomain 0x8000 in the eeprom ...

With the one-stage firmware and without your patch my device doesn't associate with the AP,
seems like no packets are sent. So I can't test your patch with the one-stage fw.
Same result with a AVM Fritz stick.
I'll look into bisecting.

Regards,
Joerg.
