Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34984 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753887AbdGJMpn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 08:45:43 -0400
Received: by mail-pf0-f194.google.com with SMTP id q85so14376988pfq.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 05:45:43 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 16/17] rsi: Send rx filter frame to device when interface is down
Date: Mon, 10 Jul 2017 18:10:47 +0530
Message-Id: <1499690448-9956-17-git-send-email-amitkarwar@gmail.com> (sfid-20170710_144558_507984_8A5E9B28)
In-Reply-To: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
References: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
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
