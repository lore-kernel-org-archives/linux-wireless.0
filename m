Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35525 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbbJTGqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 02:46:30 -0400
Received: by lffy185 with SMTP id y185so720673lff.2
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 23:46:28 -0700 (PDT)
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes.Sorensen@redhat.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [RFC 12/16] rtl8xxxu: Prepare to have more than one kind of struct *_tx_power
Date: Tue, 20 Oct 2015 08:45:42 +0200
Message-Id: <1445323546-12807-13-git-send-email-jsitnicki@gmail.com> (sfid-20151020_084635_723330_B5146FDB)
In-Reply-To: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparatory step for adding support for RTL8188EU chips. We follow the
same approach as with efuse here.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index a7d172a..83cdc2a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1490,7 +1490,7 @@ static void rtl8723au_config_channel(struct ieee80211_hw *hw)
 static void
 rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 {
-	struct rtl8723au_tx_power *tx_power = &priv->tx_power;
+	struct rtl8723au_tx_power *tx_power = &priv->tx_power.tx_power8723;
 	u8 cck[RTL8723A_MAX_RF_PATHS], ofdm[RTL8723A_MAX_RF_PATHS];
 	u8 ofdmbase[RTL8723A_MAX_RF_PATHS], mcsbase[RTL8723A_MAX_RF_PATHS];
 	u32 val32, ofdm_a, ofdm_b, mcs_a, mcs_b;
@@ -1781,7 +1781,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 static int rtl8723au_parse_efuse(struct rtl8xxxu_priv *priv)
 {
 	struct rtl8723au_efuse *efuse = &priv->efuse_wifi.efuse8723;
-	struct rtl8723au_tx_power *tx_power = &priv->tx_power;
+	struct rtl8723au_tx_power *tx_power = &priv->tx_power.tx_power8723;
 
 	if (efuse->rtl_id != cpu_to_le16(0x8129))
 		return -EINVAL;
@@ -1826,7 +1826,7 @@ static int rtl8723au_parse_efuse(struct rtl8xxxu_priv *priv)
 static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
 {
 	struct rtl8192cu_efuse *efuse = &priv->efuse_wifi.efuse8192;
-	struct rtl8723au_tx_power *tx_power = &priv->tx_power;
+	struct rtl8723au_tx_power *tx_power = &priv->tx_power.tx_power8723;
 	int i;
 
 	if (efuse->rtl_id != cpu_to_le16(0x8129))
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index ccfbc10..1a767eb 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -598,7 +598,9 @@ struct rtl8xxxu_priv {
 
 	u8 mac_addr[ETH_ALEN];
 	char chip_name[8];
-	struct rtl8723au_tx_power tx_power;
+	union {
+		struct rtl8723au_tx_power tx_power8723;
+	} tx_power;
 	u32 chip_cut:4;
 	u32 rom_rev:4;
 	u32 is_multi_func:1;
-- 
2.1.0

