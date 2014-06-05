Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaFELxv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 07:53:51 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com,
	Matthias Fend <Matthias.Fend@wolfvision.net>
Subject: [PATCH 3/5] rt2x00: change default MAC_BSSID_DW1_BSS_BCN_NUM
Date: Thu,  5 Jun 2014 13:52:25 +0200
Message-Id: <1401969147-3532-3-git-send-email-sgruszka@redhat.com> (sfid-20140605_135354_965685_A4768D94)
In-Reply-To: <1401969147-3532-1-git-send-email-sgruszka@redhat.com>
References: <1401969147-3532-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We setup MAC_BSSID_DW1_BSS_BCN_NUM dynamically when numbers of active
beacons increase. Change default to 0 to tell hardware that we want to
send only one beacon as default.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c45b2d3..a9cdddd 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1601,7 +1601,7 @@ void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
 		if (!is_zero_ether_addr((const u8 *)conf->bssid)) {
 			reg = le32_to_cpu(conf->bssid[1]);
 			rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_ID_MASK, 3);
-			rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_BCN_NUM, 7);
+			rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_BCN_NUM, 0);
 			conf->bssid[1] = cpu_to_le32(reg);
 		}
 
-- 
1.8.3.1

