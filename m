Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:52546 "HELO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758467Ab2DJDH0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 23:07:26 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/5] mwifiex: display correct country information in debugfs "info"
Date: Mon,  9 Apr 2012 20:06:55 -0700
Message-Id: <1334027217-23724-4-git-send-email-bzhao@marvell.com> (sfid-20120410_050730_506401_06DFFDD0)
In-Reply-To: <1334027217-23724-1-git-send-email-bzhao@marvell.com>
References: <1334027217-23724-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Use "priv->country_code" string to display country information in
debugfs command "info" instead of "adapter->region_code".

"adapter->region_code" contains default region code got from FW while
initialization, whereas "priv->country_code" is updated in reg_notifier
handler whenever there is a change in regulatory domain.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/debugfs.c   |    2 +-
 drivers/net/wireless/mwifiex/ioctl.h     |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 1a84507..a870b58 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -212,7 +212,7 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 		p += sprintf(p, "essid=\"%s\"\n", info.ssid.ssid);
 		p += sprintf(p, "bssid=\"%pM\"\n", info.bssid);
 		p += sprintf(p, "channel=\"%d\"\n", (int) info.bss_chan);
-		p += sprintf(p, "region_code = \"%02x\"\n", info.region_code);
+		p += sprintf(p, "country_code = \"%s\"\n", info.country_code);
 
 		netdev_for_each_mc_addr(ha, netdev)
 			p += sprintf(p, "multicast_address[%d]=\"%pM\"\n",
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 99c0664..887a7d9 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -96,7 +96,7 @@ struct mwifiex_bss_info {
 	u32 bss_mode;
 	struct cfg80211_ssid ssid;
 	u32 bss_chan;
-	u32 region_code;
+	u8 country_code[3];
 	u32 media_connected;
 	u32 max_power_level;
 	u32 min_power_level;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 8ba58d9..3bdef07 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -468,7 +468,8 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 
 	info->bss_chan = bss_desc->channel;
 
-	info->region_code = adapter->region_code;
+	memcpy(info->country_code, priv->country_code,
+	       IEEE80211_COUNTRY_STRING_LEN);
 
 	info->media_connected = priv->media_connected;
 
-- 
1.7.0.2

