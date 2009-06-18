Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46649 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234AbZFRIMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 04:12:06 -0400
Date: Thu, 18 Jun 2009 10:12:06 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	libertas-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] libertas: correct card cleanup order in SPI driver
Message-ID: <20090618081206.GB2770@Chamillionaire.breakpoint.cc>
References: <1245290925-25468-1-git-send-email-andrey@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <1245290925-25468-1-git-send-email-andrey@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Andrey Yurovsky | 2009-06-17 19:08:45 [-0700]:

>Also fix a warning from the wrong uint format in a printk.
>
>Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
>---
> drivers/net/wireless/libertas/if_spi.c |    7 ++++---
> 1 files changed, 4 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
>index 923ed58..8d8bc0b 100644
>--- a/drivers/net/wireless/libertas/if_spi.c
>+++ b/drivers/net/wireless/libertas/if_spi.c
>@@ -737,7 +737,7 @@ static int if_spi_c2h_data(struct if_spi_card *card)
> 		goto out;
> 	} else if (len > MRVDRV_ETH_RX_PACKET_BUFFER_SIZE) {
> 		lbs_pr_err("%s: error: card has %d bytes of data, but "
>-			   "our maximum skb size is %lu\n",
>+			   "our maximum skb size is %u\n",
ehm, this reverts commit 9b171ffe1 aka "libertas: fix format warning" in
Dave's next tree [0]. Max skb is defined via

|#define MRVDRV_ETH_RX_PACKET_BUFFER_SIZE \
|    (ETH_FRAME_LEN + sizeof(struct rxpd) \
|     + MRVDRV_SNAP_HEADER_LEN + EXTRA_LEN)

and sizeof() probably says which type it is, so this is probably 32bit
vs 64bit. Wouldn't this be the perfect place for the z modifier?

[0]
http://git.kernel.org/?p=linux/kernel/git/davem/net-next-2.6.git;a=commitdiff;h=9b171ffe1b3004587f4a90ef293531a4a262e538

Sebastian
