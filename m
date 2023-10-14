Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8196ECDB47E
	for <linux-wireless@archiver.kernel.org>; Sat, 14 Oct 2023 01:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjJNBNI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Oct 2023 21:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjJNBNI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2023 21:13:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555D995;
        Fri, 13 Oct 2023 18:13:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED41C433C7;
        Sat, 14 Oct 2023 01:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697245987;
        bh=n50kcxXI9A3yMV6jxB8NrEwZdjVrYAXqsMjPwBDWtY8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rNoygbMPeUIwtR64hZ7Q9YWWviszucUMdTDI1AIStFs/rvaOC69pt3n9quzesBklA
         QSAIC1b1su7cYyKrsjrSTAbSJNA4+Eq/7vBX5pRwX8JuEkD1u442a7Qz3sYL+tVjH6
         DtAOwHRgKy++OtzgwGKsxXIbNu+45VYfWHcjhYJQ3c4tcxjIq82FPKlNLawkVoEGyY
         cl9plrQrT7vQesR4b8c1y7wnQKg5AQQmi5XkP4EyaDQ0pLKwAM/TShTPymf0aWp0Q8
         x+qbRJu+c+B0N/m1qoJ5lnrHiHRS12f5N8pv67DNwUMkG+F1sdMpEoX2V6CcSyIQ8c
         9HlJizg1+GI/w==
Date:   Fri, 13 Oct 2023 18:13:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Simon Horman <horms@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [net-next PATCH v2 3/4] net: stmmac: move TX timer arm after
 DMA enable
Message-ID: <20231013181305.605fc789@kernel.org>
In-Reply-To: <20231012100459.6158-4-ansuelsmth@gmail.com>
References: <20231012100459.6158-1-ansuelsmth@gmail.com>
        <20231012100459.6158-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 12 Oct 2023 12:04:58 +0200 Christian Marangi wrote:
> +static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue

missing comma at the end, does not build :(
-- 
pw-bot: cr
