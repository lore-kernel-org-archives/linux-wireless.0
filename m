Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48956 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab1KHROQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 12:14:16 -0500
Received: by eye27 with SMTP id 27so573929eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 09:14:15 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] ath6kl: indicate probe-resp offload support
Date: Tue,  8 Nov 2011 19:14:08 +0200
Message-Id: <1320772448-20467-1-git-send-email-arik@wizery.com> (sfid-20111108_181419_877458_6C620174)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath6kl responds to probe-requests in HW while operating as an AP. It
supports offloading exclusions to support the WPS, WPS2, P2P and
802.11u protocols.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
I haven't added validation in hostap that check for these flags before
sending down the probe-resp IEs. This is still useful for tools such as
iw, that can print out device characteristics.

I'm not sure 802.11u is actually supported, just seemed so from the
hostap code sending down the IEs.

The patch of course depends on
"nl80211: Add probe response offload attribute"

drivers/net/wireless/ath/ath6kl/init.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index b277111..075d904 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1549,7 +1549,13 @@ static int ath6kl_init(struct net_device *dev)
 	ar->conf_flags = ATH6KL_CONF_IGNORE_ERP_BARKER |
 			 ATH6KL_CONF_ENABLE_11N | ATH6KL_CONF_ENABLE_TX_BURST;
 
-	ar->wdev->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
+	ar->wdev->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM |
+				  WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
+	ar->wdev->wiphy->probe_resp_offload =
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U;
 
 	status = ath6kl_target_config_wlan_params(ar);
 	if (!status)
-- 
1.7.5.4

