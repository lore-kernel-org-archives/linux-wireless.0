Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.einfach.org ([80.86.92.145]:53679 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0CBBSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 20:18:08 -0500
From: Bruno Randolf <bruno@einfach.org>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Subject: Re: [ath5k-devel] [PATCH 1/5] ath5k: fix injection in monitor mode
Date: Tue, 2 Mar 2010 10:17:33 +0900
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
References: <20100301115903.13996.95024.stgit@void> <201003012154.55633.bruno@einfach.org> <4B8C3118.30705@free.fr>
In-Reply-To: <4B8C3118.30705@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003021017.34636.bruno@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 02 March 2010 06:26:48 Benoit PAPILLAULT wrote:
> Bruno Randolf a écrit :
> > please ignore this one, sorry ;(
> > 
> > bruno
> 
> This one is cool & needed for testing IBSS merges. I have pretty much
> the same in my tree.

yes - only sc->opmode is never set. i'll come up with a patch to fix that. 

bruno


> Regards,
> Benoit
> 
> > On Monday 01 March 2010 20:59:03 Bruno Randolf wrote:
> >> injected frames have to use AR5K_PKT_TYPE_NORMAL, otherwise the hardware
> >> thinks it can mess with the contents of the frame - e.g. update the TSF
> >> of an injected beacon. injected frames should be sent as they are
> >> provided.
> >> 
> >> Signed-off-by: Bruno Randolf <br1@einfach.org>
> >> ---
> >> 
> >>  drivers/net/wireless/ath/ath5k/base.c |   11 ++++++++++-
> >>  1 files changed, 10 insertions(+), 1 deletions(-)
> >> 
> >> diff --git a/drivers/net/wireless/ath/ath5k/base.c
> >> b/drivers/net/wireless/ath/ath5k/base.c index 2468c64..904d7f0 100644
> >> --- a/drivers/net/wireless/ath/ath5k/base.c
> >> +++ b/drivers/net/wireless/ath/ath5k/base.c
> >> @@ -1285,6 +1285,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct
> >> ath5k_buf *bf, u16 cts_rate = 0;
> >> 
> >>  	u16 duration = 0;
> >>  	u8 rc_flags;
> >> 
> >> +	enum ath5k_pkt_type pkt_type;
> >> 
> >>  	flags = AR5K_TXDESC_INTREQ | AR5K_TXDESC_CLRDMASK;
> >> 
> >> @@ -1322,9 +1323,17 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct
> >> ath5k_buf *bf, duration =
> >> le16_to_cpu(ieee80211_ctstoself_duration(sc->hw,
> >> 
> >>  			sc->vif, pktlen, info));
> >>  	
> >>  	}
> >> 
> >> +
> >> +	/* we don't want the hardware to mess with injected frames in monitor
> >> +	 * mode (e.g. update TSF in beacons) */
> >> +	if (sc->opmode == NL80211_IFTYPE_MONITOR)
> >> +		pkt_type = AR5K_PKT_TYPE_NORMAL;
> >> +	else
> >> +		pkt_type = get_hw_packet_type(skb);
> >> +
> >> 
> >>  	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
> >>  	
> >>  		ieee80211_get_hdrlen_from_skb(skb),
> >> 
> >> -		get_hw_packet_type(skb),
> >> +		pkt_type,
> >> 
> >>  		(sc->power_level * 2),
> >>  		hw_rate,
> >>  		info->control.rates[0].count, keyidx, ah->ah_tx_ant, flags,
> >> 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> >> linux-wireless" in the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > _______________________________________________
> > ath5k-devel mailing list
> > ath5k-devel@lists.ath5k.org
> > https://lists.ath5k.org/mailman/listinfo/ath5k-devel
