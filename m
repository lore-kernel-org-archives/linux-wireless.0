Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:17927 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753524AbdLNQxc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 11:53:32 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH v2 9/9] wil6210: remove reference to preset_chandef
Date: Thu, 14 Dec 2017 18:53:13 +0200
Message-Id: <1513270393-919-10-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171214_175337_063985_D6B72C0E)
In-Reply-To: <1513270393-919-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1513270393-919-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

The field preset_chandef of wireless_dev must not be accessed
by the driver because it is private to cfg80211. Store the
monitor channel locally in wil6210_priv instead.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 3 +--
 drivers/net/wireless/ath/wil6210/debugfs.c  | 1 -
 drivers/net/wireless/ath/wil6210/netdev.c   | 2 +-
 drivers/net/wireless/ath/wil6210/txrx.c     | 3 +--
 drivers/net/wireless/ath/wil6210/wil6210.h  | 1 +
 drivers/net/wireless/ath/wil6210/wmi.c      | 2 +-
 6 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 39509d0..768f63f38 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -956,9 +956,8 @@ static int wil_cfg80211_set_channel(struct wiphy *wiphy,
 				    struct cfg80211_chan_def *chandef)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
-	struct wireless_dev *wdev = wil_to_wdev(wil);
 
-	wdev->preset_chandef = *chandef;
+	wil->monitor_chandef = *chandef;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 4475937..4a48882 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -869,7 +869,6 @@ static ssize_t wil_write_file_txmgmt(struct file *file, const char __user *buf,
 
 	params.buf = frame;
 	params.len = len;
-	params.chan = wdev->preset_chandef.chan;
 
 	rc = wil_cfg80211_mgmt_tx(wiphy, wdev, &params, NULL);
 
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index b641ac1..7ba4e0a 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -150,7 +150,7 @@ void *wil_if_alloc(struct device *dev)
 	wdev->iftype = NL80211_IFTYPE_STATION; /* TODO */
 	/* default monitor channel */
 	ch = wdev->wiphy->bands[NL80211_BAND_60GHZ]->channels;
-	cfg80211_chandef_create(&wdev->preset_chandef, ch, NL80211_CHAN_NO_HT);
+	cfg80211_chandef_create(&wil->monitor_chandef, ch, NL80211_CHAN_NO_HT);
 
 	ndev = alloc_netdev(0, "wlan%d", NET_NAME_UNKNOWN, wil_dev_setup);
 	if (!ndev) {
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 4fc05f7..9f8c6087f 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -428,7 +428,6 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct vring *vring,
 static void wil_rx_add_radiotap_header(struct wil6210_priv *wil,
 				       struct sk_buff *skb)
 {
-	struct wireless_dev *wdev = wil->wdev;
 	struct wil6210_rtap {
 		struct ieee80211_radiotap_header rthdr;
 		/* fields should be in the order of bits in rthdr.it_present */
@@ -455,7 +454,7 @@ static void wil_rx_add_radiotap_header(struct wil6210_priv *wil,
 	int rtap_len = sizeof(struct wil6210_rtap);
 	int phy_length = 0; /* phy info header size, bytes */
 	static char phy_data[128];
-	struct ieee80211_channel *ch = wdev->preset_chandef.chan;
+	struct ieee80211_channel *ch = wil->monitor_chandef.chan;
 
 	if (rtap_include_phy_info) {
 		rtap_len = sizeof(*rtap_vendor) + sizeof(*d);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 703e09e..1131893 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -655,6 +655,7 @@ struct wil6210_priv {
 	unsigned long last_fw_recovery; /* jiffies of last fw recovery */
 	wait_queue_head_t wq; /* for all wait_event() use */
 	/* profile */
+	struct cfg80211_chan_def monitor_chandef;
 	u32 monitor_flags;
 	u32 privacy; /* secure connection? */
 	u8 hidden_ssid; /* relevant in AP mode */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 9b9882c..2ab71bb 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1782,7 +1782,7 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring)
 	int rc;
 
 	if (wdev->iftype == NL80211_IFTYPE_MONITOR) {
-		struct ieee80211_channel *ch = wdev->preset_chandef.chan;
+		struct ieee80211_channel *ch = wil->monitor_chandef.chan;
 
 		cmd.sniffer_cfg.mode = cpu_to_le32(WMI_SNIFFER_ON);
 		if (ch)
-- 
1.9.1
