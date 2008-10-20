Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30441 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYJTHGa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 03:06:30 -0400
Subject: Re: [PATCH v3] mac80211/drivers: rewrite the rate control API
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <1224485319.18024.9.camel@johannes.berg>
References: <1223996147.10113.33.camel@johannes.berg>
	 (sfid-20081014_165703_092655_BE6BA58D) <1224052607.3027.20.camel@johannes.berg>
	 <1224484940.24677.169.camel@debian.sh.intel.com>
	 <1224485319.18024.9.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 15:06:08 +0800
Message-Id: <1224486368.24677.184.camel@debian.sh.intel.com> (sfid-20081020_090635_395032_311DB3F1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-10-19 at 23:48 -0700, Johannes Berg wrote:
> On Mon, 2008-10-20 at 14:42 +0800, Zhu Yi wrote:
> 
> > > @@ -318,9 +348,33 @@ static void iwl3945_rx_reply_tx(struct i
> > >         }
> > > 
> > >         info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb[0]);
> > > -       memset(&info->status, 0, sizeof(info->status));
> > > +       ieee80211_tx_info_clear_status(info);
> > > +
> > > +       /* Fill the MRR chain with some info about on-chip retransmissions */
> > > +       rate_idx = iwl3945_hwrate_to_plcp_idx(tx_resp->rate);
> > > +       if (info->band == IEEE80211_BAND_5GHZ)
> > > +               rate_idx -= IWL_FIRST_OFDM_RATE;
> > > +
> > > +       info->status.rates[0].count = tx_resp->failure_frame + 1;
> > 
> > This is useless. And it is even confusable with the later count++.
> 
> In what way useless? We've changed the semantics and made "count" be the
> "transmit count" rather than the "# of retries", so it has to be one
> more. Or was there a bug in the previous understanding? Wouldn't
> surprise me, and we can fix the bug here.

I understand the +1 here. But you set the [0].count anyway in the later
for loop. So setting it here (out of the for loop) is useless.

> > > +       fail = tx_resp->failure_frame;
> > > +       for(i = 0; i < 4; i++) {
> > 
> > Where does the '4' come from? Why not IEEE80211_TX_MAX_RATES?
> > 
> > > +               int next = iwl3945_rs_next_rate(priv, rate_idx);
> > > +
> > > +               info->status.rates[i].idx = rate_idx;
> > > +
> > > +               if ((rate_idx == next) || (i == 3)) {
> > 
> > ditto
> 
> Probably should be MAX_RATES, but I'm not sure, can you explain how the
> hardware will behave for retries?

I have to look at documents for more details. AFAIK, the uCode handles
the multi rates retries. The driver passes the starting rate and how
many retries for each rates to uCode. Since the uCode is possible to
retry more rates than IEEE80211_TX_MAX_RATES, the info->status.rates[]
might not be accurate all the time. But your change should do no harm
since the info is used by neither the driver nor our rate scale
algorithm.

Thanks,
-yi

