Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:38576 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750846Ab1HYETT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 00:19:19 -0400
Subject: Re: [PATCH] mwifiex: replace kmalloc & memcpy sequences with
 kmemdup
From: Joe Perches <joe@perches.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Walter Harms <wharms@bfs.de>
In-Reply-To: <1314244350-13347-1-git-send-email-bzhao@marvell.com>
References: <1314244350-13347-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 21:19:16 -0700
Message-ID: <1314245956.15882.30.camel@Joe-Laptop> (sfid-20110825_061927_508398_AC8D4D4B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-24 at 20:52 -0700, Bing Zhao wrote:
> Sequences of kmalloc/kzalloc and memcpy are replaced with
> kmemdups.
> diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
[]
> -	tmp = kmalloc(rate1_size, GFP_KERNEL);
> +	tmp = kmemdup(rate1, rate1_size, GFP_KERNEL);
>  	if (!tmp) {
> -		dev_err(priv->adapter->dev, "failed to alloc tmp buf\n");
> +		dev_err(priv->adapter->dev, "failed to duplicate rate buf\n");

I wouldn't modify any OOM message.
These _are_ allocs failures.

[all the others removed]

