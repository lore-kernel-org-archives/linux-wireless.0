Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:11420 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYFYVUj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 17:20:39 -0400
Received: by py-out-1112.google.com with SMTP id p76so1825498pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 14:20:39 -0700 (PDT)
Subject: [PATCH-BUGFIX?] prism: islpci_eth.c endianness fix
From: Harvey Harrison <harvey.harrison@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: John Linville <linville@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 25 Jun 2008 14:20:37 -0700
Message-Id: <1214428837.6908.3.camel@brick> (sfid-20080625_232045_576288_50F21486)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

clock is already cpu-endian (see le32_to_cpu slightly before), so
le64_to_cpu doesn't make much sense.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/prism54/islpci_eth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/prism54/islpci_eth.c b/drivers/net/wireless/prism54/islpci_eth.c
index 762e85b..e43bae9 100644
--- a/drivers/net/wireless/prism54/islpci_eth.c
+++ b/drivers/net/wireless/prism54/islpci_eth.c
@@ -290,7 +290,7 @@ islpci_monitor_rx(islpci_private *priv, struct sk_buff **skb)
 
 		avs->version = cpu_to_be32(P80211CAPTURE_VERSION);
 		avs->length = cpu_to_be32(sizeof (struct avs_80211_1_header));
-		avs->mactime = cpu_to_be64(le64_to_cpu(clock));
+		avs->mactime = cpu_to_be64(clock);
 		avs->hosttime = cpu_to_be64(jiffies);
 		avs->phytype = cpu_to_be32(6);	/*OFDM: 6 for (g), 8 for (a) */
 		avs->channel = cpu_to_be32(channel_of_freq(freq));
-- 
1.5.6.290.gc4e15



