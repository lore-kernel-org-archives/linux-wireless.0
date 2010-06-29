Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38403 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab0F2TvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:51:10 -0400
Received: by mail-ww0-f46.google.com with SMTP id 18so547wwb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:51:09 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/21] rt2x00: Enable multiBSS in rt2800
Date: Tue, 29 Jun 2010 21:45:31 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292144.19486.IvDoorn@gmail.com> <201006292144.51636.IvDoorn@gmail.com>
In-Reply-To: <201006292144.51636.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292145.32554.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

MAC_BSSID_DW1_BSS_ID_MASK must be set to the mask 3, to
enable 8 BSSID's. The MAC_BSSID_DW1_BSS_BCN_NUM is initialized
to 7 to enable the 8 beacons.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Tested-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f25997e..f7e9e76 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -768,8 +768,8 @@ void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
 
 	if (flags & CONFIG_UPDATE_BSSID) {
 		reg = le32_to_cpu(conf->bssid[1]);
-		rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_ID_MASK, 0);
-		rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_BCN_NUM, 0);
+		rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_ID_MASK, 3);
+		rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_BCN_NUM, 7);
 		conf->bssid[1] = cpu_to_le32(reg);
 
 		rt2800_register_multiwrite(rt2x00dev, MAC_BSSID_DW0,
-- 
1.6.6.1

