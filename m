Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40826 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbcGRTnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:43:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: fix PCIe legacy interrupt problem
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1468589825-9188-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160718194313.880B3602A9@smtp.codeaurora.org> (sfid-20160718_214319_434729_33488783)
Date: Mon, 18 Jul 2016 19:43:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> In corner case, we may end up processing same interrupt twice.
> We have a logic to read pending interrupts at the end of interrupt
> processing routine. It has a race with interrupts read in interrupt
> handler. This patch solves the problem by ORing the interrupt bitmap
> in this case.
> 
> The symptom for this bug is below messages in dmesg log.
> 
> [   11.522123] mwifiex_pcie 0000:01:00.0: CMD_RESP: invalid cmd resp
> [   11.680412] mwifiex_pcie 0000:01:00.0: There is no command but got cmdrsp
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=109681
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

514952889544 mwifiex: fix PCIe legacy interrupt problem
2fd40d2d349f mwifiex: update command response skb length correctly

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9232091/

