Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:59052 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab0KZNSn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 08:18:43 -0500
Subject: Re: [PATCH] wl12xx: disable 11a channels when regulatory changes
 if 11a is not supported
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
In-Reply-To: <1290777257.3531.22.camel@jlt3.sipsolutions.net>
References: <1290775390-3391-1-git-send-email-luciano.coelho@nokia.com>
	 <1290777257.3531.22.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 15:18:12 +0200
Message-ID: <1290777492.15341.13.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-26 at 14:14 +0100, ext Johannes Berg wrote:
> On Fri, 2010-11-26 at 14:43 +0200, luciano.coelho@nokia.com wrote:
> > From: Luciano Coelho <luciano.coelho@nokia.com>
> > 
> > Instead of simply not scanning for the 11a channels when not supported by the
> > hardware, disable the channels in reg_notify.  This centralizes the decision
> > on whether to scan 5GHz channel in one place and allows userspace to know
> > exactly which channels are in use.
> 
> Why are you advertising them to start with though?

Because the driver support chips with and without 11a (namely wl1273 and
wl1271).  When we register the channels with mac80211, we don't know
whether the chip supports 11a or not, so we need to decide at runtime.

-- 
Cheers,
Luca.

