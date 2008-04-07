Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:3837 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757685AbYDGOnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 10:43:07 -0400
Received: by mu-out-0910.google.com with SMTP id i10so2086968mue.5
        for <linux-wireless@vger.kernel.org>; Mon, 07 Apr 2008 07:43:02 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 hardware encryption
Date: Mon, 7 Apr 2008 16:45:43 +0200
Cc: linux-wireless@vger.kernel.org
References: <200804051931.58895.IvDoorn@gmail.com> <200804071626.37799.IvDoorn@gmail.com> <1207578963.12481.27.camel@johannes.berg>
In-Reply-To: <1207578963.12481.27.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804071645.43604.IvDoorn@gmail.com> (sfid-20080407_155326_202480_CDBA3079)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 April 2008, Johannes Berg wrote:
> 
> > Ok, so just to summarize (so I have everything right :) )
> > 
> > TX path)
> > rt2x00 sets the IEEE80211_KEY_FLAG_GENERATE_IV flag
> > grabs the IV/EIV from behind the ieee80211 header
> > memmove ieee80211 header to remove the IV/EIV
> > 
> > TX done path)
> > memmove ieee80211 header to make room for IV/EIV
> > reinsert IV/EIV behind ieee80211 header
> > call ieee80211_tx_status() for mac80211
> > 
> > RX path)
> > memmove ieee80211 header to make room for IV/EIV
> > insert IV/EIV behind ieee80211 header
> > call ieee80211_rx() for mac80211
> 
> Yes, that looks right.

Excellent, thanks. :)

Ivo
