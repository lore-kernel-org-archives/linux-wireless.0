Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41837 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbcA2JSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 04:18:47 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: fix power state out of sync problem
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1452606196-9582-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Shengzhen Li <szli@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160129091846.EE9AE6044B@smtp.codeaurora.org> (sfid-20160129_101853_311514_173D401A)
Date: Fri, 29 Jan 2016 09:18:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Shengzhen Li <szli@marvell.com>
> 
> It's been observed that driver's power state goes out
> of sync with firmware in some corner cases. When this
> happens, driver tries to download the data to firmware
> assuming it's awake which causes Tx data timeout.
> 
> Main thread will process interrupt as soon as interrupt
> handler fills 'int_status' variable.
> 
> This patch fixes the race issue by updating 'int_status'
> at the end of mwifiex_interrupt_status().
> 
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
