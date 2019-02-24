Return-Path: <SRS0=tIsG=Q7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE627C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 20:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9649520663
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 20:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbfBXUcc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Feb 2019 15:32:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59624 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbfBXUcc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Feb 2019 15:32:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3810B14CFB314;
        Sun, 24 Feb 2019 12:32:31 -0800 (PST)
Date:   Sun, 24 Feb 2019 12:32:30 -0800 (PST)
Message-Id: <20190224.123230.261167641058555597.davem@davemloft.net>
To:     wen.yang99@zte.com.cn
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com, kvalo@codeaurora.org,
        matthias.bgg@gmail.com, linux-wireless@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, anirudh@xilinx.com,
        John.Linn@xilinx.com, michal.simek@xilinx.com, wang.yi59@zte.com.cn
Subject: Re: [PATCH 5/5] net: dsa: fix a leaked reference by adding missing
 of_node_put
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1550819742-32155-5-git-send-email-wen.yang99@zte.com.cn>
References: <1550819742-32155-1-git-send-email-wen.yang99@zte.com.cn>
        <1550819742-32155-5-git-send-email-wen.yang99@zte.com.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 24 Feb 2019 12:32:31 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>
Date: Fri, 22 Feb 2019 15:15:42 +0800

> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index 8c431e0..89823f0 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -613,7 +613,7 @@ static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
>  	struct device_node *ports, *port;
>  	struct dsa_port *dp;
>  	u32 reg;
> -	int err;
> +	int err = 0;

Please preserve the reverse christmas tree ordering of variables here.

Thank you.
