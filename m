Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58836 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750984AbdK3GWz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Nov 2017 01:22:55 -0500
From: Xinming Hu <huxm@marvell.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Limin Zhu <liminzhu@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: cfg80211: do not change virtual interface during scan processing
Date: Thu, 30 Nov 2017 14:22:34 +0800
Message-ID: <1512022954-10129-1-git-send-email-huxm@marvell.com> (sfid-20171130_072300_946016_2F1EC9C1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Limin Zhu <liminzhu@marvell.com>

(1) Change virtual interface operation in cfg80211 process reset and
reinitilize private data structure.
(2) Scan result event processed in main process will dereference private
data structure concurrently, ocassionly crash the kernel.

The cornel case could be trigger by below steps:
(1) wpa_cli mlan0 scan
(2) ./hostapd mlan0.conf

Cfg80211 asynchronous scan procedure is not all the time operated
under rtnl lock, here we add the protect to serialize the cfg80211
scan and change_virtual interface operation.

Signed-off-by: Limin Zhu <liminzhu@marvell.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 4d45df8..ce4432c 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1116,6 +1116,12 @@ static int mwifiex_deinit_priv_params(struct mwifiex_private *priv)
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	enum nl80211_iftype curr_iftype = dev->ieee80211_ptr->iftype;
 
+	if (priv->scan_request) {
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "change virtual interface: scan in process\n");
+		return -EBUSY;
+	}
+
 	switch (curr_iftype) {
 	case NL80211_IFTYPE_ADHOC:
 		switch (type) {
-- 
1.9.1
