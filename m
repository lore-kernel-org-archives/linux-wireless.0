Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44412 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782AbZAUEmZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 23:42:25 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 20:42:25 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18806.42720.858590.913279@gargle.gargle.HOWL> (sfid-20090121_054230_290677_1646BFC2)
Date: Wed, 21 Jan 2009 10:08:56 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: Add documentation bits for mac80211_rate_control_flags
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 include/net/mac80211.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9a5869e..742937f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -262,6 +262,26 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(12),
 };
 
+/**
+ * enum mac80211_rate_control_flags - per-rate flags set by the
+ *	Rate Control algorithm.
+ *
+ * These flags are set by the Rate control algorithm for each rate during tx,
+ * in the @flags member of struct ieee80211_tx_rate.
+ *
+ * @IEEE80211_TX_RC_USE_RTS_CTS: Use RTS/CTS exchange for this rate.
+ * @IEEE80211_TX_RC_USE_CTS_PROTECT: CTS-to-self protection is required.
+ *	This is set if the current BSS requires ERP protection.
+ * @IEEE80211_TX_RC_USE_SHORT_PREAMBLE: Use short preamble.
+ * @IEEE80211_TX_RC_MCS: HT rate.
+ * @IEEE80211_TX_RC_GREEN_FIELD: Indicates whether this rate can be used in
+ *	Greenfield mode.
+ * @IEEE80211_TX_RC_40_MHZ_WIDTH: Indicates if the Channel Width can be 40 MHz.
+ * @IEEE80211_TX_RC_DUP_DATA: the frame should be transmitted on both of the
+ *	adjacent 20 MHz channels, if the current channel type is
+ *	NL80211_CHAN_HT40MINUS or NL80211_CHAN_HT40PLUS.
+ * @IEEE80211_TX_RC_SHORT_GI: Short Guard interval can be used for this rate.
+ */
 enum mac80211_rate_control_flags {
 	IEEE80211_TX_RC_USE_RTS_CTS		= BIT(0),
 	IEEE80211_TX_RC_USE_CTS_PROTECT		= BIT(1),
-- 
1.6.1

