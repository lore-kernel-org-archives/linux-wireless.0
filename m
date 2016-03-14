Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39573 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933400AbcCNGTE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2016 02:19:04 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, netdev@vger.kernel.org,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>
Subject: Re: [PATCH] b43: Fix memory leaks in b43_bus_dev_ssb_init and b43_bus_dev_bcma_init
References: <1457716477-6287-1-git-send-email-sudipm.mukherjee@gmail.com>
Date: Mon, 14 Mar 2016 08:18:58 +0200
In-Reply-To: <1457716477-6287-1-git-send-email-sudipm.mukherjee@gmail.com>
	(Sudip Mukherjee's message of "Fri, 11 Mar 2016 22:44:37 +0530")
Message-ID: <87a8m1mvjh.fsf@kamboji.qca.qualcomm.com> (sfid-20160314_071922_219315_3222ED72)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:

> From: Jia-Ju Bai <baijiaju1990@163.com>
>
> The memory allocated by kzalloc in b43_bus_dev_ssb_init and
> b43_bus_dev_bcma_init is not freed.
> This patch fixes the bug by adding kfree in b43_ssb_remove,
> b43_bcma_remove and error handling code of b43_bcma_probe.
>
> Thanks Michael for his suggestion.
>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
> Acked-by: Michael Büsch <m@bues.ch>
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

If no objections I'm planning to queue this to 4.6-rc2.

-- 
Kalle Valo
