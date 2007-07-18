Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:57874 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758534AbXGRQ1Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 12:27:24 -0400
Date: Wed, 18 Jul 2007 18:27:40 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: David Miller <davem@davemloft.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: fix GCC warning on 64bit platforms
Message-ID: <20070718182740.69addc09@griffin.suse.cz>
In-Reply-To: <469E3C70.4070809@lwfinger.net>
References: <20070714.185935.18577806.davem@davemloft.net>
	<20070714.204116.23012949.davem@davemloft.net>
	<20070716184653.355253bf@griffin.suse.cz>
	<20070716.145358.35015496.davem@davemloft.net>
	<20070718171044.2de287cd@griffin.suse.cz>
	<469E3C70.4070809@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 18 Jul 2007 11:14:40 -0500, Larry Finger wrote:
> > -	local->tx_headroom = max(local->hw.extra_tx_headroom,
> > -				 sizeof(struct ieee80211_tx_status_rtap_hdr));
> > +	local->tx_headroom = max_t(unsigned, local->hw.extra_tx_headroom,
> > +				   sizeof(struct ieee80211_tx_status_rtap_hdr));
> >  
> >  	debugfs_hw_add(local);
> 
> For my info on how to use max_t, not as a critique of this patch.
> (1) Is 'unsigned' enough or should it be 'unsigned int'?

Don't know. For a C compiler, it doesn't matter, but it's fact that
most of the code in the kernel uses "unsigned int".

> (2) Because tx_headroom is an int, why use unsigned at all?

Because hw.extra_tx_headroom is unsigned. tx_headroom should be IMO
unsigned too but that's not just a matter of changing its type as it
would mean a lot of new warnings. We're talking about numbers several
orders less than int, so it's not an issue here anyway.

If you think "int" is more appropriate, fine with me, I don't really
care.

 Jiri

-- 
Jiri Benc
SUSE Labs
