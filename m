Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39236 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbeCZPNq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 11:13:46 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: fix use-after-free in ath10k_wmi_cmd_send_nowait
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1520232242-24132-1-git-send-email-cjhuang@codeaurora.org>
References: <1520232242-24132-1-git-send-email-cjhuang@codeaurora.org>
To: Carl Huang <cjhuang@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180326151345.B70C660251@smtp.codeaurora.org> (sfid-20180326_171349_825972_BA3E6B7C)
Date: Mon, 26 Mar 2018 15:13:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Carl Huang <cjhuang@codeaurora.org> wrote:

> The skb may be freed in tx completion context before
> trace_ath10k_wmi_cmd is called. This can be easily captured when
> KASAN(Kernel Address Sanitizer) is enabled. The fix is to move
> trace_ath10k_wmi_cmd before the send operation. As the ret has no
> meaning in trace_ath10k_wmi_cmd then, so remove this parameter too.
> 
> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
> Tested-by: Brian Norris <briannorris@chromium.org>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

9ef0f58ed7b4 ath10k: fix use-after-free in ath10k_wmi_cmd_send_nowait

-- 
https://patchwork.kernel.org/patch/10258179/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
