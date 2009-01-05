Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16426 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbZAEREg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 12:04:36 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2009 09:04:35 -0800
Date: Mon, 5 Jan 2009 09:04:32 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Joseph Cheek <joseph@cheek.com>, <stable@kernel.org>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] 2.6.2{7, 8} with compat-wireless-2008-12-3{0, 1)
	drops link every 2-3 minutes
Message-ID: <20090105170432.GA6834@tesla> (sfid-20090105_180455_132887_77A7D054)
References: <495C7640.8060806@cheek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <495C7640.8060806@cheek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 31, 2008 at 11:52:32PM -0800, Joseph Cheek wrote:
> Hi all,
> 
> Happy New Year!  It's about 2:30 AM here and I'm up debugging my shiny
> new DWA-552 <AR5416+AR2133> XtremeN Desktop Adapter.  Stock 2.6.28 gave
> me the dreaded "No ProbeResp from current AP" in syslog with a
> disconnect every few minutes, even after updating
> |IEEE80211_MONITORING_INTERVAL to (100 * HZ).  It's highly annoying.

This should be due to the fact that the RX filter disabled beaconing from
the current AP and mac80211 expects beacons from the AP. This was fixed
in wireless-testing but I do not see this pushed out for 2.6.28.

Greg, this was fixed in Linus' tree via ffb826767bffda61426d964a8fc24a216a14b0bd,
merged by John on Fri, 21 Nov 2008, the patch is titled:
"ath9k: enable RXing of beacons on STA/IBSS". Just in case I've
provided the hunk below. Without this patch users will face this disconnect
issue on noisy environments where the beacons don't reach mac80211 within
a certain time frame dicated by mac80211.

> I thought compat-wireless might help.

It should resolve the "No ProbeResp from current AP" in" issue at least.

> It seems to do a little bit better
> but that's subjective.  I still get a disconnect every few minutes.
> iwconfig and my DIR-655 show plenty of signal strength but it doesn't
> respond to pings and my ssh sessions all get stuck in limbo.
> 
> What can I do to debug this?  This is an old Athlon XP 2000+ box running
> Gentoo (if it helps).  I've seen a few other probs on this list recently
> but they don't seem similar to mine enough to warrant tacking this msg
> on to an existing thread.

That may be due to a separate issue, but to review that we need more information,
such as the type of AP you are connecting to, encryption options used, mode
of operation (11n, 11b or 11a), your type of environment (noisy or a quiet home).
To review this issue you can remove stable@kernel.org from the To or Cc list.

  Luis

--- drivers/net/wireless/ath9k/recv.c.orig	2009-01-05 08:44:45.000000000 -0800
+++ drivers/net/wireless/ath9k/recv.c	2009-01-05 08:46:40.000000000 -0800
@@ -627,9 +627,8 @@
 		rfilt &= ~ATH9K_RX_FILTER_UCAST;
 	}
 
-	if (((sc->sc_ah->ah_opmode == ATH9K_M_STA) &&
-	     (sc->rx_filter & FIF_BCN_PRBRESP_PROMISC)) ||
-	    (sc->sc_ah->ah_opmode == ATH9K_M_IBSS))
+	if (sc->sc_ah->ah_opmode == ATH9K_M_STA ||
+	    sc->sc_ah->ah_opmode == ATH9K_M_IBSS)
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
 	/* If in HOSTAP mode, want to enable reception of PSPOLL frames
