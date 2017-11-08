Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59398 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbdKHMZd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 07:25:33 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Steven Ting <steventing@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>, Shaofu <shaofu@realtek.com>
Subject: Re: [PATCH 08/11] rtlwifi: rtl_pci: Refactor TX/RX flow
References: <20171101152926.24971-1-Larry.Finger@lwfinger.net>
        <20171101152926.24971-9-Larry.Finger@lwfinger.net>
Date: Wed, 08 Nov 2017 14:25:28 +0200
In-Reply-To: <20171101152926.24971-9-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Wed, 1 Nov 2017 10:29:23 -0500")
Message-ID: <87mv3xot3b.fsf@purkki.adurom.net> (sfid-20171108_132536_925067_E19BEB8C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Steven Ting <steventing@realtek.com>
>
> After this refactoring, the variables wp and rp in TX ring can only be
> updated in OP_TX and TX_OK respectively without protection.

Why? Try to always answer that, that's the most important part of the
commit log. Are you fixing a bug (if yes, describe it briefly), is this
just code cleanup or what's your motivation to change the code?

> The other changes are listed below:
>
> 1. remove avl_desc from TX ring, because it can be calculated by wp and rp.
>    Moreover, we update this variable in op_tx (thread context) and TX_OK
>    (BH context) without protection.
> 2. extend calc_fifo_space(rp, wp) to calc_fifo_space(rp, wp, size), and fix
>    the caller's parameter 'size'.
> 3. Get RX remaining counter only if it count down to zero.
> 4. remove available_desc check from Tx ISR

One logical change per patch, please. One good rule of thumb is that if
you have to list the changes made in patch you need to split the patch.

-- 
Kalle Valo
