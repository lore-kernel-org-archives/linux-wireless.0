Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46323 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbcGUOsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 10:48:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH] mwifiex: fix large amsdu packets causing firmware hang
References: <1469098824-8031-1-git-send-email-akarwar@marvell.com>
Date: Thu, 21 Jul 2016 17:48:38 +0300
In-Reply-To: <1469098824-8031-1-git-send-email-akarwar@marvell.com> (Amitkumar
	Karwar's message of "Thu, 21 Jul 2016 16:30:24 +0530")
Message-ID: <8737n39hdl.fsf@purkki.adurom.net> (sfid-20160721_164846_244270_0458B0D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> From: Cathy Luo <cluo@marvell.com>
>
> Sometimes host prepares and downloads a large amsdu packet to firmware
> which leads to a memory corruption in firmware.
> The reason is __dev_alloc_skb() may allocate larger buffer than required
> size. This patch solves the problem by checking "adapter->tx_buf_size"
> instead of relying on skb_tailroom().
>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Should this go to 4.8 as an important fix?

-- 
Kalle Valo
