Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:44374 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754372Ab2APOXm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 09:23:42 -0500
Received: by mail-lpp01m010-f54.google.com with SMTP id d3so2975715lah.27
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2012 06:23:41 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 2/2] wl12xx: add operation to retrieve the MAC address from Fuse ROM
Date: Mon, 16 Jan 2012 16:23:26 +0200
Message-Id: <1326723806-15960-3-git-send-email-coelho@ti.com> (sfid-20120116_152344_868447_23969A3E)
In-Reply-To: <1326723806-15960-1-git-send-email-coelho@ti.com>
References: <1326723806-15960-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a testmode command to retrieve the MAC address that is stored in
the Fuse ROM in newer PGs.  In old PGs this operation is not
supported.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c     |    3 +-
 drivers/net/wireless/wl12xx/boot.h     |   10 ----
 drivers/net/wireless/wl12xx/reg.h      |   15 ++++++
 drivers/net/wireless/wl12xx/testmode.c |   87 ++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 9197a07..8c46182 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -639,7 +639,8 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 	u32 pause;
 	u32 clk;
 
-	if (((wl->hw_pg_ver & PG_MAJOR_VER_MASK) >> PG_MAJOR_VER_OFFSET) < 3)
+	if (((wl->hw_pg_ver &
+	      WL127X_PG_MAJOR_VER_MASK) >> WL127X_PG_MAJOR_VER_OFFSET) < 3)
 		wl->quirks |= WL12XX_QUIRK_END_OF_TRANSACTION;
 
 	if (wl->ref_clock == CONF_REF_CLK_19_2_E ||
diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
index 06dad93..c3adc09 100644
--- a/drivers/net/wireless/wl12xx/boot.h
+++ b/drivers/net/wireless/wl12xx/boot.h
@@ -55,16 +55,6 @@ struct wl1271_static_data {
 #define OCP_REG_CLK_POLARITY 0x0cb2
 #define OCP_REG_CLK_PULL     0x0cb4
 
-#define WL127X_REG_FUSE_DATA_2_1    0x050a
-#define WL128X_REG_FUSE_DATA_2_1    0x2152
-#define PG_VER_MASK          0x3c
-#define PG_VER_OFFSET        2
-
-#define PG_MAJOR_VER_MASK    0x3
-#define PG_MAJOR_VER_OFFSET  0x0
-#define PG_MINOR_VER_MASK    0xc
-#define PG_MINOR_VER_OFFSET  0x2
-
 #define CMD_MBOX_ADDRESS     0x407B4
 
 #define POLARITY_LOW         BIT(1)
diff --git a/drivers/net/wireless/wl12xx/reg.h b/drivers/net/wireless/wl12xx/reg.h
index df34d59..d649bf5 100644
--- a/drivers/net/wireless/wl12xx/reg.h
+++ b/drivers/net/wireless/wl12xx/reg.h
@@ -525,4 +525,19 @@ b12-b0 - Supported Rate indicator bits as defined below.
  */
 #define INTR_TRIG_TX_PROC1 BIT(18)
 
+#define WL127X_REG_FUSE_DATA_2_1    0x050a
+#define WL128X_REG_FUSE_DATA_2_1    0x2152
+#define PG_VER_MASK          0x3c
+#define PG_VER_OFFSET        2
+
+#define WL127X_PG_MAJOR_VER_MASK    0x3
+#define WL127X_PG_MAJOR_VER_OFFSET  0x0
+#define WL127X_PG_MINOR_VER_MASK    0xc
+#define WL127X_PG_MINOR_VER_OFFSET  0x2
+
+#define WL128X_PG_MAJOR_VER_MASK    0xc
+#define WL128X_PG_MAJOR_VER_OFFSET  0x2
+#define WL128X_PG_MINOR_VER_MASK    0x3
+#define WL128X_PG_MINOR_VER_OFFSET  0x0
+
 #endif
diff --git a/drivers/net/wireless/wl12xx/testmode.c b/drivers/net/wireless/wl12xx/testmode.c
index 25093c0..613e0b3 100644
--- a/drivers/net/wireless/wl12xx/testmode.c
+++ b/drivers/net/wireless/wl12xx/testmode.c
@@ -30,6 +30,7 @@
 #include "acx.h"
 #include "reg.h"
 #include "ps.h"
+#include "io.h"
 
 #define WL1271_TM_MAX_DATA_LENGTH 1024
 
@@ -41,6 +42,7 @@ enum wl1271_tm_commands {
 	WL1271_TM_CMD_NVS_PUSH,		/* Not in use. Keep to not break ABI */
 	WL1271_TM_CMD_SET_PLT_MODE,
 	WL1271_TM_CMD_RECOVER,
+	WL1271_TM_CMD_GET_MAC,
 
 	__WL1271_TM_CMD_AFTER_LAST
 };
@@ -264,6 +266,89 @@ static int wl1271_tm_cmd_recover(struct wl1271 *wl, struct nlattr *tb[])
 	return 0;
 }
 
+static bool wl12xx_tm_mac_in_fuse(struct wl1271 *wl)
+{
+	bool supported = false;
+	u8 major, minor;
+
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		major = (wl->hw_pg_ver & WL128X_PG_MAJOR_VER_MASK) >>
+			WL128X_PG_MAJOR_VER_OFFSET;
+		minor = (wl->hw_pg_ver & WL128X_PG_MINOR_VER_MASK) >>
+			WL128X_PG_MINOR_VER_OFFSET;
+
+		/* in wl128x we have the MAC address if the PG is >= (2, 1) */
+		if (major > 2 || (major == 2 && minor >= 1))
+			supported = true;
+	} else {
+		major = (wl->hw_pg_ver & WL127X_PG_MAJOR_VER_MASK) >>
+			WL127X_PG_MAJOR_VER_OFFSET;
+		minor = (wl->hw_pg_ver & WL127X_PG_MINOR_VER_MASK) >>
+			WL127X_PG_MINOR_VER_OFFSET;
+
+		/* in wl127x we have the MAC address if the PG is >= (3, 1) */
+		if (major == 3 && minor >= 1)
+			supported = true;
+	}
+
+	wl1271_debug(DEBUG_TESTMODE,
+		     "PG Ver major = %d minor = %d, MAC %s present",
+		     major, minor, supported ? "is" : "is not");
+
+	return supported;
+}
+
+static int wl12xx_tm_cmd_get_mac(struct wl1271 *wl, struct nlattr *tb[])
+{
+	struct sk_buff *skb;
+	u8 mac_addr[ETH_ALEN];
+	u32 tmp;
+	int ret = 0;
+
+	if (wl->state != WL1271_STATE_PLT) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if(!wl12xx_tm_mac_in_fuse(wl)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	wl1271_set_partition(wl, &part_table[PART_DRPW]);
+
+	tmp = wl1271_read32(wl, 0x00310eb4);
+	mac_addr[2] = (tmp & 0xff000000) >> 24;
+	mac_addr[3] = (tmp & 0xff0000) >> 16;
+	mac_addr[4] = (tmp & 0xff00) >> 8;
+	mac_addr[5] = tmp & 0xff;
+
+	tmp = wl1271_read32(wl, 0x00310eb8);
+	mac_addr[0] = (tmp & 0xff00) >> 8;
+	mac_addr[1] = tmp & 0xff;
+
+	wl1271_set_partition(wl, &part_table[PART_WORK]);
+
+	skb = cfg80211_testmode_alloc_reply_skb(wl->hw->wiphy, sizeof(ETH_ALEN));
+	if (!skb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	NLA_PUT(skb, WL1271_TM_ATTR_DATA, ETH_ALEN, mac_addr);
+	ret = cfg80211_testmode_reply(skb);
+	if (ret < 0)
+		goto out;
+
+out:
+	return ret;
+
+nla_put_failure:
+	kfree_skb(skb);
+	ret = -EMSGSIZE;
+	goto out;
+}
+
 int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len)
 {
 	struct wl1271 *wl = hw->priv;
@@ -288,6 +373,8 @@ int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len)
 		return wl1271_tm_cmd_set_plt_mode(wl, tb);
 	case WL1271_TM_CMD_RECOVER:
 		return wl1271_tm_cmd_recover(wl, tb);
+	case WL1271_TM_CMD_GET_MAC:
+		return wl12xx_tm_cmd_get_mac(wl, tb);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
1.7.4.1

