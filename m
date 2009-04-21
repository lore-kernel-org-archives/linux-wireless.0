Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33864 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZDUUqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 16:46:07 -0400
Date: Tue, 21 Apr 2009 16:32:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rami Rosen <roszenrami@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	Johannes Berg <johannes@sipsolutions.net>, buytenh@marvell.com
Subject: Re: [PATCH ] [RESEND] mwl8: fix build warning.
Message-ID: <20090421203253.GM3369@tuxdriver.com> (sfid-20090421_224610_376128_6ADF6690)
References: <b25312890904210622v3b84eb45pdef0cb3bce253ba0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b25312890904210622v3b84eb45pdef0cb3bce253ba0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 21, 2009 at 04:22:01PM +0300, Rami Rosen wrote:
> This patch fixes a build warning in mwl8.c.
> (Marvell TOPDOG wireless driver)
> 
> The warning it fixes is: "large integer implicitly truncated to unsigned type."
> 
> The rx_ctrl member of the mwl8k_rx_desc struct is 8 bit (__u8 ), whereas trying
> to assign it a 32 bit value (which is returned from  cpu_to_le32())
> causes the compiler to issue
> a truncation warning.
> 
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>
> 
> --
> (wireless-next)
> 
> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> index 57a0268..8bc016c 100644
> --- a/drivers/net/wireless/mwl8k.c
> +++ b/drivers/net/wireless/mwl8k.c
> @@ -893,8 +893,7 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw,
> int index)
>                rx_desc->next_rx_desc_phys_addr =
>                        cpu_to_le32(rxq->rx_desc_dma
>                                                + nexti * sizeof(*rx_desc));
> -               rx_desc->rx_ctrl =
> -                       cpu_to_le32(MWL8K_RX_CTRL_OWNED_BY_HOST);
> +               rx_desc->rx_ctrl = MWL8K_RX_CTRL_OWNED_BY_HOST;
>        }
> 
>        return 0;

This patch is whitspace damaged.  I manually recreated it since it
is so simple, but please do be more careful with future patches.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
