Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53488 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3CGNEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 08:04:39 -0500
Message-ID: <1362661474.8694.33.camel@jlt4.sipsolutions.net> (sfid-20130307_140442_500403_E08CC9D7)
Subject: Re: [PATCH] mac80211: provide race-free 64-bit traffic counters
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com
Date: Thu, 07 Mar 2013 14:04:34 +0100
In-Reply-To: <20130307125546.GA29428@magnum.frso.rivierawaves.com> (sfid-20130307_135845_980852_1C55B43A)
References: <1362416578-1672-1-git-send-email-johannes@sipsolutions.net>
	 <20130307125546.GA29428@magnum.frso.rivierawaves.com>
	 (sfid-20130307_135845_980852_1C55B43A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-07 at 13:55 +0100, Karl Beldan wrote:

> > --- a/net/mac80211/tx.c
> > +++ b/net/mac80211/tx.c
> > @@ -991,14 +991,15 @@ static ieee80211_tx_result debug_noinline
> >  ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
> >  {
> >  	struct sk_buff *skb;
> > +	int ac = skb_get_queue_mapping(tx->skb);
> >  
> Here, ieee80211_tx_h_fragmentm has set tx->skb to NULL and this oopses.

Yeah .. I was just debugging the same thing. Ouch.

johannes

