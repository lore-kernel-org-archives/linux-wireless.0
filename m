Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0GTSWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 14:22:08 -0400
Subject: Re: [PATCH] mwl8k: correct/silence sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <1279649222-3042-1-git-send-email-linville@tuxdriver.com>
References: <1279649222-3042-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 20:22:03 +0200
Message-ID: <1279650123.3706.45.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-07-20 at 14:07 -0400, John W. Linville wrote:

>  		off = le32_to_cpu(cmd->rxwrptr) & 0xffff;
> -		iowrite32(cpu_to_le32(priv->rxq[0].rxd_dma), priv->sram + off);
> +		iowrite32((__force __u32) cpu_to_le32(priv->rxq[0].rxd_dma),
> +				priv->sram + off);

Those don't seem right, it looks more like somebody thought they needed
to byteswap the iowrite because PCI(e) is little endian, and were wrong?

johannes

