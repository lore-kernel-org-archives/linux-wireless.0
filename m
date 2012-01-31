Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39625 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab2AaXOG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 18:14:06 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, m@bues.ch, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/4] ssb: fix cardbus slot in hostmode
Date: Wed,  1 Feb 2012 00:13:53 +0100
Message-Id: <1328051636-15449-2-git-send-email-hauke@hauke-m.de> (sfid-20120201_001412_916717_9B3A55DE)
In-Reply-To: <1328051636-15449-1-git-send-email-hauke@hauke-m.de>
References: <1328051636-15449-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ssb supports one extra device on the cardbus. This results in two
devices in total, one beeing the host controller itself and the other
the external device connected to the hostcontroller over cardbus.

This makes the cardbus slot work on the Linksys WRT150N.

Reported-by: Aaron Z <aaronz@pls-net.org>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_pcicore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index 520e828..49d2091 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -75,7 +75,7 @@ static u32 get_cfgspace_addr(struct ssb_pcicore *pc,
 	u32 tmp;
 
 	/* We do only have one cardbus device behind the bridge. */
-	if (pc->cardbusmode && (dev >= 1))
+	if (pc->cardbusmode && (dev > 1))
 		goto out;
 
 	if (bus == 0) {
-- 
1.7.5.4

