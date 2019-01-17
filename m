Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDF2C43444
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 19:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 707E220859
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 19:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbfAQT3v (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 14:29:51 -0500
Received: from smtprelay0142.hostedemail.com ([216.40.44.142]:43993 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727672AbfAQT3v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 14:29:51 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id D496E181D341B;
        Thu, 17 Jan 2019 19:29:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: shelf69_387f0b76acd2b
X-Filterd-Recvd-Size: 1789
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Thu, 17 Jan 2019 19:29:48 +0000 (UTC)
Message-ID: <e68c7ae7b0a863742df0f4457368a3a529ed47e5.camel@perches.com>
Subject: Re: [PATCH] rtlwifi: rtl818x: fix indentation issue
From:   Joe Perches <joe@perches.com>
To:     Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Date:   Thu, 17 Jan 2019 11:29:46 -0800
In-Reply-To: <20190117152859.6873-1-colin.king@canonical.com>
References: <20190117152859.6873-1-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-01-17 at 15:28 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a statement that is indented too deeply. Fix this.

Thanks.

> diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
[]
> @@ -803,7 +803,7 @@ static void rtl8180_config_cardbus(struct ieee80211_hw *dev)
>  		rtl818x_iowrite16(priv, FEMR_SE, 0xffff);
>  	} else {
>  		reg16 = rtl818x_ioread16(priv, &priv->map->FEMR);
> -			reg16 |= (1 << 15) | (1 << 14) | (1 << 4);
> +		reg16 |= (1 << 15) | (1 << 14) | (1 << 4);
>  		rtl818x_iowrite16(priv, &priv->map->FEMR, reg16);
>  	}

trivia:

It sure looks as if there could be some rather useful
conversions of magic bits to constants one day.



