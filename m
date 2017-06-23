Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34277 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753820AbdFWOLO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 10:11:14 -0400
Received: by mail-pf0-f196.google.com with SMTP id d5so7549805pfe.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 07:11:14 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 16/17] rsi: Send rx filter frame to device when interface is down
Date: Fri, 23 Jun 2017 19:37:35 +0530
Message-Id: <1498226856-6305-17-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170623_161118_323188_FF23DBC7)
In-Reply-To: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

When interface is down it is better to stop all RX packets to
host. 0xffff will block all packets to host.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 36303ae..d094b0a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -301,6 +301,10 @@ static void rsi_mac80211_stop(struct ieee80211_hw *hw)
 
 	mutex_lock(&common->mutex);
 	common->iface_down = true;
+
+	/* Block all rx frames */
+	rsi_send_rx_filter_frame(common, 0xffff);
+
 	mutex_unlock(&common->mutex);
 }
 
-- 
2.7.4
