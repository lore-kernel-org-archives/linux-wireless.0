Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:48836 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab0EHQ0w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 12:26:52 -0400
Received: by qyk13 with SMTP id 13so3450580qyk.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 May 2010 09:26:52 -0700 (PDT)
Date: Sat, 8 May 2010 18:26:38 +0200
From: Dan Carpenter <error27@gmail.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless@vger.kernel.org
Subject: [patch 9/9] wl1271: remove some unneeded code
Message-ID: <20100508162638.GU27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The goto and the break are equivelent.  I removed the goto in memory of
Edsger Dijkstra who famously hated gotos and who would have been eighty
years old next Tuesday.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 55aa813..da40cee 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1563,8 +1563,6 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	default:
 		wl1271_error("Unsupported key cmd 0x%x", cmd);
 		ret = -EOPNOTSUPP;
-		goto out_sleep;
-
 		break;
 	}
 
