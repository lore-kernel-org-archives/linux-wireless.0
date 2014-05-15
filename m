Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:49459 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755805AbaEORcV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:32:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, andrei.otcheretianski@intel.com
Date: Thu, 15 May 2014 20:32:08 +0300
Message-Id: <1400175128-25656-1-git-send-email-luca@coelho.fi> (sfid-20140515_193458_573227_74CD477E)
Subject: [PATCH] mac80211: fix csa_couter_offs argument name in docbook
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The csa_counter_offs was erroneously described as csa_counter_offs in
the docbook section.

This fixes two warnings when making htmldocs (at least):

Warning(include/net/mac80211.h:3428): No description found for parameter 'csa_counter_offs[IEEE80211_MAX_CSA_COUNTERS_NUM]'
Warning(include/net/mac80211.h:3428): Excess struct/union/enum/typedef member 'csa_offs' description in 'ieee80211_mutable_offsets'

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 982d2cd..a34f26a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3417,8 +3417,9 @@ void ieee80211_report_low_ack(struct ieee80211_sta *sta, u32 num_packets);
  * struct ieee80211_mutable_offsets - mutable beacon offsets
  * @tim_offset: position of TIM element
  * @tim_length: size of TIM element
- * @csa_offs: array of IEEE80211_MAX_CSA_COUNTERS_NUM offsets to CSA counters.
- *	This array can contain zero values which should be ignored.
+ * @csa_counter_offs: array of IEEE80211_MAX_CSA_COUNTERS_NUM offsets
+ *	to CSA counters.  This array can contain zero values which
+ *	should be ignored.
  */
 struct ieee80211_mutable_offsets {
 	u16 tim_offset;
-- 
2.0.0.rc0

