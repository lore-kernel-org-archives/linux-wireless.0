Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:34411 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbcDPAXc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 20:23:32 -0400
Received: by mail-qk0-f174.google.com with SMTP id r184so43033823qkc.1
        for <linux-wireless@vger.kernel.org>; Fri, 15 Apr 2016 17:23:32 -0700 (PDT)
From: Steve deRosier <derosier@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	Steve deRosier <steve.derosier@lairdtech.com>
Subject: [PATCH] ath6kl: fix missing uart debug pin for 6004 HW 3.0
Date: Fri, 15 Apr 2016 17:18:52 -0700
Message-Id: <1460765932-12660-1-git-send-email-steve.derosier@lairdtech.com> (sfid-20160416_022335_890289_0E65C3B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For some reason, the 6004 HW 3.0 definition was missing the value for the
uarttx_pin (used for firmware debug). This corrects this situation.

Signed-off-by: Steve deRosier <steve.derosier@lairdtech.com>
---
 drivers/net/wireless/ath/ath6kl/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index da557dc..3daeb27 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -173,6 +173,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.reserved_ram_size		= 7168,
 		.board_addr			= 0x436400,
 		.testscript_addr		= 0,
+		.uarttx_pin			= 11,
 		.flags				= 0,
 
 		.fw = {
-- 
1.9.1

