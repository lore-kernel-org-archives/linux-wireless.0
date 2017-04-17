Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:47934 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754919AbdDQTcV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Apr 2017 15:32:21 -0400
Date: Mon, 17 Apr 2017 21:32:12 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 2/2] rt2800: do VCO calibration after programming ALC
Message-ID: <20170417193200.GA3446@makrotopia.org> (sfid-20170417_213224_682846_B4220344)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somehow AP doesn't come up and the first scan fails if we don't do
VCO calibration every time.
The vendor driver duplicates the VCO calibration function into the
channel switching logic, we can do the same with less duplication.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 7135519a638c..870bf315f98b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3407,6 +3407,8 @@ static void rt2800_config_alc(struct rt2x00_dev *rt2x00dev,
 			rt2800_rfcsr_write(rt2x00dev, 42, 0x5b);
 	}
 	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, mac_sys_ctrl);
+
+	rt2800_vco_calibration(rt2x00dev);
 }
 
 static void rt2800_bbp_write_with_rx_chain(struct rt2x00_dev *rt2x00dev,
-- 
2.12.2
