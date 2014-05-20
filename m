Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:43709 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaETWdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 18:33:18 -0400
Received: by mail-ob0-f201.google.com with SMTP id wn1so244936obc.4
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 15:33:17 -0700 (PDT)
From: Paul Stewart <pstew@chromium.org>
Date: Tue, 20 May 2014 13:27:16 -0700
Subject: [PATCHv2] nl80211: Provide TDLS link state
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luca@coelho.fi>
In-Reply-To: <1400622868.25946.12.camel@dubbel>
References: <20140520203657.2C281E0300@pstew.mtv.corp.google.com> <20140520203657.2C281E0300@pstew.mtv.corp.google.com>
Message-Id: <20140520223316.EFCF1E0007@pstew.mtv.corp.google.com> (sfid-20140521_003322_185995_CD232EF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide a method to query TDLS state in drivers that use the
NL80211_CMD_TDLS_OPER method for link setup.

Signed-off-by: Paul Stewart <pstew@chromium.org>
---
 include/uapi/linux/nl80211.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9922b9b..44aca23 100644
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
+ * enum nl80211_tdls_link_state - values returned for %NL80211_TDLS_QUERY_LINK
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

