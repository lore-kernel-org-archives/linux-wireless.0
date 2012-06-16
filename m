Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40768 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab2FPT04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 15:26:56 -0400
Received: by wibhn6 with SMTP id hn6so665729wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2012 12:26:55 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 1/3] wl1251: fix TSF calculation
Date: Sat, 16 Jun 2012 22:26:46 +0300
Message-Id: <1339874808-9991-2-git-send-email-notasas@gmail.com> (sfid-20120616_212736_650392_887BB93D)
In-Reply-To: <1339874808-9991-1-git-send-email-notasas@gmail.com>
References: <1339874808-9991-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cast MSB part of current TSF to u64 to prevent loss of most
significant bits. MSB should also be shifted by 32.

Patch based on old maemo patch by:
Yuri Kululin <ext-yuri.kululin@nokia.com>
Yuri Ershov <ext-yuri.ershov@nokia.com>

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/ti/wl1251/acx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/acx.c b/drivers/net/wireless/ti/wl1251/acx.c
index ad87a1a..db6430c 100644
--- a/drivers/net/wireless/ti/wl1251/acx.c
+++ b/drivers/net/wireless/ti/wl1251/acx.c
@@ -869,7 +869,7 @@ int wl1251_acx_tsf_info(struct wl1251 *wl, u64 *mactime)
 	}
 
 	*mactime = tsf_info->current_tsf_lsb |
-		(tsf_info->current_tsf_msb << 31);
+		((u64)tsf_info->current_tsf_msb << 32);
 
 out:
 	kfree(tsf_info);
-- 
1.7.0.4

