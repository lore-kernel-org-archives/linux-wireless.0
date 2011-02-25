Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web57406.mail.re1.yahoo.com ([66.196.100.57]:34063 "HELO
	web57406.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932510Ab1BYKPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 05:15:31 -0500
Message-ID: <557082.85443.qm@web57406.mail.re1.yahoo.com>
Date: Fri, 25 Feb 2011 02:08:49 -0800 (PST)
From: Joe Gunn <armadefuego@yahoo.com>
Subject: [PATCH 2.6.38-rc6-wl 1/1] orinoco: Drop scan results with unknown channels
To: orinoco-devel@lists.sourceforge.net
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the frequency can not be mapped to a channel structure log it and drop it.
---
The driver was getting an error return from the frequency map. The invalid freq
uency was not in the frequency table, so the channel structure returned null. T
his test fro that case and does not allow the packet to continue up the stack.
---
diff --git a/drivers/net/wireless/orinoco/scan.c b/drivers/net/wireless/orinoco
/scan.c
index 86cb54c..e99ca1c 100644
--- a/drivers/net/wireless/orinoco/scan.c
+++ b/drivers/net/wireless/orinoco/scan.c
@@ -111,6 +111,11 @@ static void orinoco_add_hostscan_result(struct orinoco_pri
vate *priv,
 
 	freq = ieee80211_dsss_chan_to_freq(le16_to_cpu(bss->a.channel));
 	channel = ieee80211_get_channel(wiphy, freq);
+	if (!channel) {
+		printk(KERN_DEBUG "Invalid channel designation %04X(%04X)",
+			bss->a.channel, freq);
+		return;	/* Then ignore it for now */
+	}
 	timestamp = 0;
 	capability = le16_to_cpu(bss->a.capabilities);
 	beacon_interval = le16_to_cpu(bss->a.beacon_interv);

Signed-off-by: Joseph J. Gunn <armadefuego@yahoo.com>



      
