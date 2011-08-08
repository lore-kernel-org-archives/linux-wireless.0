Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43832 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab1HHJL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 05:11:59 -0400
Date: Mon, 8 Aug 2011 12:11:52 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211/nl80211: Send AssocReq IEs to user space in AP mode
Message-ID: <20110808091152.GA4769@jouni.qca.qualcomm.com> (sfid-20110808_111201_902515_DD3EDF8C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When user space SME/MLME (e.g., hostapd) is not used in AP mode, the
IEs from the (Re)Association Request frame that was processed in
firmware need to be made available for user space (e.g., RSN IE for
hostapd). Allow this to be done with cfg80211_new_sta().

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h |    8 ++++++++
 net/wireless/nl80211.c |    4 ++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d17f47f..51ba1af 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -536,6 +536,11 @@ struct sta_bss_parameters {
  *	This number should increase every time the list of stations
  *	changes, i.e. when a station is added or removed, so that
  *	userspace can tell whether it got a consistent snapshot.
+ * @assoc_req_ies: IEs from (Re)Association Request.
+ *	This is used only when in AP mode with drivers that do not use
+ *	user space MLME/SME implementation. The information is provided for
+ *	the cfg80211_new_sta() calls to notify user space of the IEs.
+ * @assoc_req_ies_len: Length of assoc_req_ies buffer in octets.
  */
 struct station_info {
 	u32 filled;
@@ -558,6 +563,9 @@ struct station_info {
 	struct sta_bss_parameters bss_param;
 
 	int generation;
+
+	const u8 *assoc_req_ies;
+	size_t assoc_req_ies_len;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e83e7fe..ec8444e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2237,6 +2237,10 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 	}
 	nla_nest_end(msg, sinfoattr);
 
+	if (sinfo->assoc_req_ies)
+		NLA_PUT(msg, NL80211_ATTR_IE, sinfo->assoc_req_ies_len,
+			sinfo->assoc_req_ies);
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
