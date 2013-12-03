Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:52952 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3LCNs3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 08:48:29 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v6 2/5] mac80211: align ieee80211_ibss_csa_beacon() with ieee80211_csa_beacon()
Date: Tue,  3 Dec 2013 15:48:19 +0200
Message-Id: <1386078502-19845-3-git-send-email-luciano.coelho@intel.com> (sfid-20131203_144836_023054_822D2EAA)
In-Reply-To: <1386078502-19845-1-git-send-email-luciano.coelho@intel.com>
References: <1386078502-19845-1-git-send-email-luciano.coelho@intel.com>
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
 net/mac80211/ibss.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 3514aab..23e035f 100644
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
@@ -559,11 +559,17 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata)
 
 	/* generate the beacon */
 	err = ieee80211_ibss_csa_beacon(sdata, NULL);
-	sdata_unlock(sdata);
 	if (err < 0)
-		return err;
+		goto out;
 
-	return 0;
+	if (err) {
+		ieee80211_bss_info_change_notify(sdata, err);
+		err = 0;
+	}
+out:
+	sdata_unlock(sdata);
+
+	return err;
 }
 
 void ieee80211_ibss_stop(struct ieee80211_sub_if_data *sdata)
-- 
1.8.4.2

