Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42EBEB64DD
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Jul 2023 18:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbjGLS14 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Jul 2023 14:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbjGLS1z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jul 2023 14:27:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D341CDC;
        Wed, 12 Jul 2023 11:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=u0DMZJiVIf563aqVx60BkXx3lve5bk9ZgOTpPvU5Mu0=; b=EoK+8bj1c8leE24XB6sfrjwrsO
        Af4oBayvGsRkwBvQmKmyZRkTUug4T5dPHblMRemI0875e+dzC2CVMgL9EO9DesFx4y88EgBTXqOJd
        cGC0WyVn+NSfhKEKrqri6eginv0tON5ut4P3TXarqd5krV6Y1HtP4gGgjAhE6Iha0h+wfTqKX7NVl
        NA10OSiuCRvhJGN1yKiBtKoZ9cusy/DMfficR0YYNMRrZSSWHg2yuCPazfyuETExvIXJCCKccwxTn
        /ibjxC35fSDl1xxM05sJY6PJTba6Hqp6Kv7njid7grNibyue+pGqL53uK+hUd0zhz0YOHKRyCFaNQ
        kyHMCvrQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qJeZ6-000tN5-0m;
        Wed, 12 Jul 2023 18:27:52 +0000
Date:   Wed, 12 Jul 2023 11:27:52 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Minjie Du <duminjie@vivo.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "open list:ATHEROS ATH5K WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        opensource.kernel@vivo.com
Subject: Re: [PATCH v1] drivers: wireless: ath5k: fix parameter check in
 ath5k_debug_init_device
Message-ID: <ZK7wqH86hEswxGo6@bombadil.infradead.org>
References: <20230712124259.15096-1-duminjie@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712124259.15096-1-duminjie@vivo.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jul 12, 2023 at 08:42:59PM +0800, Minjie Du wrote:
> Make IS_ERR() judge the debugfs_create_dir() function return
> in ath5k_debug_init_device().
> 
> Signed-off-by: Minjie Du <duminjie@vivo.com>
> ---
>  drivers/net/wireless/ath/ath5k/debug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
> index 4b41160e5..08058b3f7 100644
> --- a/drivers/net/wireless/ath/ath5k/debug.c
> +++ b/drivers/net/wireless/ath/ath5k/debug.c
> @@ -982,7 +982,7 @@ ath5k_debug_init_device(struct ath5k_hw *ah)
>  	ah->debug.level = ath5k_debug;
>  
>  	phydir = debugfs_create_dir("ath5k", ah->hw->wiphy->debugfsdir);
> -	if (!phydir)
> +	if (IS_ERR(phydir))

Please use IS_ERR_OR_NULL() instead.

With that change added:

Acked-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
