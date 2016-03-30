Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34249 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbcC3KIb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 06:08:31 -0400
Received: by mail-pa0-f45.google.com with SMTP id fe3so36972269pab.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2016 03:08:31 -0700 (PDT)
From: Wei-Ning Huang <wnhuang@chromium.org>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, djkurtz@chromium.org,
	snanda@chromium.org, akarwar@marvell.com,
	Wei-Ning Huang <wnhuang@chromium.org>
Subject: [PATCH] CHROMIUM: mwifiex: fix NULL pointer dereference error
Date: Wed, 30 Mar 2016 18:08:24 +0800
Message-Id: <1459332504-1718-1-git-send-email-wnhuang@chromium.org> (sfid-20160330_120848_164095_9C0C2521)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In mwifiex_enable_hs, we need to check if
priv->wdev.wiphy->wowlan_config is NULL before accessing it's member.
This sometimes cause kernel panic when suspend/resume.

Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index d5c56eb..d8de432 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -509,7 +509,8 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 
 	if (priv && priv->sched_scanning) {
 #ifdef CONFIG_PM
-		if (!priv->wdev.wiphy->wowlan_config->nd_config) {
+		if (priv->wdev.wiphy->wowlan_config &&
+		    !priv->wdev.wiphy->wowlan_config->nd_config) {
 #endif
 			mwifiex_dbg(adapter, CMD, "aborting bgscan!\n");
 			mwifiex_stop_bg_scan(priv);
-- 
2.1.2

