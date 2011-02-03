Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43088 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab1BCVxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 16:53:01 -0500
Received: by wwa36 with SMTP id 36so1702264wwa.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Feb 2011 13:52:59 -0800 (PST)
Message-Id: <f65439b7f2e5843eb18b7880ba64adb959b87c11.1296769444.git.chunkeey@googlemail.com>
In-Reply-To: <cb1597685120e228d2c66a7eafc07aed1466f7dd.1296769444.git.chunkeey@googlemail.com>
References: <cb1597685120e228d2c66a7eafc07aed1466f7dd.1296769444.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Thu, 3 Feb 2011 22:30:05 +0100
Subject: [RFT/RFC] carl9170: export HW random number generator
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All AR9170 hardware have a 16-Bit random number generator.
The documentation claims the values are suitable for
"security keys".

This is an early, but working version. The "throughput" is
around 320Kibit/s. It's slow, but it will work without
introducing any special offload firmware commands.

rngtest 2-unofficial-mt.13

rngtest: starting FIPS tests...
rngtest: bits received from input: 514064384
rngtest: FIPS 140-2 successes: 25688
rngtest: FIPS 140-2 failures: 15
rngtest: FIPS 140-2(2001-10-10) Monobit: 3
rngtest: FIPS 140-2(2001-10-10) Poker: 3
rngtest: FIPS 140-2(2001-10-10) Runs: 9
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=23.495; avg=324.541; max=434.021)Kibits/s
rngtest: FIPS tests speed: (min=6.019; avg=39.985; max=113.533)Mibits/s

SECURITY WARNING: It's relatively easy to eavesdrop all
generated random numbers from the transport stream with
usbmon [software] or special usb sniffer hardware.

---
 drivers/net/wireless/ath/carl9170/Kconfig        |   15 +++
 drivers/net/wireless/ath/carl9170/carl9170.h     |   12 +++
 drivers/net/wireless/ath/carl9170/main.c         |  110 ++++++++++++++++++++++
 3 files changed, 137 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/carl9170/Module.symvers

diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
index 2d1b821..61ed56e 100644
--- a/drivers/net/wireless/ath/carl9170/Kconfig
+++ b/drivers/net/wireless/ath/carl9170/Kconfig
@@ -39,3 +39,18 @@ config CARL9170_WPC
 	bool
 	depends on CARL9170 && (INPUT = y || INPUT = CARL9170)
 	default y
+
+config CARL9170_HWRNG
+        bool
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
+	  other rng source and you can afford the risk.
+
diff --git a/drivers/net/wireless/ath/carl9170/Module.symvers b/drivers/net/wireless/ath/carl9170/Module.symvers
new file mode 100644
index 0000000..e69de29
diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 420d437..321f4d6 100644
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
@@ -431,6 +432,17 @@ struct ar9170 {
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
index ede3d7e..d26e79c 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1416,6 +1416,110 @@ static int carl9170_register_wps_button(struct ar9170 *ar)
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
+	if (ar->rng.cache_idx >= ARRAY_SIZE(ar->rng.cache)) {
+		mutex_lock(&ar->mutex);
+		ret = carl9170_rng_get(ar);
+		mutex_unlock(&ar->mutex);
+		if (ret)
+			return ret;
+	}
+
+	*data = ar->rng.cache[ar->rng.cache_idx++];
+	return sizeof(u16);
+}
+#endif /* CONFIG_CARL9170_HWRNG */
+
+static void carl9170_unregister_hwrng(struct ar9170 *ar)
+{
+#ifdef CONFIG_CARL9170_HWRNG
+	if (ar->rng.initialized) {
+		hwrng_unregister(&ar->rng.rng);
+		ar->rng.initialized = false;
+	}
+#endif /* CONFIG_CARL9170_HWRNG */
+}
+
+static int carl9170_register_hwrng(struct ar9170 *ar)
+{
+#ifdef CONFIG_CARL9170_HWRNG
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
+#endif /* CONFIG_CARL9170_HWRNG */
+	return 0;
+}
+
 static int carl9170_op_get_survey(struct ieee80211_hw *hw, int idx,
 				struct survey_info *survey)
 {
@@ -1861,6 +1965,10 @@ int carl9170_register(struct ar9170 *ar)
 		goto err_unreg;
 #endif /* CONFIG_CARL9170_WPC */
 
+	err = carl9170_register_hwrng(ar);
+	if (err)
+		goto err_unreg;
+
 	dev_info(&ar->udev->dev, "Atheros AR9170 is registered as '%s'\n",
 		 wiphy_name(ar->hw->wiphy));
 
@@ -1893,6 +2001,8 @@ void carl9170_unregister(struct ar9170 *ar)
 	}
 #endif /* CONFIG_CARL9170_WPC */
 
+	carl9170_unregister_hwrng(ar);
+
 	carl9170_cancel_worker(ar);
 	cancel_work_sync(&ar->restart_work);
 
-- 
1.7.2.3

