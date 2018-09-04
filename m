Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55336 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbeIDJao (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 05:30:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] ath10k: Enable pktlog for WCN3990 target
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180828043642.14890-3-govinds@codeaurora.org>
References: <20180828043642.14890-3-govinds@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Message-Id: <20180904050720.8DDA3606AC@smtp.codeaurora.org> (sfid-20180904_070725_049472_B6C635F8)
Date: Tue,  4 Sep 2018 05:07:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> wrote:

> WCN3990 target uses separate htc service for pktlog.
> Add pktlog service request and support for pktlog
> rx path handling.
> 
> Testing:
>     Tested on WCN3990 and QCA6174 HW.
>     Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1,
>                WLAN.RM.4.4.1-00109-QCARMSWPZ-1
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

This introduced a new sparse warning:

drivers/net/wireless/ath/ath10k/htc.c:875:6: warning: symbol 'ath10k_htc_pktlog_svc_supported' was not declared. Should it be static?

I fixed this in the pending branch.

-- 
https://patchwork.kernel.org/patch/10577869/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
