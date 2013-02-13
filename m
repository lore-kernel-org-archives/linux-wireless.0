Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45646 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab3BMJXw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 04:23:52 -0500
Message-ID: <1360747368.12803.93.camel@cumari.coelho.fi> (sfid-20130213_102402_221339_BE834138)
Subject: Re: [PATCH] cfg80211: check vendor IE length to avoid overrun
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <j@w1.fi>
Date: Wed, 13 Feb 2013 11:22:48 +0200
In-Reply-To: <1360746917.8868.4.camel@jlt4.sipsolutions.net>
References: <1360692698-24208-1-git-send-email-coelho@ti.com>
	 <1360746917.8868.4.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-13 at 10:15 +0100, Johannes Berg wrote:
> On Tue, 2013-02-12 at 20:11 +0200, Luciano Coelho wrote:
> > cfg80211_find_vendor_ie() was checking only that the vendor IE would
> > fit in the remaining IEs buffer.  If a corrupt includes a vendor IE
> > that is too small, we could potentially overrun the IEs buffer.
> > 
> > Fix this by checking that the vendor IE fits in the reported IE length
> > field and skip it otherwise.
> 
> Applied. I changed the BUILD_BUG_ON to be != 1 since it has to be that,
> but if one breaks that ...

Okay.  But it actually needs to be 1 in the cfg80211_find_ie() function,
not here.  Here we just need to make sure that ie->len is guaranteed to
fit in what we got.  cfg80211_find_ie() guarantees that we have at least
2 bytes, thus the >= 2 I used.

Anyway, this is all *extremely* nitpicky already. :P

--
Luca.

