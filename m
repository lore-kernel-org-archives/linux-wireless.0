Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:56303 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbYELUkK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 16:40:10 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JveoU-0005Re-V3
	for linux-wireless@vger.kernel.org; Mon, 12 May 2008 20:40:02 +0000
Received: from mnhm-590e0d83.pool.einsundeins.de ([89.14.13.131])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 20:40:02 +0000
Received: from deller by mnhm-590e0d83.pool.einsundeins.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 20:40:02 +0000
To: linux-wireless@vger.kernel.org
From: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] ath5k: Fix loop variable initializations
Date: Mon, 12 May 2008 22:27:47 +0200
Message-ID: <g0a983$ltb$1@ger.gmane.org> (sfid-20080512_224017_722342_B7337AC8)
References: <E1JvZ2x-0005kb-TH@hash.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ath5k-devel@lists.ath5k.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Bob!

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=10605

Helge


Bob Copeland wrote:

> From: Bob Copeland <me@bobcopeland.com>
> Date: Mon, 12 May 2008 09:25:33 -0400
> Subject: [PATCH] ath5k: Fix loop variable initializations
> 
> In ath5k_tasklet_rx, both status structures 'rxs' and 'rs' are
> initialized at the top of the tasklet, but not within the loop.
> If the loop is executed multiple times in the tasklet, then the
> variables may see changes from previous packets.
> 
> For TKIP, this results in 'Invalid Michael MIC' errors if two packets
> are processed in the tasklet: rxs.flag gets set to RX_DECRYPTED by
> mac80211 when it decrypts the first encrypted packet.  The subsequent
> packet will have RX_DECRYPTED set upon entry to mac80211, so mac80211
> will not try to decrypt it.
> 
> We currently initialize all but two fields in the structures, so fix
> the other two.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/base.c |    2 +-
>  drivers/net/wireless/ath5k/hw.c   |    2 ++
>  2 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath5k/base.c
> b/drivers/net/wireless/ath5k/base.c index 4e5c8fc..fd8537e 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -1888,7 +1888,7 @@ accept:
>  * right now, so it's not too bad...
>  */
>  rxs.mactime = ath5k_extend_tsf(sc->ah, rs.rs_tstamp);
> -             rxs.flag |= RX_FLAG_TSFT;
> +             rxs.flag = RX_FLAG_TSFT;
>  
>  rxs.freq = sc->curchan->center_freq;
>  rxs.band = sc->curband->band;
> diff --git a/drivers/net/wireless/ath5k/hw.c
> b/drivers/net/wireless/ath5k/hw.c index 5fb1ae6..8137d82 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
> @@ -4119,6 +4119,7 @@ static int ath5k_hw_proc_5210_rx_status(struct
> ath5k_hw *ah,
>  rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
>  AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
>  rs->rs_status = 0;
> +     rs->rs_phyerr = 0;
>  
>  /*
>  * Key table status
> @@ -4193,6 +4194,7 @@ static int ath5k_hw_proc_5212_rx_status(struct
> ath5k_hw *ah,
>  rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
>  AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
>  rs->rs_status = 0;
> +     rs->rs_phyerr = 0;
>  
>  /*
>  * Key table status


