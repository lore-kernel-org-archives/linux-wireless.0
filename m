Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53606 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953AbZKGV6r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 16:58:47 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: John Linville <linville@tuxdriver.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 21:58:47 +0000
Message-ID: <1257631127.15927.455.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 47/75] ipw2100: declare MODULE_FIRMWARE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ipw2x00/ipw2100.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index a741d37..8dfdbd3 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -8465,6 +8465,12 @@ static int ipw2100_get_firmware(struct ipw2100_priv *priv,
 	return 0;
 }
 
+MODULE_FIRMWARE(IPW2100_FW_NAME("-i"));
+#ifdef CONFIG_IPW2100_MONITOR
+MODULE_FIRMWARE(IPW2100_FW_NAME("-p"));
+#endif
+MODULE_FIRMWARE(IPW2100_FW_NAME(""));
+
 static void ipw2100_release_firmware(struct ipw2100_priv *priv,
 				     struct ipw2100_fw *fw)
 {
-- 
1.6.5.2



