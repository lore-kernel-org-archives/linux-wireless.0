Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104A8C4332F
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Dec 2022 16:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiLVQFk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 22 Dec 2022 11:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiLVQFf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Dec 2022 11:05:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DF918B0F;
        Thu, 22 Dec 2022 08:05:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D87E61C27;
        Thu, 22 Dec 2022 16:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1CBC433D2;
        Thu, 22 Dec 2022 16:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671725134;
        bh=cW3jyW2N+O4Ffc3ACdzYPNrQDrjgtqNppbdLOaFyoYo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=sZ0s1g2pfb9FrDyrko9a1DyZObmMLCuBH9Ba/4xravWvxivA3Vb3HhjKmZRE5x4CP
         5PUslVNXQwEnvb1eAjt9otWCZQBbngcqqYXcqlCVTJpZqWUa1tWYdSDh3VtobW7PGp
         A6x2kE69AnE61vdtsSiN4nP8gQvOyK3B6S4JN9diezukg/EFijKoiphDjkO5a0Ipu8
         EK7hUzEdLcKTfMGyF8aeRJFaxQPGrxyf0lu5/7rKrqmIXqRH+9H9amdWlruBraHxaR
         7OAvnAAn/v8d4IN3hrdb30BrgwXt9nXHjf+9qawOfovCwZu5sJFh3iM6EEx/QvbaXu
         mhmJZK++ZbE2g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] wifi: ipw2200: fix memory leak in ipw_wdev_init()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221209012422.182669-1-shaozhengchao@huawei.com>
References: <20221209012422.182669-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <stas.yakovlev@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linville@tuxdriver.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167172512673.8231.13701483342037956356.kvalo@kernel.org>
Date:   Thu, 22 Dec 2022 16:05:31 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Zhengchao Shao <shaozhengchao@huawei.com> wrote:

> In the error path of ipw_wdev_init(), exception value is returned, and
> the memory applied for in the function is not released. Also the memory
> is not released in ipw_pci_probe(). As a result, memory leakage occurs.
> So memory release needs to be added to the error path of ipw_wdev_init().
> 
> Fixes: a3caa99e6c68 ("libipw: initiate cfg80211 API conversion (v2)")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Patch applied to wireless-next.git, thanks.

9fe21dc62611 wifi: ipw2200: fix memory leak in ipw_wdev_init()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221209012422.182669-1-shaozhengchao@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

