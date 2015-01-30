Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:36240 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761482AbbA3KpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 05:45:03 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: yuweizheng@139.com
Cc: linux-kernel@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	linux@rempel-privat.de, netdev@vger.kernel.org,
	Yuwei Zheng <zhengyuwei@360.cn>
Subject: Re: [PATCH] Repair soft lockup with monitor mode of ath9k_htc card
References: <1422486872-16308-1-git-send-email-yuweizheng@139.com>
Date: Fri, 30 Jan 2015 12:44:52 +0200
In-Reply-To: <1422486872-16308-1-git-send-email-yuweizheng@139.com>
	(yuweizheng@139.com's message of "Thu, 29 Jan 2015 07:14:32 +0800")
Message-ID: <87d25wzgwr.fsf@kamboji.qca.qualcomm.com> (sfid-20150130_114543_690097_7B73F166)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

yuweizheng@139.com writes:

> From: Yuwei Zheng <yuweizheng@139.com>
>
> In the environment with heavy wifi traffic, set the ar9271 into
> monitor mode, will trigger a deadloop panic.
>  
> The ath9k_hif_usb_rx_cb function excute on  the interrupt context, and ath9k_rx_tasklet excute
> on the soft irq context. In other words, the ath9k_hif_usb_rx_cb have more chance to excute than
> ath9k_rx_tasklet.  So in the worst condition,  the rx.rxbuf receive list is always full,
> and the do {}while(true) loop will not be break. The kernel get a soft lockup panic. 

Word wrapping is too long and please prefix the title with "ath9k_htc: ".

-- 
Kalle Valo
