Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:23256 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbYJIUIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 16:08:32 -0400
Received: by mu-out-0910.google.com with SMTP id g7so128556muf.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2008 13:08:30 -0700 (PDT)
Message-ID: <1ba2fa240810091308r167b9147p46f74421329a55c1@mail.gmail.com> (sfid-20081009_220837_356461_D951CF22)
Date: Thu, 9 Oct 2008 22:08:30 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFT] iwlagn: remove pointless TX frame check
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223547733.22490.43.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223547733.22490.43.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 9, 2008 at 12:22 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> mac80211 will not send data frames on a STA mode interface
> that is not associated because the queue for it is stopped,
> and all remaining data frames that might be sent, e.g. by
> packet injection, are accepted here anyway, so remove this
> pointless check. Also hold the spinlock for less time.
>
> This will with great probability improve performance in the
> driver more than the proper descriptor layout can possibly
> cost.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Haven't tested this so far, so RFT, but I'm fairly certain it's correct.


NACK, the completion of association of mac80211 and iwlagn isn't fully
synchronized so there is still
a race.  The check can be simplified but there are much more places
that need to be touched.
Tomas

>  drivers/net/wireless/iwlwifi/iwl-tx.c |   26 +++++++-------------------
>  1 file changed, 7 insertions(+), 19 deletions(-)
>
> --- everything.orig/drivers/net/wireless/iwlwifi/iwl-tx.c       2008-10-09 11:07:05.000000000 +0200
> +++ everything/drivers/net/wireless/iwlwifi/iwl-tx.c    2008-10-09 11:08:45.000000000 +0200
> @@ -787,17 +787,18 @@ int iwl_tx_skb(struct iwl_priv *priv, st
>        unsigned long flags;
>        int ret;
>
> -       spin_lock_irqsave(&priv->lock, flags);
> -       if (iwl_is_rfkill(priv)) {
> -               IWL_DEBUG_DROP("Dropping - RF KILL\n");
> -               goto drop_unlock;
> -       }
> -
>        if ((ieee80211_get_tx_rate(priv->hw, info)->hw_value & 0xFF) ==
>             IWL_INVALID_RATE) {
>                IWL_ERROR("ERROR: No TX rate available.\n");
> +               goto drop;
> +       }
> +
> +       spin_lock_irqsave(&priv->lock, flags);
> +       if (iwl_is_rfkill(priv)) {
> +               IWL_DEBUG_DROP("Dropping - RF KILL\n");
>                goto drop_unlock;
>        }
> +       spin_unlock_irqrestore(&priv->lock, flags);
>
>        unicast = !is_multicast_ether_addr(hdr->addr1);
>
> @@ -812,19 +813,6 @@ int iwl_tx_skb(struct iwl_priv *priv, st
>                IWL_DEBUG_TX("Sending REASSOC frame\n");
>  #endif
>
> -       /* drop all data frame if we are not associated */
> -       if (ieee80211_is_data(fc) &&
> -           (priv->iw_mode != NL80211_IFTYPE_MONITOR ||
> -           !(info->flags & IEEE80211_TX_CTL_INJECTED)) && /* packet injection */
> -           (!iwl_is_associated(priv) ||
> -            ((priv->iw_mode == NL80211_IFTYPE_STATION) && !priv->assoc_id) ||
> -            !priv->assoc_station_added)) {
> -               IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
> -               goto drop_unlock;
> -       }
> -
> -       spin_unlock_irqrestore(&priv->lock, flags);
> -
>        hdr_len = ieee80211_hdrlen(fc);
>
>        /* Find (or create) index into station table for destination station */
>
>
>
