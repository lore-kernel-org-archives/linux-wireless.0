Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36202 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568AbcGIBCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 21:02:31 -0400
Received: by mail-io0-f196.google.com with SMTP id s93so3673538ioi.3
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jul 2016 18:02:31 -0700 (PDT)
From: engineering@keppy.com
To: kvalo@qca.qualcomm.com
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] ath6kl: sme_state shortcut to SME_DISCONNECTED removed
Date: Fri,  8 Jul 2016 21:04:19 -0400
Message-Id: <1468026259-25148-1-git-send-email-dan.kephart@lairdtech.com> (sfid-20160709_030241_300406_E8EB46E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Kephart <dan.kephart@lairdtech.com>

When an NL80211_DISCONNECT is sent to cfg80211, the driver's cfg80211
disconnect function sets the sme_state to SME_DISCONNECTED before receiving
a WMI_DISCONNECT_EVENT from the firmware.  This caused cfg80211 to not know
that the connection is disconnected because the driver fails to notify
cfg80211 upon receiving WMI_DISCONNECT_EVENT from the firmware believing
it is already disconnected.

Signed-off-by: Dan Kephart <dan.kephart@lairdtech.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index ef5b40e..86a860f 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -847,8 +847,6 @@ static int ath6kl_cfg80211_disconnect(struct wiphy *wiphy,
 
 	up(&ar->sem);
 
-	vif->sme_state = SME_DISCONNECTED;
-
 	return 0;
 }
 
-- 
2.4.10

