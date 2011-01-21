Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:36410 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab1AUMRE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 07:17:04 -0500
Subject: Re: [PATCH 2] cfg80211: Extend channel to frequency mapping for
 802.11j
From: Luciano Coelho <coelho@ti.com>
To: Bruno Randolf <br1@einfach.org>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gwingerde@gmail.com" <gwingerde@gmail.com>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"dcbw@redhat.com" <dcbw@redhat.com>,
	"IvDoorn@gmail.com" <IvDoorn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"bprodoehl@gmail.com" <bprodoehl@gmail.com>
In-Reply-To: <20110117043728.8024.13541.stgit@localhost6.localdomain6>
References: <20110117043728.8024.13541.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 14:16:13 +0200
Message-ID: <1295612173.1925.59.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-17 at 05:37 +0100, Bruno Randolf wrote:
> Extend channel to frequency mapping for 802.11j Japan 4.9GHz band, according to
> IEEE802.11 section 17.3.8.3.2 and Annex J. Because there are now overlapping
> channel numbers in the 2GHz and 5GHz band we can't map from channel to
> frequency without knowing the band. This is no problem as in most contexts we
> know the band. In places where we don't know the band (and WEXT compatibility)
> we assume the 2GHz band for channels below 14.
> 
> This patch does not implement all channel to frequency mappings defined in
> 802.11, it's just an extension for 802.11j 20MHz channels. 5MHz and 10MHz
> channels as well as 802.11y channels have been omitted.
> 
> The following drivers have been updated to reflect the API changes:
> iwl-3945, iwl-agn, iwmc3200wifi, libertas, mwl8k, rt2x00, wl1251, wl12xx.
> The drivers have been compile-tested only.
> 
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> 
> ---

For the wl12xx part:

> diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
> index 682304c..ec8d843 100644
> --- a/drivers/net/wireless/wl12xx/rx.c
> +++ b/drivers/net/wireless/wl12xx/rx.c
> @@ -76,7 +76,7 @@ static void wl1271_rx_status(struct wl1271 *wl,
>          */
>         wl->noise = desc->rssi - (desc->snr >> 1);
> 
> -       status->freq = ieee80211_channel_to_frequency(desc->channel);
> +       status->freq = ieee80211_channel_to_frequency(desc->channel, desc_band);
> 
>         if (desc->flags & WL1271_RX_DESC_ENCRYPT_MASK) {
>                 status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;

Acked-by: Luciano Coelho <coelho@ti.com>

-- 
Cheers,
Luca.

