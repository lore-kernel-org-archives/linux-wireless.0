Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49418 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753615AbcJRUMV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 16:12:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Tue, 18 Oct 2016 23:12:07 +0300
Message-Id: <20161018201213.18873-2-luca@coelho.fi> (sfid-20161018_221226_146969_58C2DEFD)
In-Reply-To: <20161018201213.18873-1-luca@coelho.fi>
References: <20161018201213.18873-1-luca@coelho.fi>
Subject: [PATCH 1/7] wireless: radiotap: fix timestamp sampling position values
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The values don't match the radiotap spec, corrected that.

Reported-by: Oz Shalev <oz.shalev@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/ieee80211_radiotap.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index ba07b9d..d0e7e3f 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -333,9 +333,9 @@ enum ieee80211_radiotap_type {
 #define IEEE80211_RADIOTAP_TIMESTAMP_UNIT_NS			0x0003
 #define IEEE80211_RADIOTAP_TIMESTAMP_SPOS_MASK			0x00F0
 #define IEEE80211_RADIOTAP_TIMESTAMP_SPOS_BEGIN_MDPU		0x0000
-#define IEEE80211_RADIOTAP_TIMESTAMP_SPOS_EO_MPDU		0x0010
+#define IEEE80211_RADIOTAP_TIMESTAMP_SPOS_PLCP_SIG_ACQ		0x0010
 #define IEEE80211_RADIOTAP_TIMESTAMP_SPOS_EO_PPDU		0x0020
-#define IEEE80211_RADIOTAP_TIMESTAMP_SPOS_PLCP_SIG_ACQ		0x0030
+#define IEEE80211_RADIOTAP_TIMESTAMP_SPOS_EO_MPDU		0x0030
 #define IEEE80211_RADIOTAP_TIMESTAMP_SPOS_UNKNOWN		0x00F0
 
 #define IEEE80211_RADIOTAP_TIMESTAMP_FLAG_64BIT			0x00
-- 
2.9.3
