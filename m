Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60870 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab1HJRvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 13:51:02 -0400
Received: by fxh19 with SMTP id 19so1104745fxh.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 10:51:00 -0700 (PDT)
Subject: Re: [PATCH 2/4] cfg80211: Add cfg80211_get_bss_ht to also match HT
 configuration
From: Alexander Simon <alexander.simon@saxnet.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312992332.4325.22.camel@jlt3.sipsolutions.net>
References: <1888623.Vt5VZUN2cU@alex-1>  <8106144.ZkUl7u1lz4@alex-1>
	 (sfid-20110808_140459_252308_3B0F09A2)  <1312984428.4325.10.camel@jlt3.sipsolutions.net>
	 <1312991321.3128.34.camel@alex-2>
	 (sfid-20110810_174931_439213_A3C417AC)  <1312992332.4325.22.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 19:50:57 +0200
Message-ID: <1312998657.3128.45.camel@alex-2> (sfid-20110810_195107_180303_39A6176E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, den 10.08.2011, 18:05 +0200 schrieb Johannes Berg:
> On Wed, 2011-08-10 at 17:48 +0200, Alexander Simon wrote:
> > Am Mittwoch, den 10.08.2011, 15:53 +0200 schrieb Johannes Berg:
> > > On Mon, 2011-08-08 at 14:04 +0200, Alexander Simon wrote:
> > > 
> > > > +struct cfg80211_bss *cfg80211_get_bss_ht(struct wiphy *wiphy,
> > > > +					  struct ieee80211_channel *channel,
> > > > +					  const u8 *bssid,
> > > > +					  const u8 *ssid, size_t ssid_len,
> > > > +					  u16 capa_mask, u16 capa_val,
> > > > +				       enum nl80211_channel_type channel_type);
> > > 
> > > indentation? Also, you really need kernel-doc for this.
> > Pardon me, but I don't know what you mean... I just browsed
> > Documentation/networking. Could you point me the exact file, please?
> 
> Documentation/kernel-doc-nano-HOWTO.txt maybe?
Uh, okay...
I thought as there is no documentation for cfg80211_get_bss, there was
no need to document the _ht version...

The problem I'm facing here is that I really *need* to check the HT mode
_inside_ the loop. Hence i need a _ht version.
OR I could change cfg80211_get_bss only, causing to add the new
parameters in *all* calls of cfg80211_get_bss... Whatever you prefer.

To conclude this:
* I'll write a _ht version that has a check_ht bool
* if (check_ht == 1), match channel_type parameter
* _ht version calls non-ht with check_ht = 0
* documentation for _ht (for non-ht also???)

Indentation will be fixed, of course.

Alex


