Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:53815 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758798Ab3KMJhM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 04:37:12 -0500
Received: by mail-bk0-f43.google.com with SMTP id mz13so190758bkb.2
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 01:37:11 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] cfg80211: fix regulatory flags kdoc
Date: Wed, 13 Nov 2013 10:37:08 +0100
Message-Id: <1384335428-24112-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_103717_404275_82645B47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the _FLAG prefix as it was not used.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/net/regulatory.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 7e98e5a..7e49cf6 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -89,14 +89,14 @@ struct regulatory_request {
 /**
  * enum ieee80211_regulatory_flags - device regulatory flags
  *
- * @REGULATORY_FLAG_CUSTOM_REG: tells us the driver for this device
+ * @REGULATORY_CUSTOM_REG: tells us the driver for this device
  * 	has its own custom regulatory domain and cannot identify the
  * 	ISO / IEC 3166 alpha2 it belongs to. When this is enabled
  * 	we will disregard the first regulatory hint (when the
  * 	initiator is %REGDOM_SET_BY_CORE). Drivers that use
  * 	wiphy_apply_custom_regulatory() should have this flag set
  * 	or the regulatory core will set it for the wiphy.
- * @REGULATORY_FLAG_STRICT_REG: tells us that the wiphy for this device
+ * @REGULATORY_STRICT_REG: tells us that the wiphy for this device
  *	has regulatory domain that it wishes to be considered as the
  *	superset for regulatory rules. After this device gets its regulatory
  *	domain programmed further regulatory hints shall only be considered
@@ -112,7 +112,7 @@ struct regulatory_request {
  *	will have their wiphy->regd programmed once the regulatory
  *	domain is set, and all other regulatory hints will be ignored
  *	until their own regulatory domain gets programmed.
- * @REGULATORY_FLAG_DISABLE_BEACON_HINTS: enable this if your driver needs to
+ * @REGULATORY_DISABLE_BEACON_HINTS: enable this if your driver needs to
  *	ensure that passive scan flags and beaconing flags may not be lifted by
  *	cfg80211 due to regulatory beacon hints. For more information on beacon
  *	hints read the documenation for regulatory_hint_found_beacon()
-- 
1.8.4.rc3

