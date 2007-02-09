Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:56386 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946481AbXBIO0n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 09:26:43 -0500
Date: Fri, 9 Feb 2007 15:26:42 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: fix authentication issues
Message-ID: <20070209152642.53a0b42b@griffin.suse.cz>
In-Reply-To: <20070209152540.32a23571@griffin.suse.cz>
References: <200702081448.19664.flamingice@sourmilk.net>
	<20070209152540.32a23571@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 9 Feb 2007 15:25:40 +0100, Jiri Benc wrote:
> On Thu, 8 Feb 2007 14:48:15 -0500, Michael Wu wrote:
> > @@ -2355,7 +2358,7 @@ int ieee80211_sta_set_bssid(struct net_d
> >  		ifsta->bssid_set = 0;
> >  	else
> >  		ifsta->bssid_set = 1;
> > -	if (ifsta->ssid_set && ifsta->state != IEEE80211_AUTHENTICATE)
> > +	if (ifsta->ssid_set)
> >  		ieee80211_sta_new_auth(dev, ifsta);
> 
> How do you protect against already running ieee80211_associate (called

Sorry, should be ieee80211_authenticate, of course.

 Jiri

-- 
Jiri Benc
SUSE Labs
