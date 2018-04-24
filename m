Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38088 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756120AbeDXFzY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 01:55:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: Convert wow pattern from 802.3 to 802.11
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1523507057-20650-1-git-send-email-wgong@codeaurora.org>
References: <1523507057-20650-1-git-send-email-wgong@codeaurora.org>
To: Wen Gong <wgong@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180424055523.CA21D6090E@smtp.codeaurora.org> (sfid-20180424_075543_414669_16CF21F2)
Date: Tue, 24 Apr 2018 05:55:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wen Gong <wgong@codeaurora.org> wrote:

> When trying to set wow wakeup patterns it fails with this command:
> 
> iw phyxx wowlan enable patterns offset xx+ IP address xx.xx.xx.xx
> 
> The reason is that the wow pattern from upper layer is in 802.3 format
> for this case, it need to convert it to 802.11 format. The input
> offset parameter is used for 802.3, but the actual offset firmware
> need depends on rx_decap_mode, so that it needs to be recalculated.
> Pattern of 802.3 packet is not same with 802.11 packet. If the
> rx_decap_mode is ATH10K_HW_TXRX_NATIVE_WIFI, then firmware will
> receive data packet with 802.11 format from hardware.
> 
> Tested with QCA6174 hw3.0 with firmware
> WLAN.RM.4.4.1-00099-QCARMSWPZ-1, but this will also affect QCA9377.
> This has always failed, so it's not a regression with new firmware
> releases.
> 
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

fa3440fa2fa1 ath10k: convert wow pattern from 802.3 to 802.11

-- 
https://patchwork.kernel.org/patch/10337877/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
