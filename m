Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29666 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZHLPhU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 11:37:20 -0400
Subject: Re: [PATCH] iwl3945: fix compilation error in
 iwl3945_pass_packet_to_mac80211()
From: reinette chatre <reinette.chatre@intel.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090812110727.4963.99515.stgit@tikku>
References: <20090812110727.4963.99515.stgit@tikku>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 08:37:20 -0700
Message-Id: <1250091440.30019.5928.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-08-12 at 04:07 -0700, Kalle Valo wrote:
> Commit "iwlwifi: Traffic type and counter for debugFs" broke iwl3945 in
> a case when CONFIG_IWLWIFI_LEDS is disabled:
> 
> drivers/net/wireless/iwlwifi/iwl-3945.c:580: error: 'hdr' undeclared (first use in this function)
> 
> Fix it by removing the ifdef check for hdr variable.
> 
> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
> ---
> 
>  drivers/net/wireless/iwlwifi/iwl-3945.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> index ae7f163..ba5ef83 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -544,9 +544,7 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
>  				   struct ieee80211_rx_status *stats)
>  {
>  	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
> -#ifdef CONFIG_IWLWIFI_LEDS
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)IWL_RX_DATA(pkt);
> -#endif
>  	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
>  	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
>  	short len = le16_to_cpu(rx_hdr->len);
> 

We have an identical patch pending. I assumed most people compile with
led support and thus did not rush to get it in. Now that it is a problem
for more people I think this one should go in.

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you

Reinette


