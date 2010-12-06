Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33586 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab0LFIdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 03:33:23 -0500
Subject: Re: [PATCH 2/3] nl80211: Export available antennas
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <201012061730.16102.br1@einfach.org>
References: <20101206034529.11462.48097.stgit@localhost6.localdomain6>
	 <20101206034535.11462.70791.stgit@localhost6.localdomain6>
	 <1291623453.3506.1.camel@jlt3.sipsolutions.net>
	 <201012061730.16102.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 09:33:20 +0100
Message-ID: <1291624400.3506.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-12-06 at 17:30 +0900, Bruno Randolf wrote:
> On Mon December 6 2010 17:17:33 Johannes Berg wrote:
> > On Mon, 2010-12-06 at 12:45 +0900, Bruno Randolf wrote:
> > > +		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_AVAIL,
> > > +			    dev->wiphy.available_antennas);
> > 
> > I think you should not advertise this unless it's non-zero, and unless
> > also the set/get callbacks are available.
> 
> I don't. Please check the context of this patch, esp patch 1. of this series.

Ah, indeed, the context overlap was lost on me.

> > Similarly, I think you shouldn't advertise the set/get CMDs when the
> > available antennas aren't set.
> 
> There are no set/get commands for antennas since you preferred putting it into 
> wiphy info.

Oops. Forgot all about that, sorry!

> > Finally, you should check for nl80211 that the given tx/rx masks fall
> > into the available antennas mask.
> 
> Allright, I can do that. Would you prefer to reject the command in this case 
> or just apply the available mask?

I'd reject it, since userspace could have checked whether it was valid.

johannes

