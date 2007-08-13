Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53391 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S947760AbXHMPMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 11:12:55 -0400
Subject: Re: [PATCHv2] mac80211: dynamic wep
From: Volker Braun <volker.braun@physik.hu-berlin.de>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>
In-Reply-To: <200708130054.57899.flamingice@sourmilk.net>
References: <pan.2007.08.10.23.31.32@physik.hu-berlin.de>
	 <200708130054.57899.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 11:12:50 -0400
Message-Id: <1187017970.14416.23.camel@carrot.hep.upenn.edu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I completely missed that privacy==confidentiality and includes all
encryption schemes, thanks. 

On Mon, 2007-08-13 at 00:54 -0700, Michael Wu wrote:
> > -			if (keyidx >= 0 && keyidx < NUM_DEFAULT_KEYS &&
> > -			    (!rx->sta || !rx->sta->key || keyidx > 0))
> > -				rx->key = rx->sdata->keys[keyidx];
> So it looks like the keyidx > 0 check here is the source of the RX problems. I 
> think we can store the keyidx of the individual key to compare against 
> instead of assuming all individual keys have a keyidx of 0.

Correct me if I'm wrong, but I'm reading the standard like this: For WEP
keys one can have up to 4 default keys (rx->sdata->keys[keyidx]), and a
varying number (but at least 10) per-STA keys (rx->sta->key). On
receiving a unicast packet, you use the per-STA key if available (and
discard keyidx). Only if there is no per-STA key, or the packet is
multicast, you use the keyidx-th default key. 

So you cannot rely on keyidx and you must have a check for unicast vs.
multicast somewhere.

Volker

