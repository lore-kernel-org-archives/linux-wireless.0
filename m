Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50092EB64DB
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Jun 2023 11:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344209AbjFOLnx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Jun 2023 07:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344356AbjFOLnF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2023 07:43:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE17F4498;
        Thu, 15 Jun 2023 04:40:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDE4560F23;
        Thu, 15 Jun 2023 11:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A87C433C8;
        Thu, 15 Jun 2023 11:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686829201;
        bh=pyu4I/v1KzEtwaZxUoDpwULyt62LfG5n4s4H0cxODJM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nVyTTd7eaPRxYVWwnRycGUJGtoHFyfeudPP4aaCamDKe4lN5E2jlGSK3TqsyznXv0
         XBKEaRlnyUaGxRVrnzDmkRpD0ASfx2O4LOjF98mme1aZn2MVKn/aRSU8dh47CZsS3D
         stoZPcuysRnjID8x6UY8OckRtfZoroZtcH0tD9iw3NSigfDN5aQItoGxJV8PNiwWVH
         ru2AJy55+XNfVEjXrINOMeY9hyznOMHvny4Hq+ulueJpRKfelcPUxAQ41VX440Qe0P
         xVZfG3qGwHaD0RFjhDo6OLyIbvwlW1MN4MxHi3KMz2vh2ajzLXH1kBKDW58UjPqdIO
         d+xD0NYqcr4qw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath11k: Add missing check for ioremap
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230608022858.27405-1-jiasheng@iscas.ac.cn>
References: <20230608022858.27405-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     akolli@codeaurora.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168682919799.30767.14368815744969338217.kvalo@kernel.org>
Date:   Thu, 15 Jun 2023 11:39:59 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jiasheng Jiang <jiasheng@iscas.ac.cn> wrote:

> Add check for ioremap() and return the error if it fails in order to
> guarantee the success of ioremap(), same as in
> ath11k_qmi_load_file_target_mem().
> 
> Fixes: 6ac04bdc5edb ("ath11k: Use reserved host DDR addresses from DT for PCI devices")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

16e0077e14a7 wifi: ath11k: Add missing check for ioremap

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230608022858.27405-1-jiasheng@iscas.ac.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

