Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbYDWQfA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 12:35:00 -0400
Subject: RE: Roaming problems
From: Dan Williams <dcbw@redhat.com>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: "'Johannes Berg'" <johannes@sipsolutions.net>,
	hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
In-Reply-To: <004201c8a55e$f4668f10$0b3ca8c0@gotws1589>
References: <004201c8a55e$f4668f10$0b3ca8c0@gotws1589>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 12:31:14 -0400
Message-Id: <1208968274.24395.10.camel@localhost.localdomain> (sfid-20080423_183539_371746_15F1FCD9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-23 at 18:27 +0200, Lars Ericsson wrote:
> > > The below patch makes sure that we drop the BSSID when we 
> > disassociate.
> > 
> > > --- a/ieee80211_sta.c	Wed Apr 23 10:14:30 2008
> > > +++ b/ieee80211_sta.c	Wed Apr 23 08:41:23 2008
> > > @@ -479,6 +479,9 @@ static void ieee80211_set_associated(str
> > >  		netif_carrier_off(dev);
> > >  		ieee80211_reset_erp_info(dev);
> > >  		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
> > > +
> > > +		// make sure no association start before we got 
> > a new BSSID
> > > +		ifsta->flags &= ~IEEE80211_STA_BSSID_SET;
> > 
> > I don't think that patch makes sense, after all, userspace 
> > could request to disassociate and afterwards re-request to 
> > associate by setting the SSID and not setting the BSSID 
> > again, which would lose the fixed BSSID without userspace interaction.
> > 
> > However, I'm not sure how to fix this.
> > 
> 
> Ok, I had that in mind but could not see how to solve that.
> 
> The root problem is that the drive start associate when any of the
> ieee80211_ioctl_siwgenie()
> ieee80211_ioctl_siwessid() and ieee80211_ioctl_siwap() is called.
> If the wpa_supplicant need call more than one of them the association start
> to early.

When either SIWESSID or SIWAP is called, the driver should restart
association using the latest settings sent by the supplicant.  So by the
end of the GENIE -> SSID -> BSSID call chain, the driver should have
everything it needs to associate, and should restart association with
those parameters.

Dan


