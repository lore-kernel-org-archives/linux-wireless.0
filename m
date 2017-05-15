Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757293AbdEOH7y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2017 03:59:54 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E6533D955
        for <linux-wireless@vger.kernel.org>; Mon, 15 May 2017 07:59:53 +0000 (UTC)
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlegacy: warn when enabling power save
Date: Mon, 15 May 2017 09:59:08 +0200
Message-Id: <1494835148-12945-1-git-send-email-sgruszka@redhat.com> (sfid-20170515_095957_887001_9CD92947)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwlegacy firmware can crash when power save is configured. PS was
allowed in "dbdac2b iwlegacy: properly enable power saving" with belive
that user who enable PS is aware of that and can relate firmware crahes
with PS. However some distributions seems to enable PS without user
intervention, so warn about that.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/intel/iwlegacy/common.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 140b6ea..6aaa0e7 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -5147,6 +5147,8 @@ void il_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	if (changed & (IEEE80211_CONF_CHANGE_PS | IEEE80211_CONF_CHANGE_IDLE)) {
 		il->power_data.ps_disabled = !(conf->flags & IEEE80211_CONF_PS);
+		WARN_ONCE(!il->power_data.ps_disabled,
+			  "Enabling power save might cause firmware crashes\n");
 		ret = il_power_update_mode(il, false);
 		if (ret)
 			D_MAC80211("Error setting sleep level\n");
-- 
1.7.1
