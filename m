Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:2576 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab2GFUAW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 16:00:22 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 28/33] NFC: Do not return EBUSY when stopping a poll that's already stopped
Date: Fri,  6 Jul 2012 22:09:48 +0200
Message-Id: <1341605393-32056-29-git-send-email-sameo@linux.intel.com> (sfid-20120706_220535_956217_CFC85B3B)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We check for the polling flag before checking if the netlink PID caller
match.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/netlink.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 03c31db..99bc6f7 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -634,6 +634,15 @@ static int nfc_genl_stop_poll(struct sk_buff *skb, struct genl_info *info)
 	if (!dev)
 		return -ENODEV;
 
+	device_lock(&dev->dev);
+
+	if (!dev->polling) {
+		device_unlock(&dev->dev);
+		return -EINVAL;
+	}
+
+	device_unlock(&dev->dev);
+
 	mutex_lock(&dev->genl_data.genl_data_mutex);
 
 	if (dev->genl_data.poll_req_pid != info->snd_pid) {
-- 
1.7.10

