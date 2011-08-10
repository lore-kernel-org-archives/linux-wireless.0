Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab1HJQFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 12:05:34 -0400
Subject: Re: [PATCH 2/4] cfg80211: Add cfg80211_get_bss_ht to also match HT
 configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312991321.3128.34.camel@alex-2> (sfid-20110810_174931_439213_A3C417AC)
References: <1888623.Vt5VZUN2cU@alex-1>  <8106144.ZkUl7u1lz4@alex-1>
	 (sfid-20110808_140459_252308_3B0F09A2)  <1312984428.4325.10.camel@jlt3.sipsolutions.net>
	 <1312991321.3128.34.camel@alex-2> (sfid-20110810_174931_439213_A3C417AC)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 18:05:32 +0200
Message-ID: <1312992332.4325.22.camel@jlt3.sipsolutions.net> (sfid-20110810_180537_764772_B0C7E614)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-10 at 17:48 +0200, Alexander Simon wrote:
> Am Mittwoch, den 10.08.2011, 15:53 +0200 schrieb Johannes Berg:
> > On Mon, 2011-08-08 at 14:04 +0200, Alexander Simon wrote:
> > 
> > > +struct cfg80211_bss *cfg80211_get_bss_ht(struct wiphy *wiphy,
> > > +					  struct ieee80211_channel *channel,
> > > +					  const u8 *bssid,
> > > +					  const u8 *ssid, size_t ssid_len,
> > > +					  u16 capa_mask, u16 capa_val,
> > > +				       enum nl80211_channel_type channel_type);
> > 
> > indentation? Also, you really need kernel-doc for this.
> Pardon me, but I don't know what you mean... I just browsed
> Documentation/networking. Could you point me the exact file, please?

Documentation/kernel-doc-nano-HOWTO.txt maybe?

> > You've got to be kidding, if you export it you really need to give it a
> > decent name. Besides, you don't have to export it in this patch.
> I intended to export this instead of writing ieee80211_can_use_ext_chan
> first.
> Ok, to summarize this: I should use this instead of my own
> ieee80211_can_use_ext_chan in mac80211 (as in your reply in 4/4), but
> when I export this I need to rename it. Does cfg80211_can_use_ext_chan
> sound well?

Ok but then I guess you forgot to remove the export? Yeah, please rename
it and export it for mac80211, that seems fine.

> > I don't like the semantics of this. Why is NO_HT indicating "don't care
> > about HT"? How then do you really find a NO_HT BSS?
> > 
> > Also, this raises a more fundamental question -- didn't you earlier say
> > you wanted to be able to connect with any IBSS, even non-HT ones, but
> > now it must match?
> This is only used for fixed channel mode. As we would only join a
> matching HT mode, I have to pass it here.
> How about second parameter, "bool match_ht"?

Ahh, ok, that explains it, sorry for the confusion.

johannes

