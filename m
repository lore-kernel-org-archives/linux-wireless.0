Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:7033 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbYGIPtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 11:49:41 -0400
Received: by yx-out-2324.google.com with SMTP id 8so849094yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 08:49:41 -0700 (PDT)
Subject: Re: [PATCH 2/3] mac80211: use ieee80211 frame control directly
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1215589460.3670.30.camel@johannes.berg>
References: <1215568845.476.67.camel@brick>
	 (sfid-20080709_040049_850302_67F9F0D2)  <1215589460.3670.30.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 08:49:31 -0700
Message-Id: <1215618572.476.70.camel@brick> (sfid-20080709_174944_936581_C93C4EBC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-09 at 09:44 +0200, Johannes Berg wrote:
> > --- a/net/mac80211/wep.c
> > +++ b/net/mac80211/wep.c
> > @@ -291,9 +291,10 @@ u8 * ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key)
> >  ieee80211_rx_result
> >  ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
> >  {
> > -	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
> > -	    ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
> > -	     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH))
> > +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
> > +
> > +	if (ieee80211_is_data(hdr->frame_control) &&
> > +	    ieee80211_is_auth(hdr->frame_control))
> >  		return RX_CONTINUE;
> 
> That one seems impossible to hit now and should be !is_data && !is_auth
> I think.

Yep.  I'll have another look over this to see if I made any others.

Harvey

