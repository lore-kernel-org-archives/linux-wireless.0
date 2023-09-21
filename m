Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E731AE7D0AB
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Sep 2023 22:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbjIUWLh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbjIUWLN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2023 18:11:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E78883F64
        for <linux-wireless@vger.kernel.org>; Thu, 21 Sep 2023 10:37:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AB7C116B6;
        Thu, 21 Sep 2023 08:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695284006;
        bh=w9s/3KqBpjc+F0htGHCCTEf8hPrclIy6Ux/UJYVbORQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Ei62OwSI5BJtGMKOvLHwcgpMcK03iM0jFtMjxnhziKeQ6VyBRnnPr7mlFLqaa8aK4
         0rmGiTaP5je9/33SGtvX1mqGzCoASfdKaZ5VznUz+YAnXNB1LcRc0ePrVdsTilJYqk
         VYoTonLcgmMIIDbVtVN6XiUOjP489vTCNCK4SDrqm0enm4PgZT2acobznd6LnSVl2X
         SBouwkYil8zhOdewkLFtgTGXtxZmzcIbxFDMKJqdMSDDJQtILbnFIGTZcRmZNN8zDp
         AeYvgU2S7qX9ZI1Ledk+BNcDabxA4izd7LHgge275L9RHhSJkwv+Z7Lx6XzKHXn1WW
         4SyzIwcp2FCRg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath11k: drop NULL pointer check in
 ath11k_update_per_peer_tx_stats()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230906093704.14001-1-dmantipov@yandex.ru>
References: <20230906093704.14001-1-dmantipov@yandex.ru>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        linux-wireless@vger.kernel.org, lvc-project@linuxtesting.org,
        ath11k@lists.infradead.org, Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169528400337.1539628.7739014266024869825.kvalo@kernel.org>
Date:   Thu, 21 Sep 2023 08:13:25 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> wrote:

> Since 'user_stats' is a fixed-size array of 'struct htt_ppdu_user_stats'
> in 'struct htt_ppdu_stats', any of its member can't be NULL and so
> relevant check may be dropped.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

ac13a7842ab4 wifi: ath11k: drop NULL pointer check in ath11k_update_per_peer_tx_stats()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230906093704.14001-1-dmantipov@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

