Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45461 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbbC3H6w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 03:58:52 -0400
Message-ID: <1427702330.26117.0.camel@sipsolutions.net> (sfid-20150330_095855_471225_B59248F4)
Subject: Re: [mac80211]synchronize_net call in
 ieee_tx_ba_session_handle_start
From: Johannes Berg <johannes@sipsolutions.net>
To: Cedric VONCKEN <cedric.voncken@acksys.fr>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Mar 2015 09:58:50 +0200
In-Reply-To: <773DB8A82AB6A046AE0195C68612A319019FF102@sbs2003.acksys.local> (sfid-20150326_143808_740496_6ABC8BB2)
References: <773DB8A82AB6A046AE0195C68612A319019FF102@sbs2003.acksys.local>
	 (sfid-20150326_143808_740496_6ABC8BB2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-03-26 at 14:17 +0100, Cedric VONCKEN wrote:
> The synchronize_net called in function ieee_tx_ba_session_handle_start
> generate a jiter after the association. I can observe a long period
> (100ms or more) where no data are sent because mac80211 is blocked in
> synchronize_net.
> 
> My product has several network interface and processor with 4 cores.
> 
> If I understood correctly, in case we use the ath9k driver, the function
> drv_ampdu_action will call the ath_tx_aggr_start and this function will
> flush the tx pending packet and return the next sequence number. So in
> this case it is not necessary to call this function.
> 
> Is it possible to remove this function, or I need to consider another
> case?

I believe you need to consider concurrent TX processing inside mac80211.

johannes

