Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36112 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab1LNPid (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 10:38:33 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 3/8] NFC: Do not take the genl mutex from the netlink release notifier
Date: Wed, 14 Dec 2011 16:43:07 +0100
Message-Id: <1323877392-20567-4-git-send-email-sameo@linux.intel.com> (sfid-20111214_163836_095213_D963DB93)
In-Reply-To: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
References: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The netlink notifier is atomic so we must not sleep in that context.
Also we know that Any netlink packets arriving to us will be purged when
the notifier is called, so we don't need to take the mutex.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/netlink.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 061711f..1d76d38 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -504,12 +504,10 @@ static int nfc_genl_rcv_nl_event(struct notifier_block *this,
 	dev = nfc_device_iter_next(&iter);
 
 	while (dev) {
-		mutex_lock(&dev->genl_data.genl_data_mutex);
 		if (dev->genl_data.poll_req_pid == n->pid) {
 			nfc_stop_poll(dev);
 			dev->genl_data.poll_req_pid = 0;
 		}
-		mutex_unlock(&dev->genl_data.genl_data_mutex);
 		dev = nfc_device_iter_next(&iter);
 	}
 
-- 
1.7.7.3

