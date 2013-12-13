Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:34529 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3LMLyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 06:54:40 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v9 2/5] mac80211: align ieee80211_ibss_csa_beacon() with ieee80211_csa_beacon()
Date: Fri, 13 Dec 2013 13:54:32 +0200
Message-Id: <1386935675-24548-3-git-send-email-luciano.coelho@intel.com> (sfid-20131213_125445_688109_727A4CBE)
In-Reply-To: <1386935675-24548-1-git-send-email-luciano.coelho@intel.com>
References: <1386935675-24548-1-git-send-email-luciano.coelho@intel.com>
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
 net/mac80211/ibss.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 0c3a45c..262fd56 100644
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
@@ -563,6 +563,9 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata)
 	if (err < 0)
 		return err;
 
+	if (err)
+		ieee80211_bss_info_change_notify(sdata, err);
+
 	return 0;
 }
 
-- 
1.8.5.1

