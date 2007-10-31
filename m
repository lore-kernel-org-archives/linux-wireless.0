Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3040 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbXJaRpR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 13:45:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [RFC] ath5k: set rate duration table correctly for non-B channels on ar5212
Date: Wed, 31 Oct 2007 13:44:56 -0400
Message-Id: <1193852696-19589-1-git-send-email-linville@tuxdriver.com> (sfid-20071031_174520_319017_40FA1DB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently we are passing MODE_ATHEROS_TURBO or MODE_ATHEROS_TURBOG to
ath5k_hw_get_rate_table if ah_version is AR5K_AR5212 and the channel
passed to ath5k_hw_reset is not a B channel.  This is a problem if
for no other reason than we are not registering those channels.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
This is untested.  Does this look like the right fix?

Also, just above the change is the comment "For 802.11a/g Turbo/XR mode
(AR5K_MODE_XR here is O.K. for both a/g - OFDM)".  Is this the right
comment?

 drivers/net/wireless/ath5k/hw.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index c8d1fbd..a31443e 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -695,8 +695,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 
 				/* Get rate table for this operation mode */
 				rt = ath5k_hw_get_rate_table(ah,
-				    channel->val & CHANNEL_TURBO ?
-				    MODE_ATHEROS_TURBO : MODE_ATHEROS_TURBOG);
+						MODE_IEEE80211G);
 				if (!rt)
 					return -EINVAL;
 
-- 
1.5.3.3

