Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64274 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbbK3K3o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 05:29:44 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/2] ath10k: do not use coherent memory for allocated device memory chunks
References: <1448284729-98078-1-git-send-email-nbd@openwrt.org>
Date: Mon, 30 Nov 2015 12:29:31 +0200
In-Reply-To: <1448284729-98078-1-git-send-email-nbd@openwrt.org> (Felix
	Fietkau's message of "Mon, 23 Nov 2015 14:18:48 +0100")
Message-ID: <87wpszkcfo.fsf@kamboji.qca.qualcomm.com> (sfid-20151130_112947_608854_68EA328B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> Coherent memory is more expensive to allocate (and constrained on some
> architectures where it has to be pre-allocated). It is also completely
> unnecessary, since the host has no reason to even access these allocated
> memory spaces
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

I see a new compiler warning:

drivers/net/wireless/ath/ath10k/wmi.c: In function
'ath10k_wmi_event_service_ready_work':
drivers/net/wireless/ath/ath10k/wmi.c:4347:30: warning: 'pool_size' may
be used uninitialized in this function [-Wuninitialized]
drivers/net/wireless/ath/ath10k/wmi.c:4319:6: note: 'pool_size' was
declared here

Seems to be false and maybe because my gcc is pretty old:

gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3

But anyway it would be nice if this can be avoided.

-- 
Kalle Valo
