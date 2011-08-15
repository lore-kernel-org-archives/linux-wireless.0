Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58149 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab1HSVKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 17:10:34 -0400
Received: by fxh19 with SMTP id 19so2180780fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2011 14:10:33 -0700 (PDT)
Message-Id: <8927a89ec022cf3f5bd2f64376e8de82d0a83713.1313434481.git.chunkeey@googlemail.com> (sfid-20110819_231039_943387_57D73BF3)
In-Reply-To: <dcc36e33e308c55be6bd980d09735a0a1f9759f3.1313434481.git.chunkeey@googlemail.com>
References: <2de58131999ccc3a6d8f048c5ccbbeaec8f8eec9.1313434481.git.chunkeey@googlemail.com>
	<75dddcb57243e0a2a1a2676444f19746b9c19072.1313434481.git.chunkeey@googlemail.com>
	<dcc36e33e308c55be6bd980d09735a0a1f9759f3.1313434481.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 15 Aug 2011 20:09:54 +0200
Subject: [PATCH 4/4] carl9170: export HW random number generator
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All AR9170 hardware have a 16-Bit random number generator.
The documentation claims the values are suitable for
"security keys".

The "throughput" is around 320Kibit/s. It's slow, but it
does work without introducing any special offload
firmware commands.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/Kconfig    |   15 ++++
 drivers/net/wireless/ath/carl9170/carl9170.h |   12 +++
 drivers/net/wireless/ath/carl9170/main.c     |  113 ++++++++++++++++++++++++++
 3 files changed, 140 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
index 2d1b821..0d0b197 100644
--- a/drivers/net/wireless/ath/carl9170/Kconfig
+++ b/drivers/net/wireless/ath/carl9170/Kconfig
@@ -39,3 +39,17 @@ config CARL9170_WPC
 	bool
 	depends on CARL9170 && (INPUT = y || INPUT = CARL9170)
 	default y
+
+config CARL9170_HWRNG
+        bool "Random number generator"
+        depends on CARL9170 && (HW_RANDOM = y || HW_RANDOM = CARL9170)
+        default n
+	help
+	  Provides a hardware random number generator to the kernel.
+
+	  SECURITY WARNING: It's relatively easy to eavesdrop all
+	  generated random numbers from the transport stream with
+	  usbmon [software] or special usb sniffer hardware.
+
+	  Say N, unless your setup[i.e.: embedded system] has no
+	  other rng source and you can afford to take the risk.
diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 74350d6..6cfbb41 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -43,6 +43,7 @@
 #include <linux/firmware.h>
 #include <linux/completion.h>
 #include <linux/spinlock.h>
+#include <linux/hw_random.h>
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
 #include <linux/usb.h>
@@ -449,6 +450,17 @@ struct ar9170 {
 		unsigned int off_override;
 		bool state;
 	} ps;
+
+#ifdef CONFIG_CARL9170_HWRNG
+# define CARL9170_HWRNG_CACHE_SIZE	CARL9170_MAX_CMD_PAYLOAD_LEN
+	struct {
+		struct hwrng rng;
+		bool initialized;
+		char name[30 + 1];
+		u16 cache[CARL9170_HWRNG_CACHE_SIZE / sizeof(u16)];
+		unsigned int cache_idx;
+	} rng;
+#endif /* CONFIG_CARL9170_HWRNG */
 };
 
 enum carl9170_ps_off_override_reasons {
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 85cb1bd..782b8f3 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1468,6 +1468,109 @@ static int carl9170_register_wps_button(struct ar9170 *ar)
 }
 #endif /* CONFIG_CARL9170_WPC */
 
+#ifdef CONFIG_CARL9170_HWRNG
+static int carl9170_rng_get(struct ar9170 *ar)
+{
+
+#define RW	(CARL9170_MAX_CMD_PAYLOAD_LEN / sizeof(u32))
+#define RB	(CARL9170_MAX_CMD_PAYLOAD_LEN)
+
+	static const __le32 rng_load[RW] = {
+		[0 ... (RW - 1)] = cpu_to_le32(AR9170_RAND_REG_NUM)};
+
+	u32 buf[RW];
+
+	unsigned int i, off = 0, transfer, count;
+	int err;
+
+	BUILD_BUG_ON(RB > CARL9170_MAX_CMD_PAYLOAD_LEN);
+
+	if (!IS_ACCEPTING_CMD(ar) || !ar->rng.initialized)
+		return -EAGAIN;
+
+	count = ARRAY_SIZE(ar->rng.cache);
+	while (count) {
+		err = carl9170_exec_cmd(ar, CARL9170_CMD_RREG,
+					RB, (u8 *) rng_load,
+					RB, (u8 *) buf);
+		if (err)
+			return err;
+
+		transfer = min_t(unsigned int, count, RW);
+		for (i = 0; i < transfer; i++)
+			ar->rng.cache[off + i] = buf[i];
+
+		off += transfer;
+		count -= transfer;
+	}
+
+	ar->rng.cache_idx = 0;
+
+#undef RW
+#undef RB
+	return 0;
+}
+
+static int carl9170_rng_read(struct hwrng *rng, u32 *data)
+{
+	struct ar9170 *ar = (struct ar9170 *)rng->priv;
+	int ret = -EIO;
+
+	mutex_lock(&ar->mutex);
+	if (ar->rng.cache_idx >= ARRAY_SIZE(ar->rng.cache)) {
+		ret = carl9170_rng_get(ar);
+		if (ret) {
+			mutex_unlock(&ar->mutex);
+			return ret;
+		}
+	}
+
+	*data = ar->rng.cache[ar->rng.cache_idx++];
+	mutex_unlock(&ar->mutex);
+
+	return sizeof(u16);
+}
+
+static void carl9170_unregister_hwrng(struct ar9170 *ar)
+{
+	if (ar->rng.initialized) {
+		hwrng_unregister(&ar->rng.rng);
+		ar->rng.initialized = false;
+	}
+}
+
+static int carl9170_register_hwrng(struct ar9170 *ar)
+{
+	int err;
+
+	snprintf(ar->rng.name, ARRAY_SIZE(ar->rng.name),
+		 "%s_%s", KBUILD_MODNAME, wiphy_name(ar->hw->wiphy));
+	ar->rng.rng.name = ar->rng.name;
+	ar->rng.rng.data_read = carl9170_rng_read;
+	ar->rng.rng.priv = (unsigned long)ar;
+
+	if (WARN_ON(ar->rng.initialized))
+		return -EALREADY;
+
+	err = hwrng_register(&ar->rng.rng);
+	if (err) {
+		dev_err(&ar->udev->dev, "Failed to register the random "
+			"number generator (%d)\n", err);
+		return err;
+	}
+
+	ar->rng.initialized = true;
+
+	err = carl9170_rng_get(ar);
+	if (err) {
+		carl9170_unregister_hwrng(ar);
+		return err;
+	}
+
+	return 0;
+}
+#endif /* CONFIG_CARL9170_HWRNG */
+
 static int carl9170_op_get_survey(struct ieee80211_hw *hw, int idx,
 				struct survey_info *survey)
 {
@@ -1878,6 +1981,12 @@ int carl9170_register(struct ar9170 *ar)
 		goto err_unreg;
 #endif /* CONFIG_CARL9170_WPC */
 
+#ifdef CONFIG_CARL9170_HWRNG
+	err = carl9170_register_hwrng(ar);
+	if (err)
+		goto err_unreg;
+#endif /* CONFIG_CARL9170_HWRNG */
+
 	dev_info(&ar->udev->dev, "Atheros AR9170 is registered as '%s'\n",
 		 wiphy_name(ar->hw->wiphy));
 
@@ -1910,6 +2019,10 @@ void carl9170_unregister(struct ar9170 *ar)
 	}
 #endif /* CONFIG_CARL9170_WPC */
 
+#ifdef CONFIG_CARL9170_HWRNG
+	carl9170_unregister_hwrng(ar);
+#endif /* CONFIG_CARL9170_HWRNG */
+
 	carl9170_cancel_worker(ar);
 	cancel_work_sync(&ar->restart_work);
 
-- 
1.7.5.4

