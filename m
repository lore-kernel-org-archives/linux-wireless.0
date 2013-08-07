Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60520 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757042Ab3HGHS3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 03:18:29 -0400
Message-ID: <5201F4B9.1080109@openwrt.org> (sfid-20130807_091832_575372_752B5D6B)
Date: Wed, 07 Aug 2013 09:18:17 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 2/2] ath9k: Run the LNA combining algorithm properly
References: <1375858768-24655-1-git-send-email-sujith@msujith.org> <1375858768-24655-3-git-send-email-sujith@msujith.org>
In-Reply-To: <1375858768-24655-3-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-08-07 8:59 AM, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> The LNA combining algorithm has to be run for cards
> that support the required diversity features, make
> sure that that correct conditions are met before
> enabing this algorithm.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/recv.c | 46 ++++++++++++++++++++++-------------
>  1 file changed, 29 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index 865e043..e359557 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -1156,7 +1156,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>  	struct ath_buf *bf;
>  	struct sk_buff *skb = NULL, *requeue_skb, *hdr_skb;
>  	struct ieee80211_rx_status *rxs;
> -	struct ath_hw *ah = sc->sc_ah;
> +	struct ath_hw *ah = sc->sc_ah
> +;	struct ath9k_hw_capabilities *pCap = &ah->caps;
>  	struct ath_common *common = ath9k_hw_common(ah);
>  	struct ieee80211_hw *hw = sc->hw;
>  	struct ieee80211_hdr *hdr;
Misplaced semicolon
