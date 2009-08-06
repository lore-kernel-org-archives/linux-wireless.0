Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:20648 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753279AbZHFTCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 15:02:32 -0400
Date: Thu, 6 Aug 2009 21:04:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: Set WEP ciphers
Message-ID: <20090806190439.GA22647@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


With iwconfig there is no way to properly set the ciphers when trying to
connect to a WEP SSID. Although mac80211 based drivers dont need it, several
fullmac drivers do.
This patch basically sets the WEP ciphers whenever they're not set at all.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/wireless/sme.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 8a7dcbf..b78a111 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -638,14 +638,28 @@ int __cfg80211_connect(struct cfg80211_registered_device *rdev,
 
 	if (connkeys && connkeys->def >= 0) {
 		int idx;
+		u32 cipher;
 
 		idx = connkeys->def;
+		cipher = connkeys->params[idx].cipher;
 		/* If given a WEP key we may need it for shared key auth */
-		if (connkeys->params[idx].cipher == WLAN_CIPHER_SUITE_WEP40 ||
-		    connkeys->params[idx].cipher == WLAN_CIPHER_SUITE_WEP104) {
+		if (cipher == WLAN_CIPHER_SUITE_WEP40 ||
+		    cipher == WLAN_CIPHER_SUITE_WEP104) {
 			connect->key_idx = idx;
 			connect->key = connkeys->params[idx].key;
 			connect->key_len = connkeys->params[idx].key_len;
+
+			/*
+			 * If ciphers are not set (e.g. when going through
+			 * iwconfig), we have to set them appropriately here.
+			 */
+			if (connect->crypto.cipher_group == 0)
+				connect->crypto.cipher_group = cipher;
+
+			if (connect->crypto.n_ciphers_pairwise == 0) {
+				connect->crypto.n_ciphers_pairwise = 1;
+				connect->crypto.ciphers_pairwise[0] = cipher;
+			}					
 		}
 	}
 
-- 
1.6.3.1

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
