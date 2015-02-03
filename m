Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:57089 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964991AbbBCLwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 06:52:38 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: yuweizheng@139.com
Cc: linux-kernel@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	netdev@vger.kernel.org, Yuwei Zheng <zhengyuwei@360.cn>
Subject: Re: [PATCH] ath9k_htc: add adaptive usb flow control to repair soft lockup with monitor mode
References: <1422957585-19736-1-git-send-email-yuweizheng@139.com>
Date: Tue, 03 Feb 2015 13:52:29 +0200
In-Reply-To: <1422957585-19736-1-git-send-email-yuweizheng@139.com>
	(yuweizheng@139.com's message of "Tue, 3 Feb 2015 17:59:45 +0800")
Message-ID: <87fvanxldu.fsf@kamboji.qca.qualcomm.com> (sfid-20150203_125259_439563_9B175E0C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

yuweizheng@139.com writes:

> From: Yuwei Zheng <yuweizheng@139.com>
>
> In the environment with heavy wifi traffic, set the ar9271 into monitor mode, will
> trigger a deadloop panic.
>  
> The ath9k_hif_usb_rx_cb function excute on  the interrupt context, and ath9k_rx_tasklet excute
> on the soft irq context. In other words, the ath9k_hif_usb_rx_cb have more chance to excute than
> ath9k_rx_tasklet.  So in the worst condition,  the rx.rxbuf receive list is always full,
> and the do {}while(true) loop will not be break. The kernel get a soft lockup panic. 

The word wrapping is still wrong, please limit the width to 72 chars or
so. But no need to wrap log snippets, they can exceed the limit.

> Signed-off-by: Yuwei Zheng <zhengyuwei@360.cn>
> Signed-off-by: Yuwei Zheng <yuweizheng@139.com>

Why two of these? Please use just one Signed-off-by line. Unless these
are two different persons with the same name :)

-- 
Kalle Valo
