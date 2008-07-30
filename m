Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:42876 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYG3EBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 00:01:35 -0400
Date: Tue, 29 Jul 2008 20:59:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix more kernel-doc warnings
Message-Id: <20080729205916.c4c6c363.randy.dunlap@oracle.com> (sfid-20080730_060138_683287_CA4C1AEB)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix several kernel-doc warnings in mac80211 header files:

Warning(linux-2.6.27-rc1//include/net/mac80211.h:759): Enum value 'IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE' not described in enum 'ieee80211_hw_flags'
Warning(linux-2.6.27-rc1//net/mac80211/sta_info.h:329): No description found for parameter 'tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1]'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/net/mac80211.h  |    4 ++++
 net/mac80211/sta_info.h |    1 +
 2 files changed, 5 insertions(+)

--- linux-2.6.27-rc1.orig/include/net/mac80211.h
+++ linux-2.6.27-rc1/include/net/mac80211.h
@@ -700,6 +700,10 @@ enum ieee80211_tkip_key_type {
  * any particular flags. There are some exceptions to this rule,
  * however, so you are advised to review these flags carefully.
  *
+ * @IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE:
+ *	Indicates that hardware or firmware takes care of beacon
+ *	generation.
+ *
  * @IEEE80211_HW_RX_INCLUDES_FCS:
  *	Indicates that received frames passed to the stack include
  *	the FCS at the end.
--- linux-2.6.27-rc1.orig/net/mac80211/sta_info.h
+++ linux-2.6.27-rc1/net/mac80211/sta_info.h
@@ -204,6 +204,7 @@ struct sta_ampdu_mlme {
  * @tx_fragments: number of transmitted MPDUs
  * @txrate_idx: TBD
  * @last_txrate_idx: TBD
+ * @tid_seq: TBD
  * @wme_tx_queue: TBD
  * @ampdu_mlme: TBD
  * @timer_to_tid: identity mapping to ID timers
