Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54021 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3AZVgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 16:36:44 -0500
Received: by mail-ea0-f174.google.com with SMTP id 1so661212eaa.33
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2013 13:36:43 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 26 Jan 2013 22:19:35 +0100
Subject: [PATCH 1/2] iwlegacy: fix antenna bitmask
To: linux-wireless@vger.kernel.org
Cc: sgruszka@redhat.com, John Linville <linville@tuxdriver.com>
Message-Id: <E1TzDQW-0001Fa-7P@debian64.localnet> (sfid-20130126_223655_471845_37ABF5A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is based on "iwlwifi: fix antenna bitmask".
(362b0563b28506d53)

Like the new iwlagn devices, the old 4965N device only
supports a maximum of three antennas. Hence only three
bits are used, the fourth bit is likely the A-MPDU
indicator.

Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/iwlegacy/commands.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/commands.h b/drivers/net/wireless/iwlegacy/commands.h
index 25dd7d2..829d3b9 100644
--- a/drivers/net/wireless/iwlegacy/commands.h
+++ b/drivers/net/wireless/iwlegacy/commands.h
@@ -1134,7 +1134,7 @@ struct il_wep_cmd {
 #define RX_RES_PHY_FLAGS_MOD_CCK_MSK		cpu_to_le16(1 << 1)
 #define RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	cpu_to_le16(1 << 2)
 #define RX_RES_PHY_FLAGS_NARROW_BAND_MSK	cpu_to_le16(1 << 3)
-#define RX_RES_PHY_FLAGS_ANTENNA_MSK		0xf0
+#define RX_RES_PHY_FLAGS_ANTENNA_MSK		0x70
 #define RX_RES_PHY_FLAGS_ANTENNA_POS		4
 
 #define RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
-- 
1.7.10.4

