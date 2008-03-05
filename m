Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18439 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbYCEPnE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 10:43:04 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, reinette.chatre@intel.com,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: document IEEE80211_TXCTL_OFDM_HT
Date: Wed,  5 Mar 2008 17:38:59 +0200
Message-Id: <1204731539-3512-1-git-send-email-ron.rindjunsky@intel.com> (sfid-20080305_154332_528210_08A5C5A6)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch clarifies the use of IEEE80211_TXCTL_OFDM_HT flag.

Can by united with patch "mac80211: adding mac80211_tx_control
flags and HT flags"

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 include/net/mac80211.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a64f42d..53884cd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -224,7 +224,11 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TXCTL_EAPOL_FRAME: internal to mac80211
  * @IEEE80211_TXCTL_SEND_AFTER_DTIM: send this frame after DTIM beacon
  * @IEEE80211_TXCTL_AMPDU: this frame should be sent as part of an A-MPDU
- * @IEEE80211_TXCTL_OFDM_HT: this frame can be sent in HT OFDM rates
+ * @IEEE80211_TXCTL_OFDM_HT: this frame can be sent in HT OFDM rates. number
+ * 			     of streams when this flag is on can be extracted
+ *			     from antenna_sel_tx, so if 1 antenna is marked
+ *			     use SISO, 2 antennas marked use MIMO, n antennas
+ *			     marked use MIMO_n.
  * @IEEE80211_TXCTL_GREEN_FIELD: use green field protection for this frame
  * @IEEE80211_TXCTL_40_MHZ_WIDTH: send this frame using 40 Mhz channel width
  * @IEEE80211_TXCTL_DUP_DATA: duplicate data frame on both 20 Mhz channels
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

