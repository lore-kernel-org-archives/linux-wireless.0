Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21981C001DF
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Aug 2023 09:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbjHCJSW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Aug 2023 05:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbjHCJRo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2023 05:17:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C1CE70
        for <linux-wireless@vger.kernel.org>; Thu,  3 Aug 2023 02:17:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37C7661CF4
        for <linux-wireless@vger.kernel.org>; Thu,  3 Aug 2023 09:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5096C433C8;
        Thu,  3 Aug 2023 09:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691054261;
        bh=2+lL4NLB1Sr3ccJNK2IktqfCgSQkBVSJimEmE7yvsxA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LZfc3C3QNRppKBCWAneMKBTBauJVvzxT+Y6lZlIEJkxPJU/6FL3dMhO+UXXeb+Xhf
         NiHSGYq0ye+m0QVWg9yeaawu2UwZuBjE3w4VzI0honlMMI881vW0B+X0kaWNjB03LG
         K03+cy5xpTGTNtQurz/MPu/152iJPkJEze/jsb3485E78OHmOnWhzm7f9nY1ddsK06
         Qka8RGquic/L1FIb2M9e1CTwBvKNOs8Gkdwl7LAWIWuhCa5MTsX/2RmI7JI2d/XK/j
         +kCBqIlWjN4QarV3DkXJi+dLymUcTuxtyriCaF2RSi/QTuC2P50/19UgqVBuDBqHgp
         F3h+Ovg/Pxfgw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath12k: relax list iteration in
 ath12k_mac_vif_unref()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230704173718.73462-1-dmantipov@yandex.ru>
References: <20230704173718.73462-1-dmantipov@yandex.ru>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     linux-wireless@vger.kernel.org,
        Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169105425867.894438.9777925253854685391.kvalo@kernel.org>
Date:   Thu,  3 Aug 2023 09:17:40 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> wrote:

> In ath12k_mac_vif_unref() dp->tx_desc_used_list[i]
> is not altered so list_for_each_entry() should be safe.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

89a9dda1430a wifi: ath12k: relax list iteration in ath12k_mac_vif_unref()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230704173718.73462-1-dmantipov@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

