Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54720 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755024AbeDPNQx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 09:16:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Enable hw checksum for wcn3990
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1522993544-15279-1-git-send-email-pillair@codeaurora.org>
References: <1522993544-15279-1-git-send-email-pillair@codeaurora.org>
To: Rakesh Pillai <pillair@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Message-Id: <20180416131653.0FECE60F6E@smtp.codeaurora.org> (sfid-20180416_151715_415424_6920F1AE)
Date: Mon, 16 Apr 2018 13:16:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rakesh Pillai <pillair@codeaurora.org> wrote:

> By default ath10k driver enables the support for HW_CHECKSUM
> (NETIF_F_HW_CSUM). Since the TCP/UDP checksum calculation is not enabled
> in the wcn3990 firmware the checksum is incorrect in the TCP/UDP packets
> and all patckets are dropped. But due note that wcn3990 support in
> ath10k is still incomplete so this isn't a critical fix (yet).
> 
> Enable hw checksum calculations in wcn3990 hardware by
> setting the proper flags in msdu descriptor tso flags.
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Introduces a new sparse warning:

potku:~/ath10k/src/ath$ ath10k-check 
drivers/net/wireless/ath/ath10k/htt_tx.c:1480:47: warning: invalid assignment: |=
drivers/net/wireless/ath/ath10k/htt_tx.c:1480:47:    left side has type restricted __le32
drivers/net/wireless/ath/ath10k/htt_tx.c:1480:47:    right side has type unsigned long

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10325669/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
