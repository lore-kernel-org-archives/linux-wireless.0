Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:34762 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbbINHMg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 03:12:36 -0400
Subject: Re: [PATCH 4.3] ath10k: fix DMA related firmware crashes on multiple
 devices
To: Kalle Valo <kvalo@qca.qualcomm.com>
References: <1442176540-34973-1-git-send-email-nbd@openwrt.org>
 <87si6h1o4q.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <55F6733B.9030106@openwrt.org> (sfid-20150914_091240_640711_0617254A)
Date: Mon, 14 Sep 2015 09:11:55 +0200
MIME-Version: 1.0
In-Reply-To: <87si6h1o4q.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-09-14 09:00, Kalle Valo wrote:
> Felix Fietkau <nbd@openwrt.org> writes:
> 
>> Some platforms really don't like DMA bursts of 256 bytes, and this
>> causes the firmware to crash when sending beacons.
>> Also, changing this based on the firmware version does not seem to make
>> much sense, so use 128 bytes for all versions.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> Nice, good catch! Just to make sure, this fixes the issues some people
> have reported that 10.1 firmware works but 10.2 firmware crashes when
> starting beaconing?
Yes. I was able to reproduce that issue myself on a Gateworks Laguna
device, which is among the affected devices reported in that email
thread. This patch fixes it for me.

- Felix
