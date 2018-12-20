Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0AEC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 06:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 795722176F
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 06:50:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HGCrAO47";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F824Cwgq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbeLTGt4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 01:49:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60462 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbeLTGt4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 01:49:56 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 02DAB60736; Thu, 20 Dec 2018 06:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545288596;
        bh=nPKsurOyQZEjcmW6/Gl5OoYThzGf17qO9FTbrW0JGEA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=HGCrAO4727G7gLUtxrUTKjqdGfI7BdR0T4HCGe+NNaF98tpTU/WvBlTlyT1eQ3NR/
         Wdr9VMeN5o0qUzWoId4MSnj6PtrbBvFRNf1YWt4awxQPMUdd5c/pAxFXBlsU5/fguR
         q+qRorWxlat8hTMZ+hej54KPOI0lRkqiQYPC3qDc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 421C960591;
        Thu, 20 Dec 2018 06:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545288595;
        bh=nPKsurOyQZEjcmW6/Gl5OoYThzGf17qO9FTbrW0JGEA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=F824CwgqSF+inPnCsRPmnV90RMhDWqiKgyC1JwjYbkwNMrGLHWOkeBBXrBFy7Xr5W
         9ppguWCpgijh7VgUi1bRiyrKTpssoiCfnuzrseY/lsG4LQoUwLzfd6KqiP3UIsRtgy
         i/xzoVoIFqWglaBTRfMXiZqW7vN7SoOkSBRZQ6SU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 421C960591
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] cw1200: Fix concurrency use-after-free bugs in
 cw1200_hw_scan()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181214035521.30388-1-baijiaju1990@gmail.com>
References: <20181214035521.30388-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     pizza@shaftnet.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220064956.02DAB60736@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 06:49:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> The function cw1200_bss_info_changed() and cw1200_hw_scan() can be
> concurrently executed.
> The two functions both access a possible shared variable "frame.skb".
> 
> This shared variable is freed by dev_kfree_skb() in cw1200_upload_beacon(), 
> which is called by cw1200_bss_info_changed(). The free operation is 
> protected by a mutex lock "priv->conf_mutex" in cw1200_bss_info_changed().
> 
> In cw1200_hw_scan(), this shared variable is accessed without the
> protection of the mutex lock "priv->conf_mutex". 
> Thus, concurrency use-after-free bugs may occur.
> 
> To fix these bugs, the original calls to mutex_lock(&priv->conf_mutex) and 
> mutex_unlock(&priv->conf_mutex) are moved to the places, which can 
> protect the accesses to the shared variable.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

4f68ef64cd7f cw1200: Fix concurrency use-after-free bugs in cw1200_hw_scan()

-- 
https://patchwork.kernel.org/patch/10730469/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

