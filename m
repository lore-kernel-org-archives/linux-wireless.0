Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40135 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab0FGVbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 17:31:45 -0400
Received: by wyi11 with SMTP id 11so2745352wyi.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jun 2010 14:31:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1275938438.29978.23.camel@jlt3.sipsolutions.net>
References: <1275938438.29978.23.camel@jlt3.sipsolutions.net>
Date: Mon, 7 Jun 2010 17:31:44 -0400
Message-ID: <AANLkTin91YUTC8ogoflpFN4V3f21ItLlV_EoFU-uvrzo@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: add missing rcu_read_lock
From: Miles Lane <miles.lane@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 7, 2010 at 3:20 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Using ieee80211_find_sta() needs to be under
> RCU read lock, which iwlwifi currently misses,
> so fix it.
>
> Cc: stable@kernel.org
> Reported-by: Miles Lane <miles.lane@gmail.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn-tx.c     2010-06-07 21:17:56.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn-tx.c  2010-06-07 21:18:04.000000000 +0200
> @@ -1146,6 +1146,7 @@ static void iwlagn_tx_status(struct iwl_
>        struct ieee80211_sta *sta;
>        struct iwl_station_priv *sta_priv;
>
> +       rcu_read_lock();
>        sta = ieee80211_find_sta(priv->vif, hdr->addr1);
>        if (sta) {
>                sta_priv = (void *)sta->drv_priv;
> @@ -1154,6 +1155,7 @@ static void iwlagn_tx_status(struct iwl_
>                    atomic_dec_return(&sta_priv->pending_frames) == 0)
>                        ieee80211_sta_block_awake(priv->hw, sta, false);
>        }
> +       rcu_read_unlock();
>
>        ieee80211_tx_status_irqsafe(priv->hw, skb);
>  }
>
>
>

Unclean patch application - is this to be expected?

patching file drivers/net/wireless/iwlwifi/iwl-agn-tx.c
Hunk #1 succeeded at 1125 (offset -21 lines).
Hunk #2 succeeded at 1134 (offset -21 lines).
