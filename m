Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F023EEE4993
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Aug 2023 14:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbjHWOK3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Aug 2023 10:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjHWOK2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2023 10:10:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC0BE4E;
        Wed, 23 Aug 2023 07:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6AA662C3E;
        Wed, 23 Aug 2023 14:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BB0C433C7;
        Wed, 23 Aug 2023 14:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692799825;
        bh=sCSCkACIIV+5luaFZRZzJOEAJRlXKDz6di/DkVOvsDU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=bPCDcJO6KihhyBinYi6f0UoQfwXYri0SBVixnNwkc9rxJgZVHrkMGDtrwJmoxmUyN
         q5ZEL1clv1pkXQZLGbtHiKm2skb8Kxk8fOiYvsU8EIq6Nd6n0pZ9C4rpp1b98KxQEY
         lXFJVgwzBN6i6SFOXiz2Tu/PGfmHk+qQyxGOJ+qNwIIl8dZiEHljqaoaH0+bVLy2vO
         aMiTeurk6Rc8BzvYg31HoSZf1daVVA8nQARg8M3COngdMc8R7GgwRivo0YE/e29Uex
         ItA7M0Ab2DFbZr3+SD8q9PUrQg2jSR3GQgEwRw4uI5XWex40NMrfDzkZzBNPuBNmK4
         NNVOXwVpJPJjw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next 1/2] wifi: ath11k: fix Wvoid-pointer-to-enum-cast
 warning
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230810091224.70088-1-krzysztof.kozlowski@linaro.org>
References: <20230810091224.70088-1-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        Andi Shyti <andi.shyti@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169279982245.1241462.6353860159222182552.kvalo@kernel.org>
Date:   Wed, 23 Aug 2023 14:10:23 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> 'hw_rev' is an enum, thus cast of pointer on 64-bit compile test with W=1
> causes:
> 
>   h11k/ahb.c:1124:11: error: cast to smaller integer type 'enum ath11k_hw_rev' from 'const void *' [-Werror,-Wvoid-pointer-to-enum-cast]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

2 patches applied to ath-next branch of ath.git, thanks.

6763ef191d67 wifi: ath11k: fix Wvoid-pointer-to-enum-cast warning
de43b07db2a1 wifi: ath10k: fix Wvoid-pointer-to-enum-cast warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230810091224.70088-1-krzysztof.kozlowski@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

