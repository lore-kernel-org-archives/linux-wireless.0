Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C878FC3DA6F
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Aug 2023 10:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242150AbjHYKCs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Aug 2023 06:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243310AbjHYKCk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Aug 2023 06:02:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744FC1BCA;
        Fri, 25 Aug 2023 03:02:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1267666595;
        Fri, 25 Aug 2023 10:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B15C433C7;
        Fri, 25 Aug 2023 10:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692957757;
        bh=JAU9g2CvtrHqFOZtrS2n1hIfXzY/RAqo3/y8vReZoNY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FWTduIcRkDaqLOtBr+aE+ap9YbeO/k1exE5LCETd/1NPSbRX6BFc3W1YUytbPEeAe
         LsihNROPxouiylEJysUmWDp0edsC6ftr78Ng/igL2/c5coV9Xw696uUJkbtJdgEGHx
         JhxlYGrvQiYwRxltt0muHYpsEw8ZHFrga69M/KfQcVu4qv8yyBk+uqcuw0birhDKa6
         z3RC5WRjo3UahwMvcIr+mCtliK4dgtj0GeWuAh+2eLDJM7FTWSVSvjn2emw9vN4FFw
         X9An4U9qaQydu8JtKa+0EBbbk71e+or7V56CzeNWy7YcdZt72pI6XnuWzZ+Dd7F36i
         5eYGPvME7rMbQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: wifi: rtw88: usb: kill and free rx urbs on probe failure
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230823075021.588596-1-s.hauer@pengutronix.de>
References: <20230823075021.588596-1-s.hauer@pengutronix.de>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        =?utf-8?q?Ilgaz_=C3=96cal?= <ilgaz@ilgaz.gen.tr>,
        kernel@pengutronix.de
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169295775420.1850672.11682917620915060270.kvalo@kernel.org>
Date:   Fri, 25 Aug 2023 10:02:35 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sascha Hauer <s.hauer@pengutronix.de> wrote:

> After rtw_usb_alloc_rx_bufs() has been called rx urbs have been
> allocated and must be freed in the error path. After rtw_usb_init_rx()
> has been called they are submitted, so they also must be killed.
> 
> Add these forgotten steps to the probe error path.
> 
> Besides the lost memory this also fixes a problem when the driver
> fails to download the firmware in rtw_chip_info_setup(). In this
> case it can happen that the completion of the rx urbs handler runs
> at a time when we already freed our data structures resulting in
> a kernel crash.
> 
> Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
> Cc: stable@vger.kernel.org
> Reported-by: Ilgaz Öcal <ilgaz@ilgaz.gen.tr>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

290564367ab7 wifi: rtw88: usb: kill and free rx urbs on probe failure

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230823075021.588596-1-s.hauer@pengutronix.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

