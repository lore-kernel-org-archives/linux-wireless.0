Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:40871 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754108AbZKHQBB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 11:01:01 -0500
Date: Sun, 8 Nov 2009 18:00:56 +0200
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, mcgrof@gmail.com,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Subject: Re: [PATCH 06/29] ath9k: use correct hw for tx aggregation TX
	completion
Message-ID: <20091108160056.GA9508@jm.kir.nu>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com> <1257625146-17971-7-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1257625146-17971-7-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 07, 2009 at 03:18:43PM -0500, Luis R. Rodriguez wrote:
> When ath9k virtual wiphys are used the sc->hw will not always represent
> the active hw, instead we need to get it from the skb->cb private
> driver area. This ensures the right hw is used to find a sta for
> the TX'd skb.

> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -267,7 +267,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
> +	struct ieee80211_hw *hw;
>  	struct ieee80211_hdr *hdr;
> +	struct ieee80211_tx_info *tx_info;
> +	struct ath_tx_info_priv *tx_info_priv;

> @@ -280,6 +283,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
> +	tx_info = IEEE80211_SKB_CB(skb);
> +	tx_info_priv = (struct ath_tx_info_priv *) tx_info->rate_driver_data[0];
> +	hw = tx_info_priv->aphy->hw;

Umm.. This adds a set of new local variables, but no users for those
are added here. Was this supposed to also change the following
ieee80211_find_sta_by_hw() call to use the local hw variable instead of
sc->hw?

-- 
Jouni Malinen                                            PGP id EFC895FA
