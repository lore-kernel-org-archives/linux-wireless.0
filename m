Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE775C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96AC921720
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:09:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QRk6yy9E";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZacbNWYC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387651AbeLTRJL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 12:09:11 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38896 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731798AbeLTRJL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 12:09:11 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9095060595; Thu, 20 Dec 2018 17:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325750;
        bh=fKmtIl0SYpNDNOD5LQ4xf3uPVBJkP8NyB8Del5VJ/ck=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=QRk6yy9Ed4iK7eZ8EHQ6V1b3yVh7Rnny3xgFKxdGNmSVGFM4+XTVuHCcCNJE79hpe
         cWob6pAuOuvmFo3W1L6RT+1hX8kCkGb/eH+XWWyB2bcOGMNaYethyi6RYqcTPELbSV
         5qkZN1dtMzTsepUtR7zh9l/6JHkkSfY/DEoU30sc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2500A60595;
        Thu, 20 Dec 2018 17:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325750;
        bh=fKmtIl0SYpNDNOD5LQ4xf3uPVBJkP8NyB8Del5VJ/ck=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ZacbNWYCtJmBwWosVwWUHM8jxYAyMXZZGLacAIOOBYA884dP11+SF8TQmT9+v0xi2
         +5Fnsm7VvV5jb4H0T+GSf68sjtrSrE9mFANphYbi3CE6p4YSvHxXvkFf3Y00wKaIm5
         W+tjUW/tIuMwI8Aw3RhsbyY6+QLYCd6fXwzcxnj8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2500A60595
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v1 1/2] ath10k: fix peer stats null pointer dereference
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1544497705-21593-1-git-send-email-zhichen@codeaurora.org>
References: <1544497705-21593-1-git-send-email-zhichen@codeaurora.org>
To:     zhichen@codeaurora.org
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Zhi Chen <zhichen@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220170910.9095060595@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 17:09:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

zhichen@codeaurora.org wrote:

> There was a race condition in SMP that an ath10k_peer was created but its
> member sta was null. Following are procedures of ath10k_peer creation and
> member sta access in peer statistics path.
> 
>     1. Peer creation:
>         ath10k_peer_create()
>             =>ath10k_wmi_peer_create()
>                 =>ath10k_wait_for_peer_created()
>                 ...
> 
>         # another kernel path, RX from firmware
>         ath10k_htt_t2h_msg_handler()
>         =>ath10k_peer_map_event()
>                 =>wake_up()
>                 # ar->peer_map[id] = peer //add peer to map
> 
>         #wake up original path from waiting
>                 ...
>                 # peer->sta = sta //sta assignment
> 
>     2.  RX path of statistics
>         ath10k_htt_t2h_msg_handler()
>             =>ath10k_update_per_peer_tx_stats()
>                 =>ath10k_htt_fetch_peer_stats()
>                 # peer->sta //sta accessing
> 
> Any access of peer->sta after peer was added to peer_map but before sta was
> assigned could cause a null pointer issue. And because these two steps are
> asynchronous, no proper lock can protect them. So both peer and sta need to
> be checked before access.
> 
> Tested: QCA9984 with firmware ver 10.4-3.9.0.1-00005
> Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

2d3b55853b12 ath10k: fix peer stats null pointer dereference
386f97e3b201 ath10k: fix tx_stats memory leak

-- 
https://patchwork.kernel.org/patch/10722983/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

