Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53377 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbYKIMAt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 07:00:49 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
Date: Sun, 9 Nov 2008 13:00:26 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <4902DEBB.3050205@hotmail.com> <1226149894.3610.8.camel@johannes.berg> <BAY104-DAV7C39A232BE9A213EB2122991B0@phx.gbl>
In-Reply-To: <BAY104-DAV7C39A232BE9A213EB2122991B0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811091300.26316.mb@bu3sch.de> (sfid-20081109_130120_622787_AF2071F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 09 November 2008 04:06:14 Shaddy Baddah wrote:
> Looking into this, and the underlying problem is again 
> compare_ether_addr(). Now, I'm sure that replacing this with a memcmp() 
> is now treading on more toes than just zd1211rw users. And for this 
> reason, I think a better solution is going to be required.

I think this requires a comment in the code why we do not use
compare_ether_addr() at this place. Something like:

/* We use memcmp() instead of compare_ether_addr(), because the
 * packet might not be 4-byte aligned, yet. This is done later. */

-- 
Greetings Michael.
