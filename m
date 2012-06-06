Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61629 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab2FFKHj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:07:39 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 17/29] NFC: Reset poll mod list when stopping pn533 poll
Date: Wed,  6 Jun 2012 12:16:34 +0200
Message-Id: <1338977806-30279-18-git-send-email-sameo@linux.intel.com> (sfid-20120606_120742_584958_1A9F5FE0)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index db40787..6b8a65c 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1371,6 +1371,8 @@ static void pn533_stop_poll(struct nfc_dev *nfc_dev)
 
 	/* prevent pn533_start_poll_complete to issue a new poll meanwhile */
 	usb_kill_urb(dev->in_urb);
+
+	pn533_poll_reset_mod_list(dev);
 }
 
 static int pn533_activate_target_nfcdep(struct pn533 *dev)
-- 
1.7.9.1

