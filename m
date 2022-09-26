Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A68C32771
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Sep 2022 09:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbiIZJrH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Sep 2022 05:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbiIZJqc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2022 05:46:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC4155A3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2022 02:45:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 335B7B80780
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2022 09:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27397C433C1;
        Mon, 26 Sep 2022 09:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664185248;
        bh=KZExA4qLutmcXLykvMCHov9T9r+TzGGb9WvyV10CAX0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=omilYMEgoE9VFMrzNoPz/7jyv0RzCth5hvOXT9uDsdTbX6L1RXYsjVdsrf+OLARB3
         XCwP1Hfg2SHobK0w+QJzeUSF35HLrTxpng8DJT9CmuZzmP0HU46Jir/+DpC8sjHPeE
         PXnWvcGizqLlLLK60jo2qPgCaDRiSs21QcrR8lS597To+IZsMvqff7p8nmolYp6HnJ
         dYyEVZhHXIssVx8E2A+G2xiBz5sV9tDWeZQL9oO7HXQYQ3OJnLTXKfRc85AYzK/bn9
         CFLW6+89RFVbr7HidsRselHKmeDSpZq4qtzUeLR1bya8uP5cU3ytUmE5RpVAtqFX19
         mKvrfX9ZHulbA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath11k: Remove redundant ath11k_mac_drain_tx
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220919020259.1746-1-quic_bqiang@quicinc.com>
References: <20220919020259.1746-1-quic_bqiang@quicinc.com>
To:     Baochen Qiang <quic_bqiang@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166418524644.13691.9971262730096379862.kvalo@kernel.org>
Date:   Mon, 26 Sep 2022 09:40:47 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Baochen Qiang <quic_bqiang@quicinc.com> wrote:

> ath11k_mac_drain_tx is already called in ath11k_mac_wait_tx_complete, no need to call it again. So remove it.
> 
> This is found in code review.
> 
> Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3
> 
> Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

d50ebec14535 wifi: ath11k: Remove redundant ath11k_mac_drain_tx

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220919020259.1746-1-quic_bqiang@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

