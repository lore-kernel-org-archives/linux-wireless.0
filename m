Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:55650 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758648Ab2AFL6g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 06:58:36 -0500
Date: Fri, 6 Jan 2012 12:58:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-wireless@vger.kernel.org
cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: [PATCH] wireless: b43: fix Oops on card eject during transfer
Message-ID: <Pine.LNX.4.64.1201061256190.16279@axis700.grange> (sfid-20120106_125839_820913_49731F3A)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An Oops has once been observed, when the SDIO card had been ejected during
IO. The PC value shows, that the dev pointer in b43_op_stop() was NULL.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Might also be good for stable

 drivers/net/wireless/b43/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 5634d9a..3849c25 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4834,6 +4834,9 @@ static void b43_op_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&(wl->beacon_update_trigger));
 
 	mutex_lock(&wl->mutex);
+	if (!dev)
+		goto out_unlock;
+
 	if (b43_status(dev) >= B43_STAT_STARTED) {
 		dev = b43_wireless_core_stop(dev);
 		if (!dev)
-- 
1.7.2.5

