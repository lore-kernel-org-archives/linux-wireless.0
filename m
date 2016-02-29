Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 017/113] rtl8xxxu: Add rtl8723bu_radioa_1t_init_table
Date: Mon, 29 Feb 2016 17:04:15 -0500
Message-Id: <1456783551-28315-18-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230602_965806_8FD2C0D2)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Add 8723bu 1T radio init table. The vendor driver indicates that some
registers need special treatment for TFBGA90, TFBGA80, and TFBGA79
packaging. However the vendor driver never actually checks the package
type, so just stick to default values here.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 78 ++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  6 +-
 2 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 88af2e8..2979a5e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -792,6 +792,75 @@ static struct rtl8xxxu_rfregval rtl8723au_radioa_1t_init_table[] = {
 	{0xff, 0xffffffff}
 };
 
+static struct rtl8xxxu_rfregval rtl8723bu_radioa_1t_init_table[] = {
+	{0x00, 0x00010000}, {0xb0, 0x000dffe0},
+	{0xfe, 0x00000000}, {0xfe, 0x00000000},
+	{0xfe, 0x00000000}, {0xb1, 0x00000018},
+	{0xfe, 0x00000000}, {0xfe, 0x00000000},
+	{0xfe, 0x00000000}, {0xb2, 0x00084c00},
+	{0xb5, 0x0000d2cc}, {0xb6, 0x000925aa},
+	{0xb7, 0x00000010}, {0xb8, 0x0000907f},
+	{0x5c, 0x00000002}, {0x7c, 0x00000002},
+	{0x7e, 0x00000005}, {0x8b, 0x0006fc00},
+	{0xb0, 0x000ff9f0}, {0x1c, 0x000739d2},
+	{0x1e, 0x00000000}, {0xdf, 0x00000780},
+	{0x50, 0x00067435},
+	/*
+	 * The 8723bu vendor driver indicates that bit 8 should be set in
+	 * 0x51 for package types TFBGA90, TFBGA80, and TFBGA79. However
+	 * they never actually check the package type - and just default
+	 * to not setting it.
+	 */
+	{0x51, 0x0006b04e},
+	{0x52, 0x000007d2}, {0x53, 0x00000000},
+	{0x54, 0x00050400}, {0x55, 0x0004026e},
+	{0xdd, 0x0000004c}, {0x70, 0x00067435},
+	/*
+	 * 0x71 has same package type condition as for register 0x51
+	 */
+	{0x71, 0x0006b04e},
+	{0x72, 0x000007d2}, {0x73, 0x00000000},
+	{0x74, 0x00050400}, {0x75, 0x0004026e},
+	{0xef, 0x00000100}, {0x34, 0x0000add7},
+	{0x35, 0x00005c00}, {0x34, 0x00009dd4},
+	{0x35, 0x00005000}, {0x34, 0x00008dd1},
+	{0x35, 0x00004400}, {0x34, 0x00007dce},
+	{0x35, 0x00003800}, {0x34, 0x00006cd1},
+	{0x35, 0x00004400}, {0x34, 0x00005cce},
+	{0x35, 0x00003800}, {0x34, 0x000048ce},
+	{0x35, 0x00004400}, {0x34, 0x000034ce},
+	{0x35, 0x00003800}, {0x34, 0x00002451},
+	{0x35, 0x00004400}, {0x34, 0x0000144e},
+	{0x35, 0x00003800}, {0x34, 0x00000051},
+	{0x35, 0x00004400}, {0xef, 0x00000000},
+	{0xef, 0x00000100}, {0xed, 0x00000010},
+	{0x44, 0x0000add7}, {0x44, 0x00009dd4},
+	{0x44, 0x00008dd1}, {0x44, 0x00007dce},
+	{0x44, 0x00006cc1}, {0x44, 0x00005cce},
+	{0x44, 0x000044d1}, {0x44, 0x000034ce},
+	{0x44, 0x00002451}, {0x44, 0x0000144e},
+	{0x44, 0x00000051}, {0xef, 0x00000000},
+	{0xed, 0x00000000}, {0x7f, 0x00020080},
+	{0xef, 0x00002000}, {0x3b, 0x000380ef},
+	{0x3b, 0x000302fe}, {0x3b, 0x00028ce6},
+	{0x3b, 0x000200bc}, {0x3b, 0x000188a5},
+	{0x3b, 0x00010fbc}, {0x3b, 0x00008f71},
+	{0x3b, 0x00000900}, {0xef, 0x00000000},
+	{0xed, 0x00000001}, {0x40, 0x000380ef},
+	{0x40, 0x000302fe}, {0x40, 0x00028ce6},
+	{0x40, 0x000200bc}, {0x40, 0x000188a5},
+	{0x40, 0x00010fbc}, {0x40, 0x00008f71},
+	{0x40, 0x00000900}, {0xed, 0x00000000},
+	{0x82, 0x00080000}, {0x83, 0x00008000},
+	{0x84, 0x00048d80}, {0x85, 0x00068000},
+	{0xa2, 0x00080000}, {0xa3, 0x00008000},
+	{0xa4, 0x00048d80}, {0xa5, 0x00068000},
+	{0xed, 0x00000002}, {0xef, 0x00000002},
+	{0x56, 0x00000032}, {0x76, 0x00000032},
+	{0x01, 0x00000780},
+	{0xff, 0xffffffff}
+};
+
 static struct rtl8xxxu_rfregval rtl8192cu_radioa_2t_init_table[] = {
 	{0x00, 0x00030159}, {0x01, 0x00031284},
 	{0x02, 0x00098000}, {0x03, 0x00018c63},
@@ -1270,6 +1339,11 @@ static u32 rtl8xxxu_read_rfreg(struct rtl8xxxu_priv *priv,
 	return retval;
 }
 
+/*
+ * The RTL8723BU driver indicates that registers 0xb2 and 0xb6 can
+ * have write issues in high temperature conditions. We may have to
+ * retry writing them.
+ */
 static int rtl8xxxu_write_rfreg(struct rtl8xxxu_priv *priv,
 				enum rtl8xxxu_rfpath path, u8 reg, u32 data)
 {
@@ -4562,6 +4636,10 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		rftable = rtl8723au_radioa_1t_init_table;
 		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
 		break;
+	case 0x8723b:
+		rftable = rtl8723bu_radioa_1t_init_table;
+		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
+		break;
 	case 0x8188c:
 		if (priv->hi_pa)
 			rftable = rtl8188ru_radioa_1t_highpa_table;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 2055048..326fda5 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -537,8 +537,10 @@ struct rtl8723bu_efuse {
 	u8 res9[2];
 	u8 vendor_name[0x07];
 	u8 res10[2];
-	u8 device_name[0x14];		/* 0xe8 */
-	u8 res11[0xd4];
+	u8 device_name[0x14];
+	u8 res11[0xcf];
+	u8 package_type;		/* 0x1fb */
+	u8 res12[0x4];
 };
 
 struct rtl8192eu_efuse {
-- 
2.5.0

