Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1DTII5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 04:08:57 -0400
Subject: Re: [PATCH 1/2] mac80211: allow low level drivers to report packet
 loss
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <BANLkTik81g3NOwHcQk2eqOcMjaubCLdk+w@mail.gmail.com>
References: <1303125749-31967-1-git-send-email-arik@wizery.com>
	 <1303129610.3588.7.camel@jlt3.sipsolutions.net>
	 <BANLkTikc9wrZ__8URZ3ASQ6F=rUHix2iGA@mail.gmail.com>
	 <1303216566.3603.6.camel@jlt3.sipsolutions.net>
	 <BANLkTik81g3NOwHcQk2eqOcMjaubCLdk+w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 10:08:53 +0200
Message-ID: <1303286933.3619.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-04-20 at 00:54 +0300, Arik Nemtsov wrote:

> > That's your choice, but I wouldn't do it. You'll have to support TX
> > status when requested, otherwise AP operation won't work, so you need
> > the code anyway.
> 
> Can you elaborate why?
> 
> I'm assuming you mean the removal of
> IEEE80211_HW_REPORTS_TX_ACK_STATUS (in the second patch of this
> series). Note that it was only added recently, and AP/STA modes seemed
> to work fine without it.
> From a look in the code it seems this flag helps with connection
> monitoring in STA mode. The other use is determining the current PS
> mode when IEEE80211_HW_PS_NULLFUNC_STACK is enabled. These two are
> done by HW in wl12xx cards.

Well, there's the flag saying "you can rely on it", but there's also the
fact that AP mode relies on status for (some) frames anyway. So if you
just want to remove the flag I guess that's OK, but if you want to
remove all status processing .. that'll cause issues with AP mode.

johannes

