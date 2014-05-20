Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:58057 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaETUg6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 16:36:58 -0400
Received: by mail-ob0-f201.google.com with SMTP id wn1so210698obc.4
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 13:36:57 -0700 (PDT)
Received: from corp2gmr1-1.hot.corp.google.com (corp2gmr1-1.hot.corp.google.com [172.24.189.92])
        by gmr-mx.google.com with ESMTPS id k43si1082449yhq.3.2014.05.20.13.36.57
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 20 May 2014 13:36:57 -0700 (PDT)
Received: from pstew.mtv.corp.google.com (pstew.mtv.corp.google.com [172.22.72.159])
	by corp2gmr1-1.hot.corp.google.com (Postfix) with ESMTP id A30A031C248
	for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 13:36:57 -0700 (PDT)
From: Paul Stewart <pstew@chromium.org>
Date: Tue, 20 May 2014 13:27:16 -0700
Subject: [PATCH] nl80211: Provide TDLS link state
To: linux-wireless@vger.kernel.org
Message-Id: <20140520203657.2C281E0300@pstew.mtv.corp.google.com> (sfid-20140520_223701_643393_D7B74223)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide a method to query TDLS state in drivers that use the
NL80211_CMD_TDLS_OPER method for link setup.

Signed-off-by: Paul Stewart <pstew@chromium.org>
---
 include/uapi/linux/nl80211.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9922b9b..4f163f9 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3866,6 +3866,7 @@ enum nl80211_pmksa_candidate_attr {
  * @NL80211_TDLS_TEARDOWN: Teardown a TDLS link which is already established
  * @NL80211_TDLS_ENABLE_LINK: Enable TDLS link
  * @NL80211_TDLS_DISABLE_LINK: Disable TDLS link
+ * @NL80211_TDLS_QUERY_LINK: Query TDLS link status
  */
 enum nl80211_tdls_operation {
 	NL80211_TDLS_DISCOVERY_REQ,
@@ -3873,6 +3874,19 @@ enum nl80211_tdls_operation {
 	NL80211_TDLS_TEARDOWN,
 	NL80211_TDLS_ENABLE_LINK,
 	NL80211_TDLS_DISABLE_LINK,
+	NL80211_TDLS_QUERY_LINK,
+};
+
+/**
+ * enum nl80211_tdls_link_state - values returned fo %NL80211_TDLS_QUERY_LINK
+ * @NL80211_TDLS_LINK_STATE_UNKNOWN: Nothing is known about this peer
+ * @NL80211_TDLS_LINK_STATE_UNCONNECTED: TDLS link is not setup to peer
+ * @NL80211_TDLS_LINK_STATE_CONNECTED: TDLS link is setup to peer
+ */
+enum nl80211_tdls_link_state {
+	NL80211_TDLS_LINK_STATE_UNKNOWN,
+	NL80211_TDLS_LINK_STATE_UNCONNECTED,
+	NL80211_TDLS_LINK_STATE_CONNECTED,
 };
 
 /*
-- 
1.9.1.423.g4596e3a

