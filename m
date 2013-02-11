Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56831 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab3BKVSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 16:18:22 -0500
Received: by mail-wg0-f49.google.com with SMTP id 15so4995513wgd.4
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 13:18:21 -0800 (PST)
From: Catalin Iacob <iacobcatalin@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Catalin Iacob <iacobcatalin@gmail.com>
Subject: [PATCH] rtlwifi: Initialize rate_init member of struct rate_control_ops
Date: Mon, 11 Feb 2013 22:18:05 +0100
Message-Id: <1360617485-6194-1-git-send-email-iacobcatalin@gmail.com> (sfid-20130211_221826_368182_FF033C33)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This partially reverts commit 44ba973699b831414c3f8eef68ee5a7fe1208a05.

rate_control_rate_init assumes the rate_init member of
struct rate_control_ops is not NULL therefore not initializing it leads to
an oops as soon the driver succesfully associates to an AP.

The removal of rate_update from 44ba973699b831414c3f8eef68ee5a7fe1208a05
is ok because rate_update is checked for NULL before being
called.

Signed-off-by: Catalin Iacob <iacobcatalin@gmail.com>
---
 drivers/net/wireless/rtlwifi/rc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/rtlwifi/rc.c
index 204f46c..6ad8bb7 100644
--- a/drivers/net/wireless/rtlwifi/rc.c
+++ b/drivers/net/wireless/rtlwifi/rc.c
@@ -217,6 +217,12 @@ static void rtl_tx_status(void *ppriv,
 	}
 }
 
+static void rtl_rate_init(void *ppriv,
+			  struct ieee80211_supported_band *sband,
+			  struct ieee80211_sta *sta, void *priv_sta)
+{
+}
+
 static void *rtl_rate_alloc(struct ieee80211_hw *hw,
 		struct dentry *debugfsdir)
 {
@@ -261,6 +267,7 @@ static struct rate_control_ops rtl_rate_ops = {
 	.free = rtl_rate_free,
 	.alloc_sta = rtl_rate_alloc_sta,
 	.free_sta = rtl_rate_free_sta,
+	.rate_init = rtl_rate_init,
 	.tx_status = rtl_tx_status,
 	.get_rate = rtl_get_rate,
 };
-- 
1.8.1.1

