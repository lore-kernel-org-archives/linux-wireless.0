Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:51875 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbYBDCwP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 21:52:15 -0500
Date: Sun, 3 Feb 2008 21:52:10 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com, bruno@thinktube.com,
	johannes@sipsolutions.net
Subject: [PATCH 3/7] ath5k: ath5k_copy_channels() was not setting the channel band
Message-ID: <72cda55b47179991ac0765a1ddcea6be06de4a8b.1202092325.git.mcgrof@winlab.rutgers.edu> (sfid-20080204_025218_942316_4B986AD3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <67abed819770e9d38c69f0e015e153427b3522be.1202092325.git.mcgrof@winlab.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k_copy_channels() wasn't setting the channel's band so all
driver channels had a 2GHz band set. Lets set this.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
---
 drivers/net/wireless/ath5k/base.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index d08fd65..f27554f 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -899,6 +899,8 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 
 		/* Write channel info and increment counter */
 		channels[count].center_freq = freq;
+		channels[count].band = (chfreq == CHANNEL_2GHZ) ?
+			IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 		switch (mode) {
 		case AR5K_MODE_11A:
 		case AR5K_MODE_11G:
-- 
1.5.3.7

