Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A82C282D7
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 09:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 034DC2146F
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 09:24:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="D5egk4/L";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hVvTnfXa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfBKJYx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 04:24:53 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33106 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfBKJYx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 04:24:53 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B581C60E74; Mon, 11 Feb 2019 09:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549877092;
        bh=BL5oGR8D0K+EvnZkNQdbxQFOEqEFrLSQmK/j5HkHtQc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=D5egk4/LTxgHEPHt03wV6izxYaaaLwpPJpR4YtBAtpGtg+E1AjgPvzHIHko/RkM8E
         4g2xFgsU/+edTCS2kCybcttR/4zce/pR7m00t1N0j9FXoTFg2RGZqOnV0oqyRbV/Xv
         slJR8D3CnF/61cVQScPGt8+c+5btXpL65khJ8iGg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9743A60E74;
        Mon, 11 Feb 2019 09:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549877089;
        bh=BL5oGR8D0K+EvnZkNQdbxQFOEqEFrLSQmK/j5HkHtQc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=hVvTnfXat69ziQDiiNd7TeTiWalZ/J+GPSgouQfERx+1tMlRe9pspiKeOTSvYAitD
         986C5ulSuF682Ah4hhd9kXxdLfK9V01C9+9ijMyrq/hop76opCwoWV0E/U8lU17x4w
         oovADa0aGWOYyvqlhhu26P8JN+ux9tosLyBiQj+I=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9743A60E74
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 4/4] ath10k: reporting estimated tx airtime for fairness
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190122142019.21417-5-toke@redhat.com>
References: <20190122142019.21417-5-toke@redhat.com>
To:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Kan Yan <kyan@google.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        ath10k@lists.infradead.org, make-wifi-fast@lists.bufferbloat.net,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190211092452.B581C60E74@smtp.codeaurora.org>
Date:   Mon, 11 Feb 2019 09:24:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Toke Høiland-Jørgensen wrote:

> The airtime of a transmitted frame will be estimated from last used tx rate
> which the firmware reports with the peer stats feature
> (WMI_SERVICE_PEER_STATS). The airtime is computed on the tx path and it
> will be reported to mac80211 upon tx completion.
> 
> This change is based on Kan's orginal commit in Chromium tree
> ("CHROMIUM: ath10k: Implementing airtime fairness based TX scheduler")
> ref: https://chromium-review.googlesource.com/588190
> 
> Tested on QCA4019 with firmware version 10.4-3.2.1.1-00015
> Tested on QCA9984 with firmware version 10.4-3.9.0.1-00005
> 
> Signed-off-by: Kan Yan <kyan@google.com>
> [rmanohar@codeaurora.org: ported only the airtime computation]
> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
> [toke@redhat.com: Rebase to mac80211-next, add test note]
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

There was a trivial conflict, please check my resolution in the pending branch.
I also reworded the commit log a bit.

$ git am -s --reject 10775551.mbox
Applying: ath10k: reporting estimated tx airtime for fairness
Checking patch drivers/net/wireless/ath/ath10k/core.h...
Checking patch drivers/net/wireless/ath/ath10k/htt_rx.c...
Hunk #1 succeeded at 3080 (offset 2 lines).
Checking patch drivers/net/wireless/ath/ath10k/mac.c...
Hunk #1 succeeded at 3566 (offset 22 lines).
Hunk #2 succeeded at 3583 (offset 22 lines).
Hunk #3 succeeded at 3971 (offset 22 lines).
Hunk #4 succeeded at 4029 (offset 22 lines).
Hunk #5 succeeded at 4047 (offset 22 lines).
Hunk #6 succeeded at 4315 (offset 22 lines).
Hunk #7 succeeded at 8671 (offset 20 lines).
Checking patch drivers/net/wireless/ath/ath10k/txrx.c...
error: while searching for:
                wake_up(&htt->empty_tx_wq);
        spin_unlock_bh(&htt->tx_lock);

        if (ar->dev_type != ATH10K_DEV_TYPE_HL)
                dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);


error: patch failed: drivers/net/wireless/ath/ath10k/txrx.c:95
Applied patch drivers/net/wireless/ath/ath10k/core.h cleanly.
Applied patch drivers/net/wireless/ath/ath10k/htt_rx.c cleanly.
Applied patch drivers/net/wireless/ath/ath10k/mac.c cleanly.
Applying patch drivers/net/wireless/ath/ath10k/txrx.c with 1 reject...
Rejected hunk #1.
Patch failed at 0001 ath10k: reporting estimated tx airtime for fairness

-- 
https://patchwork.kernel.org/patch/10775551/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

