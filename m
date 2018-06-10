Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:45383 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753722AbeFJHKY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Jun 2018 03:10:24 -0400
Date: Sun, 10 Jun 2018 12:40:17 +0530
From: Nishad Kamdar <nishadkamdar@gmail.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: Fix type of argument in
 ieee80211_is_action()
Message-ID: <20180610071013.GA8771@nishad> (sfid-20180610_091053_003096_760CD3FA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Type used is unsigned char but expected is restricted __le16.
Warning reported by sparse. Part of eudyptula challenge.

Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e248702ee519..745bf5ca2622 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1431,7 +1431,7 @@ void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 
 	freq = ieee80211_channel_to_frequency(curr_channel, NL80211_BAND_2GHZ);
 
-	if (!ieee80211_is_action(buff[FRAME_TYPE_ID])) {
+	if (!ieee80211_is_action(cpu_to_le16(buff[FRAME_TYPE_ID]))) {
 		cfg80211_rx_mgmt(priv->wdev, freq, 0, buff, size, 0);
 		return;
 	}
-- 
2.17.0
