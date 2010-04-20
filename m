Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50554 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab0DTIWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 04:22:37 -0400
Subject: Re: mac80211 and asymmetric 802.11n TX/RX
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48BAD814-F653-4CE3-85E0-A9D82EC31D53@cs.washington.edu>
References: <48BAD814-F653-4CE3-85E0-A9D82EC31D53@cs.washington.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 10:22:27 +0200
Message-ID: <1271751747.8954.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> Does anyone know if the 11n standard says that the set of TX rates has
> to be a subset of the set of RX rates? This seems to be enforced now:
> when I set up one node to be 2x1, i.e. transmit 2 streams but only
> able to receive 1, then the mac80211 code only lets it transmit 1
> streams (even with a 2-stream-capable receiver at the other end).

I'm not sure. Reading 7.3.2.56.4 seems to imply that, but I'm not sure
about the "Rx Highest Supported Data Rate" field. Seems like maybe you
could set the "RX MCS bitmask" to more than is supported, limit it by
the highest supported data rate, and then use the bitmask for TX?

> A quick diff to net/mac80211/ht.c that fixes this for equal modulation
> streams is attached; the problem is still there for unequal modulation
> directly below. Before I send it up I wanted to make sure I'm not
> crazy.

Hmm, ok. I interpreted the standard differently here, but your
interpretation actually makes more sense I guess. Anyone who's more
familiar with the standard?

> A second question: my understanding is that if I am a 2x2 node and I
> associate to a 3x3 AP, the same code will mask out the fact that the
> AP can receive 3 streams since I can't transmit 3 streams. Is there a
> way to access this info from the driver if I want it?

Unfortunately not, at this point. We could keep track of it, what would
you need it for?

johannes


