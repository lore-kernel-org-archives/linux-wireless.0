Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3628 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab2GINxc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 09:53:32 -0400
Message-ID: <4FFAE252.4070504@broadcom.com> (sfid-20120709_155339_294560_D08D6286)
Date: Mon, 9 Jul 2012 15:53:22 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Thomas Huehn" <thomas@net.t-labs.tu-berlin.de>
cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	"brcm80211 development" <brcm80211-dev-list@broadcom.com>,
	linville@tuxdriver.com
Subject: Re: [PATCH v2] brcmsmac: restructure info->control.sta handling
 as it is goning to be removed soon.
References: <1340974563-77085-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1340974563-77085-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2012 02:56 PM, Thomas Huehn wrote:
> brcmsmac uses info->control.sta while doing ampdu aggregation. This patch
> changes the usage of the structure info->control.sta, as it is going to be
> removed soon from struct ieee80211_tx_info. This patch is a pre-requisit in
> order to add transmission power control (TPC) to the mac80211 subsystem.
> 
> Suggested-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> ---
> Change sequence of overwriting data. Thx to Johannes.
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/ampdu.c       |   10 +++++-----
>  drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    2 ++
>  drivers/net/wireless/brcm80211/brcmsmac/main.c        |    2 +-
>  3 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> index 01b190a..d341c91 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> @@ -665,7 +665,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
>  			u8 plcp0, plcp3, is40, sgi;
>  			struct ieee80211_sta *sta;
>  
> -			sta = tx_info->control.sta;
> +			sta = tx_info->rate_driver_data[0];

The sta pointer is not used in this function so this assignment is not
needed. Also the rate_driver_data[0] does not yet hold the sta pointer
upon reaching this function. brcms_c_sendampdu is called from
brcms_c_sendpkt_mac80211 (see below).

Just remove the sta pointer here.

> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> index 2d5a404..f3ab8a6 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> @@ -267,6 +267,7 @@ static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate, bool is_br)
>  static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  {
>  	struct brcms_info *wl = hw->priv;
> +	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
>  
>  	spin_lock_bh(&wl->lock);
>  	if (!wl->pub->up) {
> @@ -275,6 +276,7 @@ static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  		goto done;
>  	}
>  	brcms_c_sendpkt_mac80211(wl->wlc, skb, hw);
> +	tx_info->rate_driver_data[0] = tx_info->control.sta;
>   done:
>  	spin_unlock_bh(&wl->lock);
>  }

Gr. AvS

