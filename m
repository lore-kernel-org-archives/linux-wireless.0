Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:13520 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757637Ab1F2TkH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 15:40:07 -0400
Subject: [PATCH 1/2] ath5k: fix incorrect use of drvdata in sysfs code
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 29 Jun 2011 15:39:37 -0400
Message-ID: <20110629193937.4948.39075.stgit@mj.roinet.com> (sfid-20110629_214010_337619_4148BC69)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
Cc: <stable@kernel.org>
---
 drivers/net/wireless/ath/ath5k/sysfs.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/sysfs.c b/drivers/net/wireless/ath/ath5k/sysfs.c
index 929c68c..a073cdc 100644
--- a/drivers/net/wireless/ath/ath5k/sysfs.c
+++ b/drivers/net/wireless/ath/ath5k/sysfs.c
@@ -10,7 +10,8 @@ static ssize_t ath5k_attr_show_##name(struct device *dev,		\
 			struct device_attribute *attr,			\
 			char *buf)					\
 {									\
-	struct ath5k_softc *sc = dev_get_drvdata(dev);			\
+	struct ieee80211_hw *hw = dev_get_drvdata(dev);			\
+	struct ath5k_softc *sc = hw->priv;				\
 	return snprintf(buf, PAGE_SIZE, "%d\n", get); 			\
 }									\
 									\
@@ -18,7 +19,8 @@ static ssize_t ath5k_attr_store_##name(struct device *dev,		\
 			struct device_attribute *attr,			\
 			const char *buf, size_t count)			\
 {									\
-	struct ath5k_softc *sc = dev_get_drvdata(dev);			\
+	struct ieee80211_hw *hw = dev_get_drvdata(dev);			\
+	struct ath5k_softc *sc = hw->priv;				\
 	int val;							\
 									\
 	val = (int)simple_strtoul(buf, NULL, 10);			\
@@ -33,7 +35,8 @@ static ssize_t ath5k_attr_show_##name(struct device *dev,		\
 			struct device_attribute *attr,			\
 			char *buf)					\
 {									\
-	struct ath5k_softc *sc = dev_get_drvdata(dev);			\
+	struct ieee80211_hw *hw = dev_get_drvdata(dev);			\
+	struct ath5k_softc *sc = hw->priv;				\
 	return snprintf(buf, PAGE_SIZE, "%d\n", get); 			\
 }									\
 static DEVICE_ATTR(name, S_IRUGO, ath5k_attr_show_##name, NULL)
