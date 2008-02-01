Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:54242 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbYBAB0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 20:26:33 -0500
Date: Thu, 31 Jan 2008 20:26:28 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	bruno@thinktube.com, jirislaby@gmail.com,
	johannes@sipsolutions.net, mickflemm@gmail.com
Subject: [PATCH 2/2] ath5k: ath5k_copy_channels() was not setting the channel band
Message-ID: <20080201012628.GE28995@ruslug.rutgers.edu> (sfid-20080201_012635_236231_0E861094)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k_copy_channels() wasn't setting the channel's band so all
driver channels had a 2GHz band set. Lets set this.

Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

drivers/net/wireless/ath5k/base.c:	Changes-licensed-under: 3-Clause-BSD
---
 drivers/net/wireless/ath5k/base.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index bd9c9a8..1e7eeec 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -899,6 +899,8 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 
 		/* Write channel info and increment counter */
 		channels[count].center_freq = freq;
+		channels[count].band = (chfreq == CHANNEL_2GHZ) ?
+			IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 
 		if ((mode == AR5K_MODE_11A) ||
 			(mode == AR5K_MODE_11G)) {
-- 
1.5.2.5

