Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51232 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746AbcCUUBU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2016 16:01:20 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 2/2] wil6210: add module parameter for alternate interface name
Date: Mon, 21 Mar 2016 22:01:12 +0200
Message-Id: <1458590472-677-3-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160321_210125_725805_4D2F93FA)
In-Reply-To: <1458590472-677-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1458590472-677-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Add a module parameter alt_ifname that when set, will name
the primary network interface wigig<N> instead of the default
wlan<N>. This helps platforms such as android where we need to
clearly separate the WIGIG interface from the default wireless
interface.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 3bc0e26..f78ea91 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -14,10 +14,15 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/moduleparam.h>
 #include <linux/etherdevice.h>
 #include "wil6210.h"
 #include "txrx.h"
 
+static bool alt_ifname; /* = false; */
+module_param(alt_ifname, bool, S_IRUGO);
+MODULE_PARM_DESC(alt_ifname, " use an alternate interface name wigigN instead of wlanN");
+
 static int wil_open(struct net_device *ndev)
 {
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
@@ -136,6 +141,7 @@ void *wil_if_alloc(struct device *dev)
 	struct wil6210_priv *wil;
 	struct ieee80211_channel *ch;
 	int rc = 0;
+	const char *ifname = alt_ifname ? "wigig%d" : "wlan%d";
 
 	wdev = wil_cfg80211_init(dev);
 	if (IS_ERR(wdev)) {
@@ -160,7 +166,7 @@ void *wil_if_alloc(struct device *dev)
 	ch = wdev->wiphy->bands[IEEE80211_BAND_60GHZ]->channels;
 	cfg80211_chandef_create(&wdev->preset_chandef, ch, NL80211_CHAN_NO_HT);
 
-	ndev = alloc_netdev(0, "wlan%d", NET_NAME_UNKNOWN, wil_dev_setup);
+	ndev = alloc_netdev(0, ifname, NET_NAME_UNKNOWN, wil_dev_setup);
 	if (!ndev) {
 		dev_err(dev, "alloc_netdev_mqs failed\n");
 		rc = -ENOMEM;
-- 
1.8.5.2

