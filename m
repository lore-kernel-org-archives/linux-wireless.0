Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-relay12-muc.antispameurope.com ([217.64.175.212]:54720 "EHLO
	mx-relay12-muc.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158Ab2J3NOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 09:14:04 -0400
Message-ID: <508FCF5A.2080204@fokus.fraunhofer.de> (sfid-20121030_141408_561331_2A693278)
Date: Tue, 30 Oct 2012 14:00:10 +0100
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

about 11km. did you test UDP (unidirectional) or TCP (bidirectional) throughput ?

The larger slot time will increase the channel access overhead which should impact 
unidirectional throughput.

With bidirectional traffic, the larger slottime should help to minimize collisions 
on loaded links. Overall this seems to increase the net throughput for us, 
especially in higher access categories (smaller backoff windows).

Cheers,

Mathias

