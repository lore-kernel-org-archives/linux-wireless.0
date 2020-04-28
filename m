Return-Path: <SRS0=qsgd=6M=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA2AC83000
	for <linux-wireless@archiver.kernel.org>; Tue, 28 Apr 2020 19:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5A79208FE
	for <linux-wireless@archiver.kernel.org>; Tue, 28 Apr 2020 19:44:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="WTQDD3pT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgD1ToP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 28 Apr 2020 15:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728944AbgD1ToP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Apr 2020 15:44:15 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66F9C03C1AB
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2020 12:44:14 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1588102660; bh=bO+E46na0DxONeKZaofpgSO9a9Fvo1tqjPNZ9wwni9g=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=WTQDD3pTDy1GB2QsKbkxbwQKMf1SGcvXQdZQ84xorW8V3bBpUjAZCGVn+3A7Ps8u2
         nuPrsH7B4YOAA7ENz8kDm9QXZbDFP4Y64CgqVBr63fhlb6uIsRDFKFLCJDvD5i2Iz5
         EvvFBcxRnQNyxFbBiNM13AUa4fIoAuEnXi/xrIZ3DWXJ0AnVYytmyCfff4qt3eQLaD
         s1V7HlBIfWMVCV2QRMAczZKB7KWmZPOOx8NjKP+hvnyh+WdOX0oxhoW48CrjPSHZno
         EUSx++AyA1zPhjcKdKB08AKJvLfRpj5yIpEPylv0HM5f8H+igVk9NkuMmxh1HJb2QP
         KU9V6p5xoYBbQ==
To:     greearb@candelatech.com, linux-wireless@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH] ath10k:  Restart xmit queues below low-water mark.
In-Reply-To: <20200427145435.13151-1-greearb@candelatech.com>
References: <20200427145435.13151-1-greearb@candelatech.com>
Date:   Tue, 28 Apr 2020 21:37:40 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87h7x3v1tn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> While running tcp upload + download tests with ~200
> concurrent TCP streams, 1-2 processes, and 30 station
> vdevs, I noticed that the __ieee80211_stop_queue was taking
> around 20% of the CPU according to perf-top, which other locking
> taking an additional ~15%.
>
> I believe the issue is that the ath10k driver would unlock the
> txqueue when a single frame could be transmitted, instead of
> waiting for a low water mark.
>
> So, this patch adds a low-water mark that is 1/4 of the total
> tx buffers allowed.
>
> This appears to resolve the performance problem that I saw.
>
> Tested with recent wave-1 ath10k-ct firmware.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/htt.h    | 1 +
>  drivers/net/wireless/ath/ath10k/htt_tx.c | 8 ++++++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
> index 31c4ddbf45cb..b5634781c0dc 100644
> --- a/drivers/net/wireless/ath/ath10k/htt.h
> +++ b/drivers/net/wireless/ath/ath10k/htt.h
> @@ -1941,6 +1941,7 @@ struct ath10k_htt {
>  
>  	u8 target_version_major;
>  	u8 target_version_minor;
> +	bool needs_unlock;
>  	struct completion target_version_received;
>  	u8 max_num_amsdu;
>  	u8 max_num_ampdu;
> diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
> index 9b3c3b080e92..44795d9a7c0c 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
> @@ -145,8 +145,10 @@ void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
>  	lockdep_assert_held(&htt->tx_lock);
>  
>  	htt->num_pending_tx--;
> -	if (htt->num_pending_tx == htt->max_num_pending_tx - 1)
> +	if ((htt->num_pending_tx <= (htt->max_num_pending_tx / 4)) && htt->needs_unlock) {

Why /4? Seems a bit arbitrary?

What's a typical value of max_num_pending_tx?

-Toke
