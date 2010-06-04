Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52197 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab0FDXZ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 19:25:56 -0400
Received: by wyi11 with SMTP id 11so1242469wyi.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jun 2010 16:25:54 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 1/2] wl1251: fix a memory leak in probe
Date: Sat,  5 Jun 2010 02:25:47 +0300
Message-Id: <1275693948-3189-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl1251_sdio_probe() error path is missing wl1251_free_hw, add it.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl12xx/wl1251_sdio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_sdio.c b/drivers/net/wireless/wl12xx/wl1251_sdio.c
index d234285..c561332 100644
--- a/drivers/net/wireless/wl12xx/wl1251_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1251_sdio.c
@@ -259,6 +259,7 @@ disable:
 	sdio_disable_func(func);
 release:
 	sdio_release_host(func);
+	wl1251_free_hw(wl);
 	return ret;
 }
 
-- 
1.6.3.3

