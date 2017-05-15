Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760527AbdEOJ3N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2017 05:29:13 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 99A3580463
        for <linux-wireless@vger.kernel.org>; Mon, 15 May 2017 09:29:12 +0000 (UTC)
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2] iwlegacy: warn when enabling power save
Date: Mon, 15 May 2017 11:28:26 +0200
Message-Id: <1494840506-16485-1-git-send-email-sgruszka@redhat.com> (sfid-20170515_112916_466952_0283E872)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwlegacy firmware can crash when power save is configured. PS was
allowed in "dbdac2b iwlegacy: properly enable power saving" with belive
that user who enable PS is aware of that and can relate firmware crahes
with PS. However some distributions seems to enable PS without user
intervention, so warn about that.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2: do not print call trace

 drivers/net/wireless/intel/iwlegacy/common.c |    2 ++
 drivers/net/wireless/intel/iwlegacy/common.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 140b6ea..8d5acda 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -5147,6 +5147,8 @@ void il_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	if (changed & (IEEE80211_CONF_CHANGE_PS | IEEE80211_CONF_CHANGE_IDLE)) {
 		il->power_data.ps_disabled = !(conf->flags & IEEE80211_CONF_PS);
+		if (!il->power_data.ps_disabled)
+			IL_WARN_ONCE("Enabling power save might cause firmware crashes\n");
 		ret = il_power_update_mode(il, false);
 		if (ret)
 			D_MAC80211("Error setting sleep level\n");
diff --git a/drivers/net/wireless/intel/iwlegacy/common.h b/drivers/net/wireless/intel/iwlegacy/common.h
index 3bba521..18c60c9 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.h
+++ b/drivers/net/wireless/intel/iwlegacy/common.h
@@ -45,6 +45,7 @@
 
 #define IL_ERR(f, a...) dev_err(&il->pci_dev->dev, f, ## a)
 #define IL_WARN(f, a...) dev_warn(&il->pci_dev->dev, f, ## a)
+#define IL_WARN_ONCE(f, a...) dev_warn_once(&il->pci_dev->dev, f, ## a)
 #define IL_INFO(f, a...) dev_info(&il->pci_dev->dev, f, ## a)
 
 #define RX_QUEUE_SIZE                         256
-- 
1.7.1
