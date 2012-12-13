Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:47082 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab2LMN7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 08:59:05 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 1/8] cfg80211: add CHAN_MODE_SINGLE_ONLY for DFS use
Date: Thu, 13 Dec 2012 14:58:26 +0100
Message-Id: <1355407113-27006-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121213_145920_412752_1CAB8437)
In-Reply-To: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In DFS, we don't allow multiple virtual interfaces on one phy
for now, because synchronizing channel state between them is not
trivial and not implemented so far. Therefore, add another channel
mode to seperate this.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/wireless/core.h |    1 +
 net/wireless/util.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3563097..642587c 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -257,6 +257,7 @@ enum cfg80211_chan_mode {
 	CHAN_MODE_UNDEFINED,
 	CHAN_MODE_SHARED,
 	CHAN_MODE_EXCLUSIVE,
+	CHAN_MODE_SINGLE_ONLY,
 };
 
 struct cfg80211_beacon_registration {
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 16d76a8..18a3349 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1220,6 +1220,10 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 	case CHAN_MODE_EXCLUSIVE:
 		num_different_channels++;
 		break;
+	case CHAN_MODE_SINGLE_ONLY:
+		used_channels[0] = chan;
+		num_different_channels++;
+		break;
 	}
 
 	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
@@ -1268,6 +1272,12 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		case CHAN_MODE_EXCLUSIVE:
 			num_different_channels++;
 			break;
+		case CHAN_MODE_SINGLE_ONLY:
+			/* can't add any more interfaces when a single channel
+			 * has already been added.
+			 */
+			return -EBUSY;
+			break;
 		}
 
 		num[wdev_iter->iftype]++;
@@ -1278,6 +1288,10 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 	if (total == 1)
 		return 0;
 
+	/* can't add single mode to any other interfaces. */
+	if ((total > 1) && (chanmode == CHAN_MODE_SINGLE_ONLY))
+		return -EBUSY;
+
 	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
 		const struct ieee80211_iface_combination *c;
 		struct ieee80211_iface_limit *limits;
-- 
1.7.10.4

