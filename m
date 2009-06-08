Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55742 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbZFHV6U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 17:58:20 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2009 14:58:23 -0700
Date: Mon, 8 Jun 2009 14:58:23 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: reinette chatre <reinette.chatre@intel.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"j@w1.fi" <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Gabor Juhos <juhosg@openwrt.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: Re: [PATCH v2 14/15] mac80211: add helper for management / no-ack
	frame rate decision
Message-ID: <20090608215823.GB380@tesla>
References: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com> <1244246629-28179-15-git-send-email-lrodriguez@atheros.com> <1244492902.20900.196.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1244492902.20900.196.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 08, 2009 at 01:28:22PM -0700, reinette chatre wrote:
> Hi Luis,
> 
> On Fri, 2009-06-05 at 17:03 -0700, Luis R. Rodriguez wrote:
> > All current rate control algorithms agree to send management and no-ack
> > frames at the lowest rate. They also agree to do this when sta
> > and the private rate control data is NULL. We add a hlper to mac80211
> > for this and simplify the rate control algorithm code.
> >
> > Developers wishing to make enhancements to rate control algorithms
> > are for broadcast/multicast can opt to not use this in their
> > gate_rate() mac80211 callback.
> >
> > Cc: Zhu Yi <yi.zhu@intel.com>
> > Cc: Reinette Chatre <reinette.chatre@intel.com>
> > Cc: ipw3945-devel@lists.sourceforge.net
> > Cc: Gabor Juhos <juhosg@openwrt.org>
> > Cc: Felix Fietkau <nbd@openwrt.org>
> > Cc: Derek Smithies <derek@indranet.co.nz>
> > Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/rc.c        |   14 +------------
> >  drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   21 ++-----------------
> >  drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   12 +----------
> >  include/net/mac80211.h                     |   23 ++++++++++++++++++++++
> >  net/mac80211/rate.c                        |   29 ++++++++++++++++++++++++++++
> >  net/mac80211/rc80211_minstrel.c            |   22 +--------------------
> >  net/mac80211/rc80211_pid_algo.c            |   11 +---------
> >  7 files changed, 59 insertions(+), 73 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
> > index d8d2152..9199ce9 100644
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
> > index bd2f709..8bd496f 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
> > @@ -673,7 +673,6 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
> >       s8 scale_action = 0;
> >       unsigned long flags;
> >       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> > -     __le16 fc;
> >       u16 rate_mask = 0;
> >       s8 max_rate_idx = -1;
> >       struct iwl_priv *priv = (struct iwl_priv *)priv_r;
> > @@ -681,24 +680,10 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
> >
> >       IWL_DEBUG_RATE(priv, "enter\n");
> >
> > -     if (sta)
> > -             rate_mask = sta->supp_rates[sband->band];
> > -
> > -     /* Send management frames and NO_ACK data using lowest rate. */
> > -     fc = hdr->frame_control;
> > -     if (!ieee80211_is_data(fc) || info->flags & IEEE80211_TX_CTL_NO_ACK ||
> > -         !sta || !priv_sta) {
> > -             IWL_DEBUG_RATE(priv, "leave: No STA priv data to update!\n");
> > -             if (!rate_mask)
> > -                     info->control.rates[0].idx =
> > -                                     rate_lowest_index(sband, NULL);
> > -             else
> > -                     info->control.rates[0].idx =
> > -                                     rate_lowest_index(sband, sta);
> > -             if (info->flags & IEEE80211_TX_CTL_NO_ACK)
> > -                     info->control.rates[0].count = 1;
> > +     if (rate_control_send_low(sta, priv_sta, txrc))
> >               return;
> > -     }
> > +
> > +     rate_mask = sta->supp_rates[sband->band];
> >
> >       /* get user max rate if set */
> >       max_rate_idx = txrc->max_rate_idx;
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
> > index ff20e50..7a3e4dd 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
> > @@ -2485,18 +2485,8 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
> >               mask_bit = sta->supp_rates[sband->band];
> >
> >       /* Send management frames and NO_ACK data using lowest rate. */
> > -     if (!ieee80211_is_data(hdr->frame_control) ||
> > -         info->flags & IEEE80211_TX_CTL_NO_ACK || !sta || !lq_sta) {
> > -             if (!mask_bit)
> > -                     info->control.rates[0].idx =
> > -                                     rate_lowest_index(sband, NULL);
> > -             else
> > -                     info->control.rates[0].idx =
> > -                                     rate_lowest_index(sband, sta);
> > -             if (info->flags & IEEE80211_TX_CTL_NO_ACK)
> > -                     info->control.rates[0].count = 1;
> > +     if (rate_control_send_low(sta, priv_r, txrc))
> >               return;
> > -     }
> >
> >       rate_idx  = lq_sta->last_txrate_idx;
> 
> 
> The iwlwifi way of computing rates is not captured in the new helper. We
> used to do it in the way you change it to, but run into the
> "rs_get_rate" WARN very often (see
> http://www.kerneloops.org/searchweek.php?search=rs_get_rate and
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1822 ). We
> submitted patch "iwlwifi: fix rs_get_rate WARN_ON()" to address that.
> 
> Changing this back will make that warning reappear.

Point taken -- this highlights an issue we see if we apply these patches
and this needs to be dealt with properly. For example if we're a STA and
already associated I don't believe it makes sense to send data to the sta
if the sta does not support the minimum bitrate. The issue here would be
we're trying to send to the sta using a band it does not support. I'll look
into this a bit further...

  Luis
