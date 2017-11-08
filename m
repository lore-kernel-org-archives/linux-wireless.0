Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44652 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752475AbdKHMsR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 07:48:17 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [08/11] rtlwifi: rtl_pci: Refactor TX/RX flow
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171101152926.24971-9-Larry.Finger@lwfinger.net>
References: <20171101152926.24971-9-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Steven Ting <steventing@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>, Shaofu <shaofu@realtek.com>
Message-Id: <20171108124816.E07E6607B5@smtp.codeaurora.org> (sfid-20171108_134824_665484_9550FC44)
Date: Wed,  8 Nov 2017 12:48:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Steven Ting <steventing@realtek.com>
> 
> After this refactoring, the variables wp and rp in TX ring can only be
> updated in OP_TX and TX_OK respectively without protection. The other
> changes are listed below:
> 
> 1. remove avl_desc from TX ring, because it can be calculated by wp and rp.
>    Moreover, we update this variable in op_tx (thread context) and TX_OK
>    (BH context) without protection.
> 2. extend calc_fifo_space(rp, wp) to calc_fifo_space(rp, wp, size), and fix
>    the caller's parameter 'size'.
> 3. Get RX remaining counter only if it count down to zero.
> 4. remove available_desc check from Tx ISR
> 
> Signed-off-by: Steven Ting <steventing@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>

Dropping the rest of the series based on my comments.

4 patches set to Changes Requested.

10036501 [08/11] rtlwifi: rtl_pci: Refactor TX/RX flow
10036503 [09/11] rtlwifi: rtl_pci: 8822BE puts broadcast and multicast packet to HIQ
10036507 [10/11] rtlwifi: Add beacon check mechanism to check if AP settings changed.
10036505 [11/11] rtlwifi: rtl_pci: Fix the bug when inactiveps is enabled.

-- 
https://patchwork.kernel.org/patch/10036501/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
