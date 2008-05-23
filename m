Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28447 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbYEWRqI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 13:46:08 -0400
Subject: Re: [PATCH] mac80211 : Fixes the status message for iwconfig
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Reply-To: abhijeet.kolekar@intel.com
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1211564362.31559.45.camel@localhost.localdomain>
References: <1211562926905-git-send-email-abhijeet.kolekar@intel.com>
	 <1211564362.31559.45.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 23 May 2008 10:44:00 -0700
Message-Id: <1211564640.15162.1.camel@abhi-desktop> (sfid-20080523_194613_523948_37BBC048)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-23-05 at 13:39 -0400, Dan Williams wrote:
> On Fri, 2008-05-23 at 10:15 -0700, Abhijeet Kolekar wrote:
> > iwconfig was showing incorrect status messages when disassociated.
> > Patch fixes this by always checking for association status in 
> > ioctl calls for getting ap address.
> > 
> > Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> 
> I may not remember correctly, but I think you need to also report the
> BSSID being associated with during assoc & auth stages with WEXT.  So
> the right check here is to return nothing if _disassocated_, but
> otherwise return the BSSID that's currently pending or associated with. 
> 
> Dan
One question though, Do we need to report similar things with essid or
WEXT will always return the essid regardless of the state.
> 
> > ---
> >  net/mac80211/wext.c |   11 ++++++++---
> >  1 files changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> > index c2e2378..1a35562 100644
> > --- a/net/mac80211/wext.c
> > +++ b/net/mac80211/wext.c
> > @@ -501,9 +501,14 @@ static int ieee80211_ioctl_giwap(struct net_device *dev,
> >  	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> >  	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
> >  	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
> > -		ap_addr->sa_family = ARPHRD_ETHER;
> > -		memcpy(&ap_addr->sa_data, sdata->u.sta.bssid, ETH_ALEN);
> > -		return 0;
> > +		if (sdata->u.sta.state == IEEE80211_ASSOCIATED) {
> > +			ap_addr->sa_family = ARPHRD_ETHER;
> > +			memcpy(&ap_addr->sa_data, sdata->u.sta.bssid, ETH_ALEN);
> > +			return 0;
> > +		} else {
> > +			memset(&ap_addr->sa_data, 0, ETH_ALEN);
> > +			return 0;
> > +		}
> >  	} else if (sdata->vif.type == IEEE80211_IF_TYPE_WDS) {
> >  		ap_addr->sa_family = ARPHRD_ETHER;
> >  		memcpy(&ap_addr->sa_data, sdata->u.wds.remote_addr, ETH_ALEN);
> 
