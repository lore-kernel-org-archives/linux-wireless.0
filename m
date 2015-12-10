Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52619 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbbLJJ4n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 04:56:43 -0500
Message-ID: <1449741398.5376.0.camel@sipsolutions.net> (sfid-20151210_105649_159978_AB1BF4FD)
Subject: Re: Mac80211 driver crash in monitor mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Cedric VONCKEN <cedric.voncken@acksys.fr>,
	linux-wireless@vger.kernel.org
Date: Thu, 10 Dec 2015 10:56:38 +0100
In-Reply-To: <773DB8A82AB6A046AE0195C68612A31901C5B2F9@sbs2003.acksys.local> (sfid-20151210_104136_918063_D0BC614D)
References: <773DB8A82AB6A046AE0195C68612A31901C5B2F9@sbs2003.acksys.local>
	 (sfid-20151210_104136_918063_D0BC614D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-10 at 10:21 +0100, Cedric VONCKEN wrote:
> 
> In ieee80211_drv_tx function:
>  
> 	if (pubsta) {
> 		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
> 
> 		txq = pubsta->txq[tid];
> 	} else if (vif) {
> 		txq = vif->txq;
> 	} 
> 
> In my case pubsta == null so I'm going to else statement. The line
> vif->txq generate kernel pannic because the VIF pointer have been
> initialized to null in __ieee80211_tx function.
> 

Clearly you must be missing something, since the code is "else if
(vif)"

johannes
