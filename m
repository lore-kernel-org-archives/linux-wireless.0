Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:52859 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab0CRFZY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 01:25:24 -0400
Subject: Re: [RFC PATCHv3 2/2] mac80211: Add support for connection quality
 monitoring
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1268842821.5989.18.camel@jlt3.sipsolutions.net>
References: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268830877-5162-3-git-send-email-juuso.oikarinen@nokia.com>
	 <1268842821.5989.18.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 07:22:04 +0200
Message-ID: <1268889724.10120.663.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-17 at 17:20 +0100, ext Johannes Berg wrote:
> On Wed, 2010-03-17 at 15:01 +0200, Juuso Oikarinen wrote:
> 
> > +void ieee80211_cqm_notify(struct ieee80211_vif *vif,
> > +			  enum nl80211_cqm_state rssi_state)
> > +{
> > +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> > +
> > +	cfg80211_cqm_notify(sdata->dev, rssi_state, GFP_KERNEL);
> > +}
> > +EXPORT_SYMBOL(ieee80211_cqm_notify);
> 
> How do you know GFP_KERNEL is OK? The driver might call this from an
> interrupt? Seems better to me to ask the driver for the allocation flags
> too.

Good point, I'll change this.

-Juuso

> johannes
> 


