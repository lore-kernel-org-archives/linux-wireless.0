Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4933 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbZBZBGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 20:06:37 -0500
Date: Wed, 25 Feb 2009 20:06:25 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090226010625.GA10577@hash.localnet> (sfid-20090226_020641_304267_C7E831B9)
References: <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com> <49A321BA.2040500@gmail.com> <49A326A4.8090103@gmail.com> <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com> <20090224135817.GB6019@hash.localnet> <49A46AD4.3060007@gmail.com> <20090225140139.GA18694@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090225140139.GA18694@silver.sucs.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 25, 2009 at 02:01:39PM +0000, Sitsofe Wheeler wrote:
> NAS is the name of a nearby access point. This is really tough to
> reproduce but if there's anything (e.g. ftrace) I can always turn on
> that will help you track this thing down let me know. Unfortunately the
> machine is an EeePC 900 so any logging would have to be cyclic and held
> in RAM...

Hmm, I suppose there could be some error paths under memory pressure that
aren't quite right.  Here's one, but I don't think it can cause any problems,
at least without error spew.

Looking over the code, perhaps there's a race with ath5k_rx_start,
namely sc->rxlink is changed out from under the rxbuflock.  Still can't
immediately see a use-after-free there.

============

ath5k: don't overwrite bf->skbaddr unless pcu mapping fails.

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 1d77ee9..6d91335 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1140,12 +1140,14 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	struct ath5k_hw *ah = sc->ah;
 	struct sk_buff *skb = bf->skb;
 	struct ath5k_desc *ds;
+	dma_addr_t dma_addr;
 
 	if (!skb) {
-		skb = ath5k_rx_skb_alloc(sc, &bf->skbaddr);
+		skb = ath5k_rx_skb_alloc(sc, &dma_addr);
 		if (!skb)
 			return -ENOMEM;
 		bf->skb = skb;
+		bf->skbaddr = dma_addr;
 	}
 
 	/*

-- 
Bob Copeland %% www.bobcopeland.com

