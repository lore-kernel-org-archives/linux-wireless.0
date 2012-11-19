Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33552 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab2KSQBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:01:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] brcmfmac: check return from kzalloc in brcmf_fweh_process_event
Date: Mon, 19 Nov 2012 10:53:32 -0500
Message-Id: <1353340412-22757-1-git-send-email-linville@tuxdriver.com> (sfid-20121119_170128_275450_08061969)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 1e4188c..fa8fc44 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -494,6 +494,9 @@ void brcmf_fweh_process_event(struct brcmf_pub *drvr,
 		alloc_flag = GFP_ATOMIC;
 
 	event = kzalloc(sizeof(*event) + datalen, alloc_flag);
+	if (!event)
+		return;
+
 	event->code = code;
 	event->ifidx = *ifidx;
 
-- 
1.7.11.7

