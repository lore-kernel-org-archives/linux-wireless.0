Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:32794 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750881AbdLAJef (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 04:34:35 -0500
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wlcore, wl1251: fix spelling mistake: "Couldnt" -> "Couldn't"
Date: Fri,  1 Dec 2017 09:34:33 +0000
Message-Id: <20171201093433.9154-1-colin.king@canonical.com> (sfid-20171201_103459_365915_2C030425)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in error message text.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ti/wl1251/init.c | 2 +-
 drivers/net/wireless/ti/wlcore/acx.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/init.c b/drivers/net/wireless/ti/wl1251/init.c
index 1d799bffaa9f..642308bdf742 100644
--- a/drivers/net/wireless/ti/wl1251/init.c
+++ b/drivers/net/wireless/ti/wl1251/init.c
@@ -311,7 +311,7 @@ static int wl1251_hw_init_data_path_config(struct wl1251 *wl)
 	wl->data_path = kzalloc(sizeof(struct acx_data_path_params_resp),
 				GFP_KERNEL);
 	if (!wl->data_path) {
-		wl1251_error("Couldnt allocate data path parameters");
+		wl1251_error("Couldn't allocate data path parameters");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index a4859993db3c..3ca9167d6146 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -146,7 +146,7 @@ int wl1271_acx_feature_cfg(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	ret = wl1271_cmd_configure(wl, ACX_FEATURE_CFG,
 				   feature, sizeof(*feature));
 	if (ret < 0) {
-		wl1271_error("Couldnt set HW encryption");
+		wl1271_error("Couldn't set HW encryption");
 		goto out;
 	}
 
-- 
2.14.1
