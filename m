Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52256 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbbINHAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 03:00:45 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 4.3] ath10k: fix DMA related firmware crashes on multiple devices
In-Reply-To: <1442176540-34973-1-git-send-email-nbd@openwrt.org> (Felix
	Fietkau's message of "Sun, 13 Sep 2015 22:35:40 +0200")
References: <1442176540-34973-1-git-send-email-nbd@openwrt.org>
Date: Mon, 14 Sep 2015 10:00:37 +0300
Message-ID: <87si6h1o4q.fsf@kamboji.qca.qualcomm.com> (sfid-20150914_090048_434309_F17DB57A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> Some platforms really don't like DMA bursts of 256 bytes, and this
> causes the firmware to crash when sending beacons.
> Also, changing this based on the firmware version does not seem to make
> much sense, so use 128 bytes for all versions.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Nice, good catch! Just to make sure, this fixes the issues some people
have reported that 10.1 firmware works but 10.2 firmware crashes when
starting beaconing?

-- 
Kalle Valo
