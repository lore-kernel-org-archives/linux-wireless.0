Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53890 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932080AbeB1NHO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 08:07:14 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: pillair@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: dma unmap mgmt tx buffer if wmi cmd send fails
References: <1518169330-4934-1-git-send-email-pillair@codeaurora.org>
Date: Wed, 28 Feb 2018 15:07:09 +0200
In-Reply-To: <1518169330-4934-1-git-send-email-pillair@codeaurora.org>
        (pillair@codeaurora.org's message of "Fri, 9 Feb 2018 15:12:10 +0530")
Message-ID: <87bmg9s1oi.fsf@kamboji.qca.qualcomm.com> (sfid-20180228_140720_319017_854921DA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pillair@codeaurora.org writes:

> From: Rakesh Pillai <pillair@codeaurora.org>
>
> WCN3990 sends mgmt frames by reference via WMI.
> The host dma maps the mgmt frame and sends the physical
> address to the firmware in the wmi command. Since the
> dma mapping is done in the gen_mgmt_tx and if the wmi
> command send fails, the corresponding mgmt frame is
> not being dma unmapped.
>
> Fix the missing dma unmapping of mgmt tx frame when
> wmi command sending fails for mgmt tx by reference
> via WMI. The already exisiting mgmt tx using copy by
> value does not need such dma unmapping.
> Add a separate wmi-tlv op for mgmt tx via ref, which
> takes care of unmapping the dma address, in case of
> wmi command sending failure.
>
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>

ath10k-check found two warnings, I fixed those in pending branch:

drivers/net/wireless/ath/ath10k/wmi-ops.h:130: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/wmi-ops.h:380: Alignment should match open parenthesis

-- 
Kalle Valo
