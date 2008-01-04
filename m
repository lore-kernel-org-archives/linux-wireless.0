Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:51930 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbYADHn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2008 02:43:58 -0500
Date: Fri, 4 Jan 2008 02:21:05 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	bruno randolf <bruno@thinktube.com>,
	Andrew Lutomirski <luto@myrealbox.com>
Subject: [PATCH] ath5k: Fix frame duration oops
Message-ID: <20080104072105.GC28995@ruslug.rutgers.edu> (sfid-20080104_074403_728048_437257B8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes an oops which was introduced as a regression by 
commit fd640775bd16e1df50c867cc547af0, on the patch titled,
"mac80211: dont use interface indices in drivers".

ieee80211_generic_frame_duration() now relies on sdata->flags which
itself gets set upon bringing the interface up. We check for the
virtual interface now before setting the rate duration registers.

After the mode changes are introduced onto mac80211 we should revisit
these changes.

This patch was tested on the following cards:

1) BG card:

Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
RF2112A 2GHz radio found (0x46)

2) ABG card:

Atheros AR5213A chip found (MAC: 0x59,PHY: 0x43)
RF5112A multiband radio found (0x36)

Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

--- a/drivers/net/wireless/ath5k/hw.c	2008-01-04 02:04:20.000000000 -0500
+++ b/drivers/net/wireless/ath5k/hw.c	2008-01-04 01:58:12.000000000 -0500
@@ -734,8 +734,12 @@
 		if (ret)
 			return ret;
 
-		/* Write rate duration table */
-		if (ah->ah_version == AR5K_AR5212)
+		/* Write rate duration table only on AR5212 and if 
+		 * virtual interface has already been brought up
+		 * XXX: rethink this after new mode changes to
+		 * mac80211 are integrated */
+		if (ah->ah_version == AR5K_AR5212 &&
+			ah->ah_sc->vif != NULL)
 			ath5k_hw_write_rate_duration(ah, driver_mode);
 
 		/*
