Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17742 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab0CVGCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 02:02:49 -0400
Subject: Re: [RFC PATCHv5 2/2] mac80211: Add support for connection quality
 monitoring
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho Luciano (Nokia-D/Helsinki)" <Luciano.Coelho@nokia.com>
In-Reply-To: <1269103848.4652.6.camel@jlt3.sipsolutions.net>
References: <1268985801-25225-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268985801-25225-3-git-send-email-juuso.oikarinen@nokia.com>
	 <1269103848.4652.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 07:59:33 +0200
Message-ID: <1269237573.10120.737.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-03-20 at 17:50 +0100, ext Johannes Berg wrote:
> On Fri, 2010-03-19 at 10:03 +0200, Juuso Oikarinen wrote:
> 
> > + * @IEEE80211_HW_SUPPORTS_CQM:
> > + *	Hardware can do connection quality monitoring - i.e. it can monitor
> > + *	connection quality related parameters, such as the RSSI level and
> > + *	provide notifications if configured trigger levels are reached.
> 
> It doesn't really matter at this point, before we have any other CQM
> data point implementations, but I would expect this to be CQM_RSSI,
> CQM_BEACON_LOSS etc. in different flags eventually since not all might
> be supported and one might want to allow some w/o the others?

I agree. I will change this.

> > +static int ieee80211_set_cqm_config(struct wiphy *wiphy,
> > +				    struct net_device *dev,
> > +				    s32 rssi_thold, u8 rssi_hyst)
> > +{
> > +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> > +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> > +	struct ieee80211_vif *vif = &sdata->vif;
> > +	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
> > +
> > +	if (vif->type != NL80211_IFTYPE_STATION)
> > +		return -EOPNOTSUPP;
> 
> I think this check should probably be in cfg80211, it really doesn't
> make sense in any other mode.

Agreed.

> I'm sorry for making you go through iterations over and over again!

Really, no problem. It's also in my/our benefit the best possible code
out. Thanks for your time!

-Juuso

> johannes
> 


