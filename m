Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50221 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbbINHrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 03:47:19 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 4.3] ath10k: fix DMA related firmware crashes on multiple devices
References: <1442176540-34973-1-git-send-email-nbd@openwrt.org>
	<87si6h1o4q.fsf@kamboji.qca.qualcomm.com>
	<55F6733B.9030106@openwrt.org>
Date: Mon, 14 Sep 2015 10:46:59 +0300
In-Reply-To: <55F6733B.9030106@openwrt.org> (Felix Fietkau's message of "Mon,
	14 Sep 2015 09:11:55 +0200")
Message-ID: <87k2rt1lzg.fsf@kamboji.qca.qualcomm.com> (sfid-20150914_094722_228325_7954DF04)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> On 2015-09-14 09:00, Kalle Valo wrote:
>> Felix Fietkau <nbd@openwrt.org> writes:
>> 
>>> Some platforms really don't like DMA bursts of 256 bytes, and this
>>> causes the firmware to crash when sending beacons.
>>> Also, changing this based on the firmware version does not seem to make
>>> much sense, so use 128 bytes for all versions.
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> 
>> Nice, good catch! Just to make sure, this fixes the issues some people
>> have reported that 10.1 firmware works but 10.2 firmware crashes when
>> starting beaconing?
>
> Yes. I was able to reproduce that issue myself on a Gateworks Laguna
> device, which is among the affected devices reported in that email
> thread. This patch fixes it for me.

Awesome. Can you please resend this and CC ath10k@lists.infradead.org
(as well as linux-wireless) so that I get this to the correct patchwork
project? I'll then send it forward to 4.3.

-- 
Kalle Valo
