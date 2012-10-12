Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4892 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933843Ab2JLK23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 06:28:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Johannes Berg" <johannes.berg@intel.com>
Subject: [PATCH 3/3] wireless: remove duplicate enum ieee80211_eid
 definitions
Date: Fri, 12 Oct 2012 12:28:16 +0200
Message-ID: <1350037696-23747-4-git-send-email-arend@broadcom.com> (sfid-20121012_123441_902346_56935FE2)
In-Reply-To: <1350037696-23747-1-git-send-email-arend@broadcom.com>
References: <1350037696-23747-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WLAN_EID_WPA and WLAN_EID_GENERIC mapped to the same value
as WLAN_EID_VENDOR_SPECIFIC. The last one being more in line
with the standard specification. Removing WLAN_EID_WPA and
WLAN_EID_GENERIC as there are no longer drivers using these.

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 include/linux/ieee80211.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 2385119..213e7a3 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1440,8 +1440,6 @@ enum ieee80211_eid {
 
 	WLAN_EID_RSN = 48,
 	WLAN_EID_MMIE = 76,
-	WLAN_EID_WPA = 221,
-	WLAN_EID_GENERIC = 221,
 	WLAN_EID_VENDOR_SPECIFIC = 221,
 	WLAN_EID_QOS_PARAMETER = 222,
 
-- 
1.7.9.5


