Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:52838 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab0CRFZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 01:25:10 -0400
Subject: Re: [RFC PATCHv3 2/2] mac80211: Add support for connection quality
 monitoring
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1268842758.5989.17.camel@jlt3.sipsolutions.net>
References: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268830877-5162-3-git-send-email-juuso.oikarinen@nokia.com>
	 <1268842758.5989.17.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 07:21:41 +0200
Message-ID: <1268889701.10120.662.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-17 at 17:19 +0100, ext Johannes Berg wrote:
> On Wed, 2010-03-17 at 15:01 +0200, Juuso Oikarinen wrote:
> 
> > --- a/include/net/mac80211.h
> > +++ b/include/net/mac80211.h
> > @@ -599,6 +599,7 @@ enum ieee80211_conf_flags {
> >   * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
> >   * @IEEE80211_CONF_CHANGE_IDLE: Idle flag changed
> >   * @IEEE80211_CONF_CHANGE_SMPS: Spatial multiplexing powersave mode changed
> > + * @IEEE80211_CONF_CHANGE_CQM: Connection quality monitor config changed
> >   */
> >  enum ieee80211_conf_changed {
> >  	IEEE80211_CONF_CHANGE_SMPS		= BIT(1),
> > @@ -609,6 +610,7 @@ enum ieee80211_conf_changed {
> >  	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
> >  	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
> >  	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
> > +	IEEE80211_CONF_CHANGE_CQM		= BIT(9),
> >  };
> >  
> >  /**
> > @@ -662,6 +664,9 @@ enum ieee80211_smps_mode {
> >   *    frame, called "dot11ShortRetryLimit" in 802.11, but actually means the
> >   *    number of transmissions not the number of retries
> >   *
> > + * @cqm_rssi_thold: Connection quality monitor RSSI threshold
> > + * @cqm_rssi_hyst: Connection quality monitor RSSI hysteresis
> > + *
> >   * @smps_mode: spatial multiplexing powersave mode; note that
> >   *	%IEEE80211_SMPS_STATIC is used when the device is not
> >   *	configured for an HT channel
> > @@ -676,6 +681,9 @@ struct ieee80211_conf {
> >  
> >  	u8 long_frame_max_tx_count, short_frame_max_tx_count;
> >  
> > +	s32 cqm_rssi_thold;
> > +	u8 cqm_rssi_hyst;
> 
> You probably don't care all that much, but I have a feeling this should
> be part of the per-BSS data not the global configuration data, since
> especially when we do it in software we could have to deal with multiple
> virtual interfaces.

Good point, for the wl12x1 it doesn't matter so much as they can only
support one virtual interface. I'll change this.

-Juuso

> 
> johannes
> 


