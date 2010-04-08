Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47036 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933311Ab0DHT1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:52 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 096/102] mac80211: add LDPC control flag
Date: Thu,  8 Apr 2010 15:27:32 -0400
Message-Id: <1270754858-26266-97-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

LDPC will be enabled through the rate control algorithm
for each buffer the the tx_info flags.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/mac80211.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dcf3c5f..75056dd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -274,6 +274,7 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_INTFL_NL80211_FRAME_TX: Frame was requested through nl80211
  *	MLME command (internal to mac80211 to figure out whether to send TX
  *	status to user space)
+ * @IEEE80211_TX_CTL_LDPC: tells the driver to use LDPC for this frame
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -297,6 +298,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(19),
 	IEEE80211_TX_INTFL_HAS_RADIOTAP		= BIT(20),
 	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(21),
+	IEEE80211_TX_CTL_LDPC			= BIT(22),
 };
 
 /**
-- 
1.6.3.3

