Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:59279 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350AbYDWQ1z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 12:27:55 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>, <hostap@lists.shmoo.com>
Subject: RE: Roaming problems
Date: Wed, 23 Apr 2008 18:27:41 +0200
Message-ID: <004201c8a55e$f4668f10$0b3ca8c0@gotws1589> (sfid-20080423_182832_177349_2F15C21C)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <1208949162.31429.74.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > The below patch makes sure that we drop the BSSID when we 
> disassociate.
> 
> > --- a/ieee80211_sta.c	Wed Apr 23 10:14:30 2008
> > +++ b/ieee80211_sta.c	Wed Apr 23 08:41:23 2008
> > @@ -479,6 +479,9 @@ static void ieee80211_set_associated(str
> >  		netif_carrier_off(dev);
> >  		ieee80211_reset_erp_info(dev);
> >  		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
> > +
> > +		// make sure no association start before we got 
> a new BSSID
> > +		ifsta->flags &= ~IEEE80211_STA_BSSID_SET;
> 
> I don't think that patch makes sense, after all, userspace 
> could request to disassociate and afterwards re-request to 
> associate by setting the SSID and not setting the BSSID 
> again, which would lose the fixed BSSID without userspace interaction.
> 
> However, I'm not sure how to fix this.
> 

Ok, I had that in mind but could not see how to solve that.

The root problem is that the drive start associate when any of the
ieee80211_ioctl_siwgenie()
ieee80211_ioctl_siwessid() and ieee80211_ioctl_siwap() is called.
If the wpa_supplicant need call more than one of them the association start
to early.

I can see two ways to solve this:
1) Add an argument/flag to the ioctls above indicating if association should
start.
2) Add a new ioctrl that initiate the association.

My patch above relies on that the wpa_supplicant always end the AP setup
with a ieee80211_ioctl_siwap().

/Lars



