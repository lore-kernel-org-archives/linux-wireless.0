Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:44553 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756096AbXD0Rjy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 13:39:54 -0400
Date: Fri, 27 Apr 2007 19:40:15 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 10/13] mac80211: set bssid to broadcast before scan
Message-ID: <20070427194015.602759a1@griffin.suse.cz>
In-Reply-To: <1177431851.3528.36.camel@johannes.berg>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	<20070423184814.7029.99423.stgit@magic.sourmilk.net>
	<1177431851.3528.36.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 24 Apr 2007 18:24:11 +0200, Johannes Berg wrote:
> On Mon, 2007-04-23 at 14:48 -0400, Michael Wu wrote:
> 
> > --- a/net/mac80211/ieee80211_i.h
> > +++ b/net/mac80211/ieee80211_i.h
> > @@ -502,6 +502,7 @@ struct ieee80211_local {
> >  	struct ieee80211_hw_mode *oper_hw_mode, *scan_hw_mode;
> >  	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
> >  	size_t scan_ssid_len;
> > +	u8 scan_bssid[ETH_ALEN];
> >  	struct list_head sta_bss_list;
> >  	struct ieee80211_sta_bss *sta_bss_hash[STA_HASH_SIZE];
> >  	spinlock_t sta_bss_lock;
> 
> Do you see any use for setting scan_bssid to anything other than the
> broadcast address? It doesn't seem useful to add this field here at this
> time.

I agree.

And I'd like to see some way to disable this feature for sane cards.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
