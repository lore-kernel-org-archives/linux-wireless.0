Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:55080 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbaINVJW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 17:09:22 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/5] b43: tell the ucode the mac capabilities
Date: Sun, 14 Sep 2014 23:09:08 +0200
Message-Id: <1410728952-25779-1-git-send-email-hauke@hauke-m.de> (sfid-20140914_230926_249520_72976149)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is based on code form brcmsmac.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/b43.h  |  3 +++
 drivers/net/wireless/b43/main.c | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 95a9433..018ed5f 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -45,6 +45,7 @@
 #define B43_MMIO_RAM_DATA		0x134
 #define B43_MMIO_PS_STATUS		0x140
 #define B43_MMIO_RADIO_HWENABLED_HI	0x158
+#define B43_MMIO_MAC_HW_CAP		0x15C	/* MAC capabilities (corerev >= 13) */
 #define B43_MMIO_SHM_CONTROL		0x160
 #define B43_MMIO_SHM_DATA		0x164
 #define B43_MMIO_SHM_DATA_UNALIGNED	0x166
@@ -253,6 +254,8 @@ enum {
 #define B43_SHM_SH_CHAN			0x00A0	/* Current channel (low 8bit only) */
 #define  B43_SHM_SH_CHAN_5GHZ		0x0100	/* Bit set, if 5 Ghz channel */
 #define  B43_SHM_SH_CHAN_40MHZ		0x0200	/* Bit set, if 40 Mhz channel width */
+#define B43_SHM_SH_MACHW_L		0x00C0	/* Location where the ucode expects the MAC capabilities */
+#define B43_SHM_SH_MACHW_H		0x00C2	/* Location where the ucode expects the MAC capabilities */
 #define B43_SHM_SH_HOSTF5		0x00D4	/* Hostflags 5 for ucode options */
 #define B43_SHM_SH_BCMCFIFOID		0x0108	/* Last posted cookie to the bcast/mcast FIFO */
 /* TSSI information */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 165dbc3..f22a801 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4827,6 +4827,16 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	hf &= ~B43_HF_SKCFPUP;
 	b43_hf_write(dev, hf);
 
+	/* tell the ucode MAC capabilities */
+	if (dev->dev->core_rev >= 13) {
+		u32 mac_hw_cap = b43_read32(dev, B43_MMIO_MAC_HW_CAP);
+
+		b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_MACHW_L,
+				mac_hw_cap & 0xffff);
+		b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_MACHW_H,
+				(mac_hw_cap >> 16) & 0xffff);
+	}
+
 	b43_set_retry_limits(dev, B43_DEFAULT_SHORT_RETRY_LIMIT,
 			     B43_DEFAULT_LONG_RETRY_LIMIT);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_SFFBLIM, 3);
-- 
1.9.1

