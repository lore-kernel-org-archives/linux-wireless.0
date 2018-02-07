Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36514 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754328AbeBGQVQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Feb 2018 11:21:16 -0500
From: Srinivas Dasari <dasaris@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, jouni@codeaurora.org,
        Srinivas Dasari <dasaris@codeaurora.org>
Subject: [PATCH v2] ieee80211: Increase the PMK maximum length to 64 bytes
Date: Wed,  7 Feb 2018 21:50:51 +0530
Message-Id: <1518020451-8743-1-git-send-email-dasaris@codeaurora.org> (sfid-20180207_172119_934276_7A14D3DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed to cover the case of DPP with the NIST P-521 and
brainpoolP512r1 curves which derive a PMK that is longer than the
previously used limit.

Signed-off-by: Srinivas Dasari <dasaris@codeaurora.org>
---
 include/linux/ieee80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

v2:
-Modified the commit text and resending it to right recipients

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ee6657a..e4cba33 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2111,7 +2111,7 @@ enum ieee80211_key_len {
 #define FILS_ERP_MAX_REALM_LEN		253
 #define FILS_ERP_MAX_RRK_LEN		64
 
-#define PMK_MAX_LEN			48
+#define PMK_MAX_LEN			64
 
 /* Public action codes (IEEE Std 802.11-2016, 9.6.8.1, Table 9-307) */
 enum ieee80211_pub_actioncode {
-- 
1.9.1
