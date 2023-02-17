Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B706C6379F
	for <linux-wireless@archiver.kernel.org>; Fri, 17 Feb 2023 16:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjBQQDX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 17 Feb 2023 11:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjBQQDW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Feb 2023 11:03:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FF568E63;
        Fri, 17 Feb 2023 08:03:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4264B82C67;
        Fri, 17 Feb 2023 16:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45186C433D2;
        Fri, 17 Feb 2023 16:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676649799;
        bh=jkYdXv0RiqZgiDWJCQObRR3MuczBHGwqkjy/uWfvppo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=N6KM6tGwoo+qXc8idIRcbxWQj8301Yu73tWcr7ipaUTLvZmHevx++nNgYz0ARnTTX
         BhxHKME8MEiUDptj+aUq+oKTThfaaRms8jfhhS39pPCbN6BJ7ECcTPw0vcpKpJ7qXq
         IgUxoBDr5N7mx7Hx4I0P0HWrMWxWu+C0Hxy6YBwf0+M6fX1rF+dc+VSNq+oOji9VtJ
         von5IftF3nJVnrco2UuABvDHtM3MYBEH8AnSb9pdwOwTm0WKeXOVZU6DJmDgcs9VNY
         H2LNNr6N9mqdmp0I+qpdpBt+8gxUdjSppQ+XxPeSAMF1MmaH1zxJ3vVZC3jg9jIUTz
         /K9JTvDCMFDkg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath6kl: minor fix for allocation size
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230117110414.GC12547@altlinux.org>
References: <20230117110414.GC12547@altlinux.org>
To:     "Alexey V. Vissarionov" <gremlin@altlinux.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Raja Mani <rmani@qca.qualcomm.com>,
        Suraj Sumangala <surajs@qca.qualcomm.com>,
        Vivek Natarajan <nataraja@qca.qualcomm.com>,
        Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, lvc-project@linuxtesting.org,
        "Alexey V. Vissarionov" <gremlin@altlinux.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167664979327.8263.11509817973827702787.kvalo@kernel.org>
Date:   Fri, 17 Feb 2023 16:03:16 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Alexey V. Vissarionov" <gremlin@altlinux.org> wrote:

> Although the "param" pointer occupies more or equal space compared
> to "*param", the allocation size should use the size of variable
> itself.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: bdcd81707973cf8a ("Add ath6kl cleaned up driver")
> Signed-off-by: Alexey V. Vissarionov <gremlin@altlinux.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

778f83f889e7 wifi: ath6kl: minor fix for allocation size

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230117110414.GC12547@altlinux.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

