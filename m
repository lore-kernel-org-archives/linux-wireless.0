Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60163C433EF
	for <linux-wireless@archiver.kernel.org>; Fri,  6 May 2022 06:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389398AbiEFGYU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 May 2022 02:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389437AbiEFGYG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 May 2022 02:24:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E6E6279
        for <linux-wireless@vger.kernel.org>; Thu,  5 May 2022 23:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3076761F09
        for <linux-wireless@vger.kernel.org>; Fri,  6 May 2022 06:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE50C385AA;
        Fri,  6 May 2022 06:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651818022;
        bh=Uo/zEk3pxx6gI0ehxLl3UD9/wiP9AHOMLUlfmqW0YUQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ipNyiIPzL8czMQVRZh/d0bU4+tf8sQmHQ1kD1Cnef1pl5b68MRp8Z3watliOY1hgw
         gd5755Ls6wMkCFNGizHb54k/jW7dAk7zIjBJ+jKnfWSP7EuEXD1X/Bx92lDlmSvVN+
         UsHIWyqCuXLxkidC9Gtwe9y3XfBOI4P4IPk5ySBWLJkCfyJc56/oY3PJNA4qPwICUp
         sBYoAsYK1b9S4kPPFa+URc2sqhejWI/iGitVYKWN94Du3MTUCLsOtKrd5O3dW5XqMa
         281jcSA2rBBPsvZdfSibzcj/c9sS/eXXG//cLLr4/Ht/nWntPbgYUt50efdFzxs8VZ
         5IJTGbxfRO1kw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4] ath11k: Fix RX de-fragmentation issue on WCN6750
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220504083900.31513-1-quic_mpubbise@quicinc.com>
References: <20220504083900.31513-1-quic_mpubbise@quicinc.com>
To:     Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165181801572.13324.15375234945964628644.kvalo@kernel.org>
Date:   Fri,  6 May 2022 06:20:21 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Manikanta Pubbisetty <quic_mpubbise@quicinc.com> wrote:

> The offset of REO register where the RX fragment destination ring
> is configured is different in WCN6750 as compared to WCN6855.
> Due to this differnce in offsets, on WCN6750, fragment destination
> ring will be configured incorrectly, leading to RX fragments not
> getting delivered to the driver. Fix this by defining HW specific
> offsets for the REO MISC CTL register.
> 
> Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-00887-QCAMSLSWPLZ-1
> Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1
> Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.0.1-01100-QCAHKSWPL_SILICONZ-1
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-00192-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

22cc687326e0 ath11k: Fix RX de-fragmentation issue on WCN6750

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220504083900.31513-1-quic_mpubbise@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

