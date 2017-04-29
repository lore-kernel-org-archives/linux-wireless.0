Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34076 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426015AbdD2MEH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Apr 2017 08:04:07 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>,
        "# v3 . 17+" <stable@vger.kernel.org>
Subject: [PATCH 3/4] staging: vt6556: vnt_start Fix missing call to vnt_key_init_table.
Date: Sat, 29 Apr 2017 13:03:44 +0100
Message-Id: <20170429120345.3782-3-tvboxspy@gmail.com> (sfid-20170429_140420_656147_112AADD4)
In-Reply-To: <20170429120345.3782-1-tvboxspy@gmail.com>
References: <20170429120345.3782-1-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The key table is not intialized correctly without this call.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v3.17+
---
 drivers/staging/vt6656/main_usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 9237930991ca..06f7841d44d3 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -513,6 +513,9 @@ static int vnt_start(struct ieee80211_hw *hw)
 		goto free_all;
 	}
 
+	if (vnt_key_init_table(priv))
+		goto free_all;
+
 	priv->int_interval = 1;  /* bInterval is set to 1 */
 
 	vnt_int_start_interrupt(priv);
-- 
2.11.0
