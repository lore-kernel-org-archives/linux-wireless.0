Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:58638 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbXKVEhl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 23:37:41 -0500
Date: Wed, 21 Nov 2007 20:37:22 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: mabbas <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>, linville@tuxdriver.com
Subject: Re: wpa_supplicant/key deletion with all-zeroes mac (was: security
	question)
Message-ID: <20071122043722.GC8672@jm.kir.nu> (sfid-20071122_043751_049795_89B5F8B0)
References: <4743E5DF.9040603@linux.intel.com> <1195658254.12000.23.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1195658254.12000.23.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 21, 2007 at 04:17:34PM +0100, Johannes Berg wrote:

> > When I connect to an AP with wpa, then I receive deauth frame, 
> > ieee80211_rx_mgmt_deauth will be called, which will call 
> > ieee80211_set_associated(dev, ifsta, 0); to disconnect. In function 
> > ieee80211_set_associated, it calls wireless_send_event with SIOCGIWAP 
> > event and memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN).

This sounds correct.

> > wpa_supplicant will 
> > receives this event then call mac80211 to remove any old security key, 
> > the problem it will pass 00:00:00:00:00:00 as station address. 

This sounds broken. wpa_supplicant should remove the key for the
previous BSSID.

> > ieee80211_set_encryption will fail since there are no station with 
> > 00:00:00:00:00:00. This will leave the old key which causes the problems 
> > in the next reconnection.

This sounds correct behavior.

> Interesting. I'd think this is a wpa_supplicant bug, Jouni, how is the
> security wext stuff supposed to work here?

Agreed, this sounds like a bug in wpa_supplicant. Unicast keys should be
removed with their correct address. I think this used to work, but maybe
some of the changes in BSSID processing in disassociation cases caused
the old BSSID to be forgotten.

> > diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
> > @@ -97,7 +97,10 @@ static int ieee80211_set_encryption(struct net_device *dev, u8 *sta_addr,
> > -		sta = sta_info_get(local, sta_addr);
> > +		if (is_zero_ether_addr(sta_addr))
> > +			sta = sta_info_get(local, sdata->u.sta.bssid);
> > +		else
> > +			sta = sta_info_get(local, sta_addr);

NAK. I don't think this is the correct fix here.

-- 
Jouni Malinen                                            PGP id EFC895FA
