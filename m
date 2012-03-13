Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:35058 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753967Ab2CMCwT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 22:52:19 -0400
Message-ID: <1331607135.7100.4.camel@joe2Laptop> (sfid-20120313_035222_415442_BBDCED21)
Subject: Re: [PATCH 10/15] mwifiex: fix checkpatch --strict warnings/errors
 Part 4
From: Joe Perches <joe@perches.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Mon, 12 Mar 2012 19:52:15 -0700
In-Reply-To: <1331606291-322-1-git-send-email-bzhao@marvell.com>
References: <1331606291-322-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-12 at 19:38 -0700, Bing Zhao wrote:
[]
> diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
[]
> @@ -495,7 +495,7 @@ mwifiex_set_mac_address(struct net_device *dev, void *addr)
>  		memcpy(priv->netdev->dev_addr, priv->curr_addr, ETH_ALEN);
>  	else
>  		dev_err(priv->adapter->dev, "set mac address failed: ret=%d"
> -					    "\n", ret);
> +			"\n", ret);

Feel free to exceed 80 columns for formats.
This would be much more readable by coalescing the
formats like either of:

		dev_err(priv->adapter->dev, "set mac address failed: ret=%d\n",
			ret);
or
		dev_err(priv->adapter->dev,
			"set mac address failed: ret=%d\n", ret);
[]
> diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
[]
> @@ -391,15 +391,16 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
>  	card->txbd_ring_pbase = virt_to_phys(card->txbd_ring_vbase);
>  
>  	dev_dbg(adapter->dev, "info: txbd_ring - base: %p, pbase: %#x:%x,"
> -			"len: %x\n", card->txbd_ring_vbase,
> -			(u32)card->txbd_ring_pbase,
> -			(u32)((u64)card->txbd_ring_pbase >> 32),
> -			card->txbd_ring_size);
> +		"len: %x\n", card->txbd_ring_vbase,
> +		(u32)card->txbd_ring_pbase,
> +		(u32)((u64)card->txbd_ring_pbase >> 32),
> +		card->txbd_ring_size);

etc...


