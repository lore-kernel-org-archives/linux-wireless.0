Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate05.web.de ([217.72.192.243]:59493 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbZHXUdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 16:33:20 -0400
Date: Mon, 24 Aug 2009 22:33:16 +0200
Message-Id: <1779655662@web.de>
MIME-Version: 1.0
From: Chunkeey@web.de
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Bob Copeland <bcopeland@gmail.com>
Cc: Chr <chunkeey@web.de>, Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: Kernel Panic in __ieee80211_tx with p43usb as AP
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Mon, Aug 24, 2009 at 4:07 PM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
> > static inline int drv_tx(struct ieee80211_local *local, struct sk_buff
> > *skb)
> > {
> >        return local->ops->tx(&local->hw, skb);
> > }
> >
> > Are there any suggest changes that would let me debug this problem
> > without crashing the kernel?
> 
> Could be a callback into mac80211, e.g. ieee80211_get_tx_rate()
> returning null (I haven't looked at any p54 code, I just know I've hit
> one there before with ath5k).

huu. at this point the frame already has a valid rate.
I guessing the dump is missing some more lines and 
it crashes somewhere deep down in the driver.
But, I'm not yet sure where exactly... do you think
you can capture a full oops?

Regards,
   Chr
________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

