Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:45462 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753469Ab3BNBdY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 20:33:24 -0500
From: Joe Perches <joe@perches.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] brcmsmac: Downgrade d11hdrs_mac80211 error messages to warnings.
Date: Wed, 13 Feb 2013 17:33:20 -0800
Message-Id: <d9d111bab5b3186e858c9e85849a2ec61a7451f3.1360805256.git.joe@perches.com> (sfid-20130214_023328_153062_503D6B6E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These messages don't seem to be errors but notifications
that some attribute isn't quite right.

Don't mark them as errors.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c | 29 ++++++++++++--------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index e80825e..b3ea15e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -6443,10 +6443,9 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 
 			if ((txrate[k]->flags & IEEE80211_TX_RC_MCS)
 			    && (!is_mcs_rate(rspec[k]))) {
-				brcms_err(wlc->hw->d11core,
-					  "wl%d: %s: IEEE80211_TX_"
-					  "RC_MCS != is_mcs_rate(rspec)\n",
-					  wlc->pub->unit, __func__);
+				brcms_warn(wlc->hw->d11core,
+					   "wl%d: %s: IEEE80211_TX_RC_MCS != is_mcs_rate(rspec)\n",
+					   wlc->pub->unit, __func__);
 			}
 
 			if (is_mcs_rate(rspec[k])) {
@@ -6838,21 +6837,19 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 					wlc->fragthresh[queue] =
 					    (u16) newfragthresh;
 			} else {
-				brcms_err(wlc->hw->d11core,
-					  "wl%d: %s txop invalid "
-					  "for rate %d\n",
-					  wlc->pub->unit, fifo_names[queue],
-					  rspec2rate(rspec[0]));
+				brcms_warn(wlc->hw->d11core,
+					   "wl%d: %s txop invalid for rate %d\n",
+					   wlc->pub->unit, fifo_names[queue],
+					   rspec2rate(rspec[0]));
 			}
 
 			if (dur > wlc->edcf_txop[ac])
-				brcms_err(wlc->hw->d11core,
-					  "wl%d: %s: %s txop "
-					  "exceeded phylen %d/%d dur %d/%d\n",
-					  wlc->pub->unit, __func__,
-					  fifo_names[queue],
-					  phylen, wlc->fragthresh[queue],
-					  dur, wlc->edcf_txop[ac]);
+				brcms_warn(wlc->hw->d11core,
+					   "wl%d: %s: %s txop exceeded phylen %d/%d dur %d/%d\n",
+					   wlc->pub->unit, __func__,
+					   fifo_names[queue],
+					   phylen, wlc->fragthresh[queue],
+					   dur, wlc->edcf_txop[ac]);
 		}
 	}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

