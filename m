Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:49043 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab2CGUbT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 15:31:19 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] mac80211: update ieee80211_tx_rate_control kerneldoc
Date: Wed,  7 Mar 2012 21:31:13 +0100
Message-Id: <1331152273-16114-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20120307_213122_842792_C6F33AA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * add entry for rate_idx_mcs_mask
 * fix order of entries to represent the structs' order

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 include/net/mac80211.h |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c06974a..f7917f7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3568,6 +3568,8 @@ enum rate_control_changed {
  * @hw: The hardware the algorithm is invoked for.
  * @sband: The band this frame is being transmitted on.
  * @bss_conf: the current BSS configuration
+ * @skb: the skb that will be transmitted, the control information in it needs
+ *	to be filled in
  * @reported_rate: The rate control algorithm can fill this in to indicate
  *	which rate should be reported to userspace as the current rate and
  *	used for rate calculations in the mesh network.
@@ -3575,12 +3577,11 @@ enum rate_control_changed {
  *	RTS threshold
  * @short_preamble: whether mac80211 will request short-preamble transmission
  *	if the selected rate supports it
- * @max_rate_idx: user-requested maximum rate (not MCS for now)
+ * @max_rate_idx: user-requested maximum (legacy) rate
  *	(deprecated; this will be removed once drivers get updated to use
  *	rate_idx_mask)
- * @rate_idx_mask: user-requested rate mask (not MCS for now)
- * @skb: the skb that will be transmitted, the control information in it needs
- *	to be filled in
+ * @rate_idx_mask: user-requested (legacy) rate mask
+ * @rate_idx_mcs_mask: user-requested MCS rate mask
  * @bss: whether this frame is sent out in AP or IBSS mode
  */
 struct ieee80211_tx_rate_control {
-- 
1.7.9.1

