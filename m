Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41630 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933369AbeCMPek (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 11:34:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: Re: [PATCH 10/10] rsi: drop RX broadcast/multicast packets with invalid PN
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
        <1520260620-4694-11-git-send-email-amitkarwar@gmail.com>
Date: Tue, 13 Mar 2018 17:34:35 +0200
In-Reply-To: <1520260620-4694-11-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Mon, 5 Mar 2018 20:07:00 +0530")
Message-ID: <87r2ooyook.fsf@purkki.adurom.net> (sfid-20180313_163507_098563_51C07F05)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>
> This patch adds a check to drop received broadcast/multicast frames if
> PN is invalid (i.e. not greater than last PN). bc_mc_pn
> variable added for each interface
>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

[...]

> +static int rsi_validate_pn(struct rsi_hw *adapter, struct ieee80211_hdr *hdr)
> +{
> +	struct ieee80211_vif *vif;
> +	struct ieee80211_bss_conf *bss;
> +	struct vif_priv *vif_info = NULL;
> +	u8 cur_pn[IEEE80211_CCMP_PN_LEN];
> +	u8 *last_pn;
> +	int i, hdrlen;
> +
> +	if (!is_broadcast_ether_addr(hdr->addr1) &&
> +	    !is_multicast_ether_addr(hdr->addr1))
> +		return 1;
> +
> +	hdrlen = ieee80211_hdrlen(hdr->frame_control);
> +	for (i = 0; i < adapter->sc_nvifs; i++) {
> +		vif = adapter->vifs[i];
> +
> +		if (!vif)
> +			continue;
> +		if (vif->type != NL80211_IFTYPE_STATION &&
> +		    vif->type != NL80211_IFTYPE_P2P_CLIENT)
> +			continue;
> +		bss = &vif->bss_conf;
> +		if (!bss->assoc)
> +			continue;
> +		if (!ether_addr_equal(bss->bssid, hdr->addr2))
> +			continue;
> +		vif_info = (struct vif_priv *)vif->drv_priv;
> +		if (!vif_info->key) {
> +			vif_info = NULL;
> +			continue;
> +		}
> +		if (!vif_info->rx_pn_valid) {
> +			vif_info = NULL;
> +			continue;
> +		}
> +	}
> +	if (!vif_info)
> +		return 1;

Why +1 here?

> +	last_pn = vif_info->rx_bcmc_pn;
> +	if (vif_info->key->cipher == WLAN_CIPHER_SUITE_CCMP) {
> +		struct dot11_ccmp_hdr *ccmp =
> +			(struct dot11_ccmp_hdr *)&((u8 *)hdr)[hdrlen];
> +
> +		cur_pn[0] = ccmp->pn0;
> +		cur_pn[1] = ccmp->pn1;
> +		cur_pn[2] = ccmp->pn2;
> +		cur_pn[3] = ccmp->pn3;
> +		cur_pn[4] = ccmp->pn4;
> +		cur_pn[5] = ccmp->pn5;
> +	} else {
> +		struct dot11_tkip_hdr *tkip =
> +			(struct dot11_tkip_hdr *)&((u8 *)hdr)[hdrlen];
> +
> +		cur_pn[0] = tkip->tsc0;
> +		cur_pn[1] = tkip->tsc1;
> +		cur_pn[2] = tkip->tsc2;
> +		cur_pn[3] = tkip->tsc3;
> +		cur_pn[4] = tkip->tsc4;
> +		cur_pn[5] = tkip->tsc5;
> +	}
> +	for (i = (IEEE80211_CCMP_PN_LEN - 1); i >= 0; i--)
> +		if (last_pn[i] ^ cur_pn[i])
> +			break;
> +	if (i < 0)
> +		return -1;

And why -1 here? Please use real error codes (-EINVAL etc).

> @@ -1341,14 +1488,14 @@ static void rsi_fill_rx_status(struct ieee80211_hw *hw,
>  		}
>  	}
>  	if (!bss)
> -		return;
> +		return -1;

Here as well.

-- 
Kalle Valo
