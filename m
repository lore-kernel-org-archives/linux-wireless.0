Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42860 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754953AbdC2Iu1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 04:50:27 -0400
Message-ID: <1490777413.7948.14.camel@sipsolutions.net> (sfid-20170329_105119_054586_5F30D06F)
Subject: Re: wlan0 keeps deauthenticating DEAUTH_LEAVING about every minute
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Dennis New <dennisn@dennisn.mooo.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 29 Mar 2017 10:50:13 +0200
In-Reply-To: <260a3f4a-1ee1-62ec-e3db-294510e71a4e@broadcom.com> (sfid-20170329_102018_969097_22371F10)
References: <20170324213237.6f122a9173fa464a5d936f9d@dennisn.mooo.com>
         <1490772890.18052.8.camel@sipsolutions.net>
         <3320e9f4-21c3-966f-df6e-0bc8292a88a0@broadcom.com>
         <1490773593.7948.2.camel@sipsolutions.net>
         <260a3f4a-1ee1-62ec-e3db-294510e71a4e@broadcom.com>
         (sfid-20170329_102018_969097_22371F10)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > This code was designed for regulatory changes, but the WARN_ON()
> > indicates that we got connected on a channel that we think isn't
> > actually usable. We quite possibly should reject that connection
> > there, but it seems to me it should've been rejected elsewhere
> > already...?
> 
> But this is prior to connection, right? This warning happens upon
> authenticate.

Yeah the warning happens in authentication.

> So in nl80211_authenticate() we do:
> 
> chan = nl80211_get_valid_chan(&rdev->wiphy,
> 			      info->attrs[NL80211_ATTR_WIPHY_FREQ]);
> 
> and in cfg80211_mlme_auth():
> 
> req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
> 			   IEEE80211_BSS_TYPE_ESS,
> 			   IEEE80211_PRIVACY_ANY);

That might not be what's going on - the OP said he was getting this
with iw, which doesn't go through nl80211_authenticate() but
nl80211_connect().

> After that the chain is:
> 
> ieee80211_mgd_auth() ->
> 	ieee80211_prep_connection() ->
> 		ieee80211_prep_channel() ->
> 			ieee80211_determine_chantype()

And somehow that determines that even a 20MHz no-HT channel isn't
valid.

johannes
