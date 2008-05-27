Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24554 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757491AbYE0RAT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 13:00:19 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, j@w1.fi
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/1] mac80211: sends HT IE to user level through wext
Date: Tue, 27 May 2008 20:00:11 +0300
Message-Id: <1211907611-27979-1-git-send-email-tomas.winkler@intel.com> (sfid-20080527_190023_078691_DDFEE7B9)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch adds HT IE in the scan list that is returned to user level
through wext. This is useful to let wpa_supplicant if a bss supports 11n or
not: WEP and TKIP are not supported in 11n.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fd42ffd..dec67ff 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4131,6 +4131,14 @@ ieee80211_sta_scan_result(struct net_device *dev,
 						  bss->rsn_ie);
 	}
 
+	if (bss && bss->ht_ie) {
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = IWEVGENIE;
+		iwe.u.data.length = bss->ht_ie_len;
+		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,
+						  bss->ht_ie);
+	}
+
 	if (bss && bss->supp_rates_len > 0) {
 		/* display all supported rates in readable format */
 		char *p = current_ev + IW_EV_LCP_LEN;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

