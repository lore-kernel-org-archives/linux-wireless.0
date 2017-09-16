Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52862 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbdIPPed (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Sep 2017 11:34:33 -0400
From: Colin King <colin.king@canonical.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: make const arrays static to shink object code size
Date: Sat, 16 Sep 2017 16:34:24 +0100
Message-Id: <20170916153424.28285-1-colin.king@canonical.com> (sfid-20170916_173454_957807_97778C42)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate const arrays on the stack, instead make them static
Makes the object code smaller by nearly 300 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  69260	  16149	    576	  85985	  14fe1	cfg80211.o

After:
   text	   data	    bss	    dec	    hex	filename
  68385	  16725	    576	  85686	  14eb6	cfg80211.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 32c5074da84c..c45b86fcfd8d 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -142,7 +142,7 @@ mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
 			 u8 key_index, bool pairwise, const u8 *mac_addr)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(netdev);
-	const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	static const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	const u8 *peer_mac = pairwise ? mac_addr : bc_mac;
 
 	if (mwifiex_set_encode(priv, NULL, NULL, 0, key_index, peer_mac, 1)) {
@@ -454,7 +454,7 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(netdev);
 	struct mwifiex_wep_key *wep_key;
-	const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	static const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	const u8 *peer_mac = pairwise ? mac_addr : bc_mac;
 
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP &&
@@ -3250,8 +3250,8 @@ static int mwifiex_set_wowlan_mef_entry(struct mwifiex_private *priv,
 	int i, filt_num = 0, ret = 0;
 	bool first_pat = true;
 	u8 byte_seq[MWIFIEX_MEF_MAX_BYTESEQ + 1];
-	const u8 ipv4_mc_mac[] = {0x33, 0x33};
-	const u8 ipv6_mc_mac[] = {0x01, 0x00, 0x5e};
+	static const u8 ipv4_mc_mac[] = {0x33, 0x33};
+	static const u8 ipv6_mc_mac[] = {0x01, 0x00, 0x5e};
 
 	mef_entry->mode = MEF_MODE_HOST_SLEEP;
 	mef_entry->action = MEF_ACTION_ALLOW_AND_WAKEUP_HOST;
@@ -3544,9 +3544,9 @@ static int mwifiex_set_rekey_data(struct wiphy *wiphy, struct net_device *dev,
 
 static int mwifiex_get_coalesce_pkt_type(u8 *byte_seq)
 {
-	const u8 ipv4_mc_mac[] = {0x33, 0x33};
-	const u8 ipv6_mc_mac[] = {0x01, 0x00, 0x5e};
-	const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff};
+	static const u8 ipv4_mc_mac[] = {0x33, 0x33};
+	static const u8 ipv6_mc_mac[] = {0x01, 0x00, 0x5e};
+	static const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff};
 
 	if ((byte_seq[0] & 0x01) &&
 	    (byte_seq[MWIFIEX_COALESCE_MAX_BYTESEQ] == 1))
-- 
2.14.1
