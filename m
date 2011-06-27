Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:51323 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1F0Pdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 11:33:54 -0400
Subject: [PATCH] ath6kl: Add PMKSA cache management commands
To: gregkh@suse.de
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Mon, 27 Jun 2011 18:33:40 +0300
Message-ID: <20110627153340.16672.61729.stgit@localhost6.localdomain6> (sfid-20110627_173358_396119_5405EDB1)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jouni Malinen <jouni@qca.qualcomm.com>

Implement cfg80211_ops set_pmksa, del_pmksa, and flush_pmksa to enable
PMKSA caching support.

kvalo: backported from ath6kl-cleanup tree

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/staging/ath6kl/os/linux/cfg80211.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index b098c22..441ae04 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -1669,6 +1669,28 @@ static int ar6k_get_station(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int ar6k_set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
+			  struct cfg80211_pmksa *pmksa)
+{
+	struct ar6_softc *ar = ar6k_priv(netdev);
+	return wmi_setPmkid_cmd(ar->arWmi, pmksa->bssid, pmksa->pmkid, true);
+}
+
+static int ar6k_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
+			  struct cfg80211_pmksa *pmksa)
+{
+	struct ar6_softc *ar = ar6k_priv(netdev);
+	return wmi_setPmkid_cmd(ar->arWmi, pmksa->bssid, pmksa->pmkid, false);
+}
+
+static int ar6k_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
+{
+	struct ar6_softc *ar = ar6k_priv(netdev);
+	if (ar->arConnected)
+		return wmi_setPmkid_cmd(ar->arWmi, ar->arBssid, NULL, false);
+	return 0;
+}
+
 static struct
 cfg80211_ops ar6k_cfg80211_ops = {
     .change_virtual_intf = ar6k_cfg80211_change_iface,
@@ -1690,6 +1712,9 @@ cfg80211_ops ar6k_cfg80211_ops = {
     .join_ibss = ar6k_cfg80211_join_ibss,
     .leave_ibss = ar6k_cfg80211_leave_ibss,
     .get_station = ar6k_get_station,
+    .set_pmksa = ar6k_set_pmksa,
+    .del_pmksa = ar6k_del_pmksa,
+    .flush_pmksa = ar6k_flush_pmksa,
     CFG80211_TESTMODE_CMD(ar6k_testmode_cmd)
 };
 

