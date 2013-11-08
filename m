Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:47647 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab3KHOkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 09:40:22 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	johannes@sipsolutions.net
Subject: [RFC v3 3/4] mac80211: align ieee80211_ibss_csa_beacon() with ieee80211_csa_beacon()
Date: Fri,  8 Nov 2013 16:39:38 +0200
Message-Id: <1383921579-22373-3-git-send-email-luciano.coelho@intel.com> (sfid-20131108_154026_693050_1A3AA044)
In-Reply-To: <1383921579-22373-1-git-send-email-luciano.coelho@intel.com>
References: <1383921579-22373-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The return value of ieee80211_ibss_csa_beacon is not aligned with the
return value of ieee80211_csa_beacon().  For consistency and to be
able to use both functions with similar code, change
ieee80211_ibss_csa_beacon() not to send the bss changed notification
itself, but return what has changed so the caller can send the
notification instead.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---

This is a new patch in the series to make things ready for patch 4/4.


 net/mac80211/ibss.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 548eae8..1c19df3 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -522,7 +522,7 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	if (csa_settings)
 		ieee80211_send_action_csa(sdata, csa_settings);
 
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
+	return BSS_CHANGED_BEACON;
  out:
 	return ret;
 }
@@ -559,9 +559,15 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata)
 
 	/* generate the beacon */
 	err = ieee80211_ibss_csa_beacon(sdata, NULL);
-	sdata_unlock(sdata);
-	if (err < 0)
+	if (err < 0) {
+		sdata_unlock(sdata);
 		return err;
+	}
+
+	if (err)
+		ieee80211_bss_info_change_notify(sdata, err);
+
+	sdata_unlock(sdata);
 
 	return 0;
 }
-- 
1.8.4.rc3

