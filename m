Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx71.mail.ru ([94.100.176.85]:57904 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbZG3PFh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 11:05:37 -0400
Subject: Re: [RFC PATCH] mac80211: FIF_PSPOLL filter flag
From: Igor Perminov <igor.perminov@inbox.ru>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248963525.16129.2.camel@johannes.local>
References: <1248962000.29068.170.camel@sunlight>
	 <1248963525.16129.2.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 19:05:36 +0400
Message-Id: <1248966336.29068.178.camel@sunlight>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > @@ -497,6 +509,13 @@ static int ieee80211_stop(struct net_device *dev)
> >  		}
> >  		/* fall through */
> >  	default:
> > +		if (sdata->vif.type == NL80211_IFTYPE_AP) {
> 
> I'd probably put this after a
> 	case NL80211_IFTYPE_AP:
> label but you need the if () anyway ... hmm I guess we really should
> clean up this code and split it into two switch statements...

And may be do it above?

	if (sdata->flags & IEEE80211_SDATA_ALLMULTI)
		atomic_dec(&local->iff_allmultis);

	if (sdata->flags & IEEE80211_SDATA_PROMISC)
		atomic_dec(&local->iff_promiscs);

+	if (sdata->vif.type == NL80211_IFTYPE_AP)
+		local->fif_pspoll--;
+
	netif_addr_lock_bh(dev);
	spin_lock_bh(&local->filter_lock);
	__dev_addr_unsync(&local->mc_list, &local->mc_count,
			  &dev->mc_list, &dev->mc_count);
	ieee80211_configure_filter(local);
	spin_unlock_bh(&local->filter_lock);
	netif_addr_unlock_bh(dev);

Igor


