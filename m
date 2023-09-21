Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B9BE7D0AA
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Sep 2023 20:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbjIUU56 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbjIUU5g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2023 16:57:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4176C83F6A
        for <linux-wireless@vger.kernel.org>; Thu, 21 Sep 2023 10:37:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF60C116B7;
        Thu, 21 Sep 2023 08:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695284101;
        bh=AHBLwwOIwVWEmEP99U0FHUEQNUBcOntQwAP8JLk0Nrw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=oZQtzsaJoI5FcqsIFrLXfTKb3OPPmMerddAnyEue6eMDGmf74sMvx+jD/mt7bVlV8
         lvWElRz1BmVrCaU4Cr1Nk5/4MI5rQDgZTKvgYEKQyEwr4wTqlFx+n6+/DaLXJjnRZH
         qvn0lBrmP/ZbfuoUlSCS8/oW3Ow7gIAxJy9/dL0/H+XdY1BINd+R5qe3+dfuPPHRgx
         PMVHXKD2NbpkoaVYlr7Yci5jZZU4Xvv/rnPBdVXISV/MdNw9pog6vOIJIC0bEXFt2D
         lELB5upUDb7e61eERDi67C3qs1NAvDZ66Z9wx6cDaICSs83rms7jqh2J3MqAXX4F7z
         L/buhWfrVQjqA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/5] wifi: ath11k: drop redundant check in
 ath11k_dp_rx_mon_dest_process()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230824075121.121144-1-dmantipov@yandex.ru>
References: <20230824075121.121144-1-dmantipov@yandex.ru>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        Tom Rix <trix@redhat.com>, linux-wireless@vger.kernel.org,
        lvc-project@linuxtesting.org, ath11k@lists.infradead.org,
        Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169528409870.1539628.16918837777689234702.kvalo@kernel.org>
Date:   Thu, 21 Sep 2023 08:15:00 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> wrote:

> In 'ath11k_dp_rx_mon_dest_process()', 'mon_dst_srng' points to
> a member of 'srng_list', which is a fixed-size array inside
> 'struct ath11k_hal'. This way, if 'ring_id' is valid (i. e.
> between 0 and HAL_SRNG_RING_ID_MAX - 1 inclusive), 'mon_dst_srng'
> can't be NULL and so relevant check may be dropped.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

2 patches applied to ath-next branch of ath.git, thanks.

82ae3f463538 wifi: ath11k: drop redundant check in ath11k_dp_rx_mon_dest_process()
9066794113c4 wifi: ath11k: remove unused members of 'struct ath11k_base'

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230824075121.121144-1-dmantipov@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

