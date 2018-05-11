Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:43376 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753150AbeEKOyz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 10:54:55 -0400
Received: by mail-pf0-f195.google.com with SMTP id j20-v6so2841866pff.10
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2018 07:54:55 -0700 (PDT)
From: Sushant Kumar Mishra <sushant2k1513@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
Subject: [PATCH 1/3] rsi: Add null check for virtual interfaces in wowlan config
Date: Fri, 11 May 2018 20:27:51 +0530
Message-Id: <1526050673-7026-2-git-send-email-sushant2k1513@gmail.com> (sfid-20180511_165459_122396_034F7802)
In-Reply-To: <1526050673-7026-1-git-send-email-sushant2k1513@gmail.com>
References: <1526050673-7026-1-git-send-email-sushant2k1513@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>

When the "poweroff" command is executed after wowlan enabled, we have
observed a system crash. In the system "poweroff" sequence, network-manager
is sent to inactive state by cleaning up the network interfaces, using
rsi_mac80211_remove_interface() and when driver tries to access those
network interfaces in rsi_wowlan_config() which was invoked by SDIO
shutdown, results in a crash. Added a NULL check before accessing the
network interfaces in rsi_wowlan_config().

Signed-off-by: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 80e7f4f..743706e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1804,10 +1804,15 @@ int rsi_config_wowlan(struct rsi_hw *adapter, struct cfg80211_wowlan *wowlan)
 	struct rsi_common *common = adapter->priv;
 	u16 triggers = 0;
 	u16 rx_filter_word = 0;
-	struct ieee80211_bss_conf *bss = &adapter->vifs[0]->bss_conf;
+	struct ieee80211_bss_conf *bss = NULL;
 
 	rsi_dbg(INFO_ZONE, "Config WoWLAN to device\n");
 
+	if (!adapter->vifs[0])
+		return -EINVAL;
+
+	bss = &adapter->vifs[0]->bss_conf;
+
 	if (WARN_ON(!wowlan)) {
 		rsi_dbg(ERR_ZONE, "WoW triggers not enabled\n");
 		return -EINVAL;
-- 
2.5.5
