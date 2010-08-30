Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42497 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab0H3TQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 15:16:33 -0400
Received: by mail-ey0-f174.google.com with SMTP id 5so3422616eyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 12:16:32 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/10] rt2x00: Don't set unicast/BSSID masks when clearning MAC or BSSID
Date: Mon, 30 Aug 2010 21:14:15 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008302112.25578.IvDoorn@gmail.com> <201008302113.31006.IvDoorn@gmail.com> <201008302113.55101.IvDoorn@gmail.com>
In-Reply-To: <201008302113.55101.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008302114.16125.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When configuring the MAC_ADDR or MAC_BSSID with an empty address,
the UNICAST_TO_ME_MASK and BSS_ID_MASK must also be reset to prevent
invalid interpretation of the addresses.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1bc7f49..27a6e22 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1135,19 +1135,23 @@ void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
 	}
 
 	if (flags & CONFIG_UPDATE_MAC) {
-		reg = le32_to_cpu(conf->mac[1]);
-		rt2x00_set_field32(&reg, MAC_ADDR_DW1_UNICAST_TO_ME_MASK, 0xff);
-		conf->mac[1] = cpu_to_le32(reg);
+		if (!is_zero_ether_addr((const u8 *)conf->mac)) {
+			reg = le32_to_cpu(conf->mac[1]);
+			rt2x00_set_field32(&reg, MAC_ADDR_DW1_UNICAST_TO_ME_MASK, 0xff);
+			conf->mac[1] = cpu_to_le32(reg);
+		}
 
 		rt2800_register_multiwrite(rt2x00dev, MAC_ADDR_DW0,
 					      conf->mac, sizeof(conf->mac));
 	}
 
 	if (flags & CONFIG_UPDATE_BSSID) {
-		reg = le32_to_cpu(conf->bssid[1]);
-		rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_ID_MASK, 3);
-		rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_BCN_NUM, 7);
-		conf->bssid[1] = cpu_to_le32(reg);
+		if (!is_zero_ether_addr((const u8 *)conf->bssid)) {
+			reg = le32_to_cpu(conf->bssid[1]);
+			rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_ID_MASK, 3);
+			rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_BCN_NUM, 7);
+			conf->bssid[1] = cpu_to_le32(reg);
+		}
 
 		rt2800_register_multiwrite(rt2x00dev, MAC_BSSID_DW0,
 					      conf->bssid, sizeof(conf->bssid));
-- 
1.7.2.2

