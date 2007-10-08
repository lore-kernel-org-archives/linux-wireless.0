Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:42881 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbXJHUw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 16:52:28 -0400
Received: by ug-out-1314.google.com with SMTP id z38so838824ugc
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2007 13:52:26 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] Mode selection in mac80211
Date: Mon, 8 Oct 2007 23:08:38 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Adam Baker <linux@baker-net.org.uk>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
References: <200710052319.10600.linux@baker-net.org.uk> <1191837339.4063.25.camel@johannes.berg>
In-Reply-To: <1191837339.4063.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710082308.38260.IvDoorn@gmail.com> (sfid-20071008_215234_002961_BA2A6254)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Is it intended that the order of calling ieee80211_register_hwmode should 
> > determine which mode should be preferred when multiple modes exist on the 
> > same channel or is there either already or planned a better option for driver 
> > writers? If calling order should determine preference should it be first or 
> > last registered?
> 
> That's actually a can of worms. Luis is working (I hope) on resolving
> these issues with mode vs. frequency selection. However, I'm not
> entirely convinced that mode selection should be done by userspace when
> we are acting as a client. I think we should simply exploit hardware
> capabilities as much as possible and then use the set that the AP
> advertised (or rather as much as we can support of that).
> 
> Hence, for these questions it'd be good to know whether the ralink
> drivers do anything different based on the selected mode, and if they do
> (I assume they do because they register B *and* G modes) what it is.

The only difference currently in rt2x00 is for rt2500usb. The initialization
of the IFS and EIFS register is different.
I haven't gone through the legacy driver to see if there aren't any further
changes. But since I believe I have extracted all register initializations
that meant something from the legacy driver, this small difference can
probably be considered as the only thing.

> It'd probably help a lot with the design of the interface if you could
> answer that. I feel that mode selection should not be necessary since in
> G mode a device needs to have the capability to talk to B-only stations
> and hence must be able to "fall back" to B mode, we should therefore be
> able to exploit that capability without the driver ever registering
> different modes.

And is mac80211 doing that correctly at this time?
If so I could drop the 802.11B mode registration if that is the preferred action.

> In fact, I think that the driver can probably simply register the
> modulations/bitrates it can support orthogonally to the frequencies it
> supports, and the frequencies consist of only information about the
> frequency and possibly hardware value used to select it. This was part
> of what I posted a while ago when Luis was posting his regulatory stuff,
> and I think should be addressed while cleaning up that whole mess.

Only registering the supported rates and channels and let mac80211 sort
out the modes itself does sound like a good idea. :)

Ivo
