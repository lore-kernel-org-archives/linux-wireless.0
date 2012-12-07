Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-relay04-haj2.antispameurope.com ([83.246.65.204]:43197 "EHLO
	mx-relay04-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964900Ab2LGMoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 07:44:05 -0500
Message-ID: <50C1E2A5.40206@fokus.fraunhofer.de> (sfid-20121207_134409_967615_04934EB6)
Date: Fri, 7 Dec 2012 13:35:49 +0100
From: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@venema.h4ckr.net>,
	<linville@tuxdriver.com>, <mcgrof@qca.qualcomm.com>,
	<sven@narfation.org>, Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] ath9k: apply coverage class on slottime too
References: <1351598855-21427-1-git-send-email-siwu@hrz.tu-chemnitz.de> <508FCB77.9000303@openwrt.org>
In-Reply-To: <508FCB77.9000303@openwrt.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

On 10/30/2012 01:43 PM, Felix Fietkau wrote:
> On 2012-10-30 1:07 PM, Simon Wunderlich wrote:
>> From: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
>>
>> According to 802.11-2007 17.3.8.6 (slot time), the slot time should
>> be increased by 3 us * coverage class. The code only increased the
>> ack timeout, which is fixed by this patch.
>>
>> We have noticed in our long shot scenario that we see less collisions
>> with this patch.
> At some point I had the slot time increase in the driver, but noticed a
> massive throughput degradation on 10-20 km links. Leaving the slot time
> alone and changing only the ACK timeout fixed this. What distances did
> you test?
>
> - Felix
>

We've run some tests on a 5km .11a link to verify the proper functioning of this 
patch (slot time depending on coverage class) and the recent patch to ensure the 
shorter (9us) slot time is used in .11a adhoc mode.

According to the standard, the slot time should be calculated as follows:

slottime = 9us + 3 * ah->coverage_class;

For our link, this would be

slottime = 9 us + 3 * 10 = 39 us.   (coverage class 10: up to 4950 m)

If you look at the below TSFT histogram and try to determine the peaks
(first column: diffTime, second column: frameCount), the slot time turns out to be 
roughly 39us, which fits pretty nicely with the expected result.

The TCP throughput (wget -O /dev/null) was very constant between 1.7 and 1.8 
MByte/s. Which, I'd say, is pretty decent for such a link (without TxOp, etc).

Similar measurements for a 10km link, reveal a slot time of about 71us, which also 
matches the theoretical figure pretty well:

slottime = 9us + 3 * 21 = 72

Therefore, both patches seem to ensure a proper MAC timing while yielding proper 
throughput.

Cheers,

Mathias

------------

=== TSFT Histogram (times in us) of 00:00:00:00:00:00, age 66s ===
411,945
412,5921
413,1534
450,1271
451,4286
452,1804
490,5592
491,731
528,773
529,3482
530,1177
567,693
568,3071
569,1022
599,552
607,3659
608,486
637,266
638,737
639,437
645,782
646,2103
647,929
677,1525
678,560
684,463
685,2337
686,589
715,276
716,1630
717,704
754,424
755,1518
756,889
794,2347
795,796
832,420
833,1800
834,891
975,315
1014,329
1015,257



