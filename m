Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54360 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab1HJPtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 11:49:02 -0400
Received: by eyx24 with SMTP id 24so898330eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 08:49:00 -0700 (PDT)
Subject: Re: [PATCH 2/4] cfg80211: Add cfg80211_get_bss_ht to also match HT
 configuration
From: Alexander Simon <alexander.simon@saxnet.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312984428.4325.10.camel@jlt3.sipsolutions.net>
References: <1888623.Vt5VZUN2cU@alex-1>  <8106144.ZkUl7u1lz4@alex-1>
	 (sfid-20110808_140459_252308_3B0F09A2)  <1312984428.4325.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 17:48:41 +0200
Message-ID: <1312991321.3128.34.camel@alex-2> (sfid-20110810_174910_272073_1D1E1ABD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, den 10.08.2011, 15:53 +0200 schrieb Johannes Berg:
> On Mon, 2011-08-08 at 14:04 +0200, Alexander Simon wrote:
> 
> > +struct cfg80211_bss *cfg80211_get_bss_ht(struct wiphy *wiphy,
> > +					  struct ieee80211_channel *channel,
> > +					  const u8 *bssid,
> > +					  const u8 *ssid, size_t ssid_len,
> > +					  u16 capa_mask, u16 capa_val,
> > +				       enum nl80211_channel_type channel_type);
> 
> indentation? Also, you really need kernel-doc for this.
Pardon me, but I don't know what you mean... I just browsed
Documentation/networking. Could you point me the exact file, please?
> 
> > +++ b/net/wireless/chan.c
> > @@ -75,6 +75,7 @@ bool can_beacon_sec_chan(struct wiphy *wiphy,
> >  
> >  	return true;
> >  }
> > +EXPORT_SYMBOL(can_beacon_sec_chan);
> 
> You've got to be kidding, if you export it you really need to give it a
> decent name. Besides, you don't have to export it in this patch.
I intended to export this instead of writing ieee80211_can_use_ext_chan
first.
Ok, to summarize this: I should use this instead of my own
ieee80211_can_use_ext_chan in mac80211 (as in your reply in 4/4), but
when I export this I need to rename it. Does cfg80211_can_use_ext_chan
sound well?
> 
> >  int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
> >  		      struct wireless_dev *wdev, int freq,
> > diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> > index 2936cb8..ff5b736 100644
> > --- a/net/wireless/scan.c
> > +++ b/net/wireless/scan.c
> > @@ -364,6 +364,19 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy
> > *wiphy,
> >  				      const u8 *ssid, size_t ssid_len,
> >  				      u16 capa_mask, u16 capa_val)
> >  {
> > +	/* call HT version with no HT requirements */
> > +	return cfg80211_get_bss_ht(wiphy, channel, bssid, ssid, ssid_len,
> > +				   capa_mask, capa_val, NL80211_CHAN_NO_HT);
> > +}
> > +EXPORT_SYMBOL(cfg80211_get_bss);
> 
> I don't like the semantics of this. Why is NO_HT indicating "don't care
> about HT"? How then do you really find a NO_HT BSS?
> 
> Also, this raises a more fundamental question -- didn't you earlier say
> you wanted to be able to connect with any IBSS, even non-HT ones, but
> now it must match?
This is only used for fixed channel mode. As we would only join a
matching HT mode, I have to pass it here.
How about second parameter, "bool match_ht"?
> 
> johannes
> 


