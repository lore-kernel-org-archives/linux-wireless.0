Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53319 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab0HJR3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 13:29:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwm3200wifi: remove comparison to WIFI_IF_NTFY_MAX in iwm_ntf_wifi_if_wrapper
Date: Tue, 10 Aug 2010 13:26:50 -0400
Message-Id: <1281461210-3528-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <20100809164346.6e30cf8c.akpm@linux-foundation.org>
References: <20100809164346.6e30cf8c.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/iwmc3200wifi/rx.c: In function 'iwm_ntf_wifi_if_wrapper':
drivers/net/wireless/iwmc3200wifi/rx.c:1198: warning: comparison is always true due to limited range of data type

This is, of course, because the value of WIFI_IF_NTFY_MAX is 0xff and
hdr->oid is a u8.  This is obviously an attempt to verify the range on
an input value, but since it has no effect it can simply be removed.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwmc3200wifi/rx.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index c02fced..a944893 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1195,11 +1195,8 @@ static int iwm_ntf_wifi_if_wrapper(struct iwm_priv *iwm, u8 *buf,
 	IWM_DBG_NTF(iwm, DBG, "WIFI_IF_WRAPPER cmd is delivered to UMAC: "
 		    "oid is 0x%x\n", hdr->oid);
 
-	if (hdr->oid <= WIFI_IF_NTFY_MAX) {
-		set_bit(hdr->oid, &iwm->wifi_ntfy[0]);
-		wake_up_interruptible(&iwm->wifi_ntfy_queue);
-	} else
-		return -EINVAL;
+	set_bit(hdr->oid, &iwm->wifi_ntfy[0]);
+	wake_up_interruptible(&iwm->wifi_ntfy_queue);
 
 	switch (hdr->oid) {
 	case UMAC_WIFI_IF_CMD_SET_PROFILE:
-- 
1.7.2.1

