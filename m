Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F08BC4332F
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Mar 2022 15:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238102AbiCJPyA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Mar 2022 10:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbiCJPx6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Mar 2022 10:53:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C91C248D;
        Thu, 10 Mar 2022 07:52:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 964DAB8254A;
        Thu, 10 Mar 2022 15:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4896FC340E8;
        Thu, 10 Mar 2022 15:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646927570;
        bh=5BSwm39TVBk+/sZEf4qJ0qeckWgsRWt03o2mAj/NKBo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=iztUl96yqpYaN8ldIISRZ4beF2U7oSDfAk4g8B9u/CydhoPrjL4CtyqNp4A6DF9v4
         TLyHxDJID1gninumbb5OeoQXzsrtSHXrLCPKprwKYaIoVpC1goP0pZERFo9CgxkGl8
         l5+gAp++knf9OsUKoSBfvWaFbUgCF1m1fpfmiig8C0rufZTfRgmzjyoNcHzbKm60x5
         4rdZ6lbHlTqRBx5F6LDK9XzYSYnmMOAsl7aaxH4Mg90p/bJiEaWG/EnDhehg6melWp
         kjjxiKxqO8Eyowgc/fK3c994z+QIlZKAsM1wrPgSLuXIypBEjd42NGvh7Ps77n/Qcx
         1/SazEO7ufhwg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix error handling in ath10k_setup_msa_resources
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220308070238.19295-1-linmq006@gmail.com>
References: <20220308070238.19295-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linmq006@gmail.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164692756657.18489.311627042082408244.kvalo@kernel.org>
Date:   Thu, 10 Mar 2022 15:52:48 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Miaoqian Lin <linmq006@gmail.com> wrote:

> The device_node pointer is returned by of_parse_phandle() with refcount
> incremented. We should use of_node_put() on it when done.
> 
> This function only calls of_node_put() in the regular path.
> And it will cause refcount leak in error path.
> 
> Fixes: 727fec790ead ("ath10k: Setup the msa resources before qmi init")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

9747a78d5f75 ath10k: Fix error handling in ath10k_setup_msa_resources

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220308070238.19295-1-linmq006@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

