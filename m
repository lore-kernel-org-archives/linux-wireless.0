Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0FHHZM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jun 2010 03:25:12 -0400
Subject: Re: [PATCH] iwlwifi: add missing rcu_read_lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTin91YUTC8ogoflpFN4V3f21ItLlV_EoFU-uvrzo@mail.gmail.com>
References: <1275938438.29978.23.camel@jlt3.sipsolutions.net>
	 <AANLkTin91YUTC8ogoflpFN4V3f21ItLlV_EoFU-uvrzo@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 09:25:03 +0200
Message-ID: <1275981903.3706.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-07 at 17:31 -0400, Miles Lane wrote:

> > --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn-tx.c     2010-06-07 21:17:56.000000000 +0200
> > +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn-tx.c  2010-06-07 21:18:04.000000000 +0200
> > @@ -1146,6 +1146,7 @@ static void iwlagn_tx_status(struct iwl_
> >        struct ieee80211_sta *sta;
> >        struct iwl_station_priv *sta_priv;
> >
> > +       rcu_read_lock();
> >        sta = ieee80211_find_sta(priv->vif, hdr->addr1);
> >        if (sta) {
> >                sta_priv = (void *)sta->drv_priv;
> > @@ -1154,6 +1155,7 @@ static void iwlagn_tx_status(struct iwl_
> >                    atomic_dec_return(&sta_priv->pending_frames) == 0)
> >                        ieee80211_sta_block_awake(priv->hw, sta, false);
> >        }
> > +       rcu_read_unlock();
> >
> >        ieee80211_tx_status_irqsafe(priv->hw, skb);
> >  }
> >
> >
> >
> 
> Unclean patch application - is this to be expected?
> 
> patching file drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> Hunk #1 succeeded at 1125 (offset -21 lines).
> Hunk #2 succeeded at 1134 (offset -21 lines).

Didn't pay much attention what tree I generated it against since I knew
this code hasn't changed in a while ... so the offset looks perfectly
fine. Fuzz I'd have been surprised about :)

johannes

