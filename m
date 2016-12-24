Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33327 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754122AbcLXQ5T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Dec 2016 11:57:19 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Michal Kazior <michal.kazior@tieto.com>,
        Daniel Wagner <wagi@monom.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 3/6] wl1251: Update wl->nvs_len after wl->nvs is valid
Date: Sat, 24 Dec 2016 17:52:58 +0100
Message-Id: <1482598381-16513-4-git-send-email-pali.rohar@gmail.com> (sfid-20161224_175740_414052_C84EC2C3)
In-Reply-To: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
References: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case kmemdup fails thne wl->nvs_len will contains invalid non-zero size.
This patch fixes it.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/net/wireless/ti/wl1251/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 24f8866..8971b64 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -124,8 +124,7 @@ static int wl1251_fetch_nvs(struct wl1251 *wl)
 		goto out;
 	}
 
-	wl->nvs_len = fw->size;
-	wl->nvs = kmemdup(fw->data, wl->nvs_len, GFP_KERNEL);
+	wl->nvs = kmemdup(fw->data, fw->size, GFP_KERNEL);
 
 	if (!wl->nvs) {
 		wl1251_error("could not allocate memory for the nvs file");
@@ -133,6 +132,8 @@ static int wl1251_fetch_nvs(struct wl1251 *wl)
 		goto out;
 	}
 
+	wl->nvs_len = fw->size;
+
 	ret = 0;
 
 out:
-- 
1.7.9.5
