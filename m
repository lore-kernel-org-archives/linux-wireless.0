Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35507 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbcHMDAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 23:00:22 -0400
Received: by mail-pf0-f180.google.com with SMTP id x72so1408717pfd.2
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2016 20:00:22 -0700 (PDT)
From: Petri Gynther <pgynther@google.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, davem@davemloft.net, joe@perches.com,
	akarwar@marvell.com, Petri Gynther <pgynther@google.com>
Subject: [PATCH 2/2] mwifiex: fix unaligned read in mwifiex_config_scan()
Date: Fri, 12 Aug 2016 20:00:00 -0700
Message-Id: <1471057200-58166-2-git-send-email-pgynther@google.com> (sfid-20160813_050050_931021_121D22E8)
In-Reply-To: <1471057200-58166-1-git-send-email-pgynther@google.com>
References: <1471057200-58166-1-git-send-email-pgynther@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

$ iwconfig mlan0 essid MySSID
[   36.930000] Path: /sbin/iwconfig
[   36.930000] CPU: 0 PID: 203 Comm: iwconfig Not tainted 4.7.0 #2
[   36.940000] task: 866f83a0 ti: 866a6000 task.ti: 866a6000
[   36.940000]
[ECR   ]: 0x00230400 => Misaligned r/w from 0x8677f403
[   36.960000] [EFA   ]: 0x8677f403
[   36.960000] [BLINK ]: mwifiex_scan_networks+0x17a/0x198c [mwifiex]
[   36.960000] [ERET  ]: mwifiex_scan_networks+0x18a/0x198c [mwifiex]
[   36.980000] [STAT32]: 0x00000206 : K         E2 E1
[   36.980000] BTA: 0x700736e2   SP: 0x866a7d0c  FP: 0x5faddc84
[   37.000000] LPS: 0x806a37ec  LPE: 0x806a37fa LPC: 0x00000000
[   37.000000] r00: 0x8677f401  r01: 0x8668aa08 r02: 0x00000001
r03: 0x00000000 r04: 0x8668b600 r05: 0x8677f406
r06: 0x8702b600 r07: 0x00000000 r08: 0x8702b600
r09: 0x00000000 r10: 0x870b3b00 r11: 0x00000000
r12: 0x00000000
[   37.040000]
[   37.040000] Stack Trace:
[   37.040000]   mwifiex_scan_networks+0x18a/0x198c [mwifiex]

Root cause:
mwifiex driver calls is_zero_ether_addr() against byte-aligned address:

drivers/net/wireless/marvell/mwifiex/fw.h:
struct mwifiex_scan_cmd_config {
        /*
         *  BSS mode to be sent in the firmware command
         */
        u8 bss_mode;

        /* Specific BSSID used to filter scan results in the firmware */
        u8 specific_bssid[ETH_ALEN];

        ...
} __packed;

drivers/net/wireless/marvell/mwifiex/scan.c:
mwifiex_config_scan(..., struct mwifiex_scan_cmd_config *scan_cfg_out, ...)
        ...
        if (adapter->ext_scan &&
            !is_zero_ether_addr(scan_cfg_out->specific_bssid)) {
            ...
        }

Since firmware-related struct mwifiex_scan_cmd_config cannot be changed,
we need to use the new function is_zero_ether_addr_unaligned() here.

This is v2 of the original patch:
[PATCH] Modify is_zero_ether_addr() to handle byte-aligned addresses

Per Joe's suggestion -- instead of modifying is_zero_ether_addr() --
add is_zero_ether_addr_unaligned() and use it where needed.

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Joe Perches <joe@perches.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Petri Gynther <pgynther@google.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index bc5e52c..d648c88 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -883,7 +883,8 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 		       sizeof(scan_cfg_out->specific_bssid));
 
 		if (adapter->ext_scan &&
-		    !is_zero_ether_addr(scan_cfg_out->specific_bssid)) {
+		    !is_zero_ether_addr_unaligned(
+				scan_cfg_out->specific_bssid)) {
 			bssid_tlv =
 				(struct mwifiex_ie_types_bssid_list *)tlv_pos;
 			bssid_tlv->header.type = cpu_to_le16(TLV_TYPE_BSSID);
-- 
2.8.0.rc3.226.g39d4020

