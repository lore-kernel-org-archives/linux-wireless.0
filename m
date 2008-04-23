Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757491AbYDWN4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 09:56:55 -0400
Subject: RE: Roaming problems
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lars Ericsson <Lars_Ericsson@telia.com>,
	linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
In-Reply-To: <1208949162.31429.74.camel@johannes.berg>
References: <001101c8a51d$8e5997d0$0b3ca8c0@gotws1589>
	 (sfid-20080423_114948_059414_17607EB2)  <1208949162.31429.74.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 09:53:03 -0400
Message-Id: <1208958783.5656.3.camel@localhost.localdomain> (sfid-20080423_155800_825264_F474CD48)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-23 at 13:12 +0200, Johannes Berg wrote:
> > The below patch makes sure that we drop the BSSID when we disassociate.
> 
> > --- a/ieee80211_sta.c	Wed Apr 23 10:14:30 2008
> > +++ b/ieee80211_sta.c	Wed Apr 23 08:41:23 2008
> > @@ -479,6 +479,9 @@ static void ieee80211_set_associated(str
> >  		netif_carrier_off(dev);
> >  		ieee80211_reset_erp_info(dev);
> >  		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
> > +
> > +		// make sure no association start before we got a new BSSID
> > +		ifsta->flags &= ~IEEE80211_STA_BSSID_SET;
> 
> I don't think that patch makes sense, after all, userspace could request
> to disassociate and afterwards re-request to associate by setting the
> SSID and not setting the BSSID again, which would lose the fixed BSSID
> without userspace interaction.
> 
> However, I'm not sure how to fix this.

Enhance roaming support in wpa_supplicant I'd expect.  If you set the
BSSID explicitly, which wpa_supplicant does, then the driver should not
roam to any other BSSID until userspace sends SIOCSIWAP
00:00:00:00:00:00 or sets whatever the 'disabled' flag is.  Such is
WEXT.

I'm not actually sure why wpa_supplicant sets the BSSID explicitly, but
I also haven't looked into it much.

Dan


