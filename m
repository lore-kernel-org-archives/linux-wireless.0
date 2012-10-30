Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36922 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171Ab2J3NYY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 09:24:24 -0400
Message-ID: <508FD505.4080404@openwrt.org> (sfid-20121030_142428_008693_07D415D6)
Date: Tue, 30 Oct 2012 14:24:21 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	sven@narfation.org, Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] ath9k: apply coverage class on slottime too
References: <1351598855-21427-1-git-send-email-siwu@hrz.tu-chemnitz.de> <508FCB77.9000303@openwrt.org> <508FCF5A.2080204@fokus.fraunhofer.de>
In-Reply-To: <508FCF5A.2080204@fokus.fraunhofer.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-30 2:00 PM, Mathias Kretschmer wrote:
> On 10/30/2012 01:43 PM, Felix Fietkau wrote:
>> On 2012-10-30 1:07 PM, Simon Wunderlich wrote:
>>> From: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
>>>
>>> According to 802.11-2007 17.3.8.6 (slot time), the slot time should
>>> be increased by 3 us * coverage class. The code only increased the
>>> ack timeout, which is fixed by this patch.
>>>
>>> We have noticed in our long shot scenario that we see less collisions
>>> with this patch.
>> At some point I had the slot time increase in the driver, but noticed a
>> massive throughput degradation on 10-20 km links. Leaving the slot time
>> alone and changing only the ACK timeout fixed this. What distances did
>> you test?
> 
> about 11km. did you test UDP (unidirectional) or TCP (bidirectional) throughput ?
I always use TCP, because UDP tests are too unrealistic to estimate real
performance.

> The larger slot time will increase the channel access overhead which should impact 
> unidirectional throughput.
> 
> With bidirectional traffic, the larger slottime should help to minimize collisions 
> on loaded links. Overall this seems to increase the net throughput for us, 
> especially in higher access categories (smaller backoff windows).
When I ran the test, the throughput degradation was so big that the
links became almost useless. It was a long time ago, so maybe this was
caused by another bug that has been fixed since. I will run another test
with this patch in a current version...

- Felix
