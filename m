Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37015 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab2FTRjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 13:39:44 -0400
Message-ID: <1340213979.4655.78.camel@jlt3.sipsolutions.net> (sfid-20120620_193953_586635_4C74EBBA)
Subject: Re: [PATCH v2 5/7] nl80211/cfg80211: add ap channel switch
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Wed, 20 Jun 2012 19:39:39 +0200
In-Reply-To: <CAK80WHYpxpPftCcO0+Uv4meZOg7h5Ys1GfJFg2SQDf3AiiJMNg@mail.gmail.com>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	 <1340111463-4554-5-git-send-email-victorg@ti.com>
	 <1340182072.4655.41.camel@jlt3.sipsolutions.net>
	 <CAK80WHYpxpPftCcO0+Uv4meZOg7h5Ys1GfJFg2SQDf3AiiJMNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 20:17 +0300, Goldenshtein, Victor wrote:

> >>   * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.
> >> + * @NL80211_FEATURE_AP_CH_SWITCH: This driver supports AP channel switch.
> >
> > what point is there in separating these flags?
> >
> 
> One may support AP channel switch without DFS support, i.e. switching
> to non DFS channels.

Oh, right, makes sense, though I'd enforce that DFS must support
chanswitch?

> >
> >> +     int     (*ap_channel_switch)(struct wiphy *wiphy, struct net_device *dev,
> >> +                                  u32 count, bool block_tx,
> >> +                                  bool post_switch_block_tx,
> >> +                                  struct ieee80211_channel *new_ch);
> >
> > If mac80211 needs a struct, why not have one here already rather than
> > all the parameters?
> >
> 
> OK, it I will just require additional mac patch before current one, I
> will split the "mac80211: add ap channel switch command/event".

Well, you'll have to move the struct definition into cfg80211 and into
this patch I think.

johannes

