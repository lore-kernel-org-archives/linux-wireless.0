Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3865 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab2ISUVo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 16:21:44 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/13] brcmfmac: fix debug printout of event data.
Date: Wed, 19 Sep 2012 22:21:09 +0200
Message-ID: <1348086078-19183-5-git-send-email-arend@broadcom.com> (sfid-20120919_222157_604560_EFDE67CB)
In-Reply-To: <1348086078-19183-1-git-send-email-arend@broadcom.com>
References: <1348086078-19183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Some events result in printing of the buffer when debug is
enabled. This printing was not very efficient. Changed to
macro so it comes out nice and clean without filling log buffer.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   13 ++++---------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    2 ++
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 6afb26c..aa4f719 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -433,13 +433,7 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 	}
 
 	/* show any appended data */
-	if (datalen) {
-		buf = (unsigned char *) event_data;
-		brcmf_dbg(EVENT, " data (%d) : ", datalen);
-		for (i = 0; i < datalen; i++)
-			brcmf_dbg(EVENT, " 0x%02x ", *buf++);
-		brcmf_dbg(EVENT, "\n");
-	}
+	brcmf_dbg_hex_dump(datalen, event_data, datalen, "Received data");
 }
 #endif				/* DEBUG */
 
@@ -530,8 +524,9 @@ brcmf_c_host_event(struct brcmf_pub *drvr, int *ifidx, void *pktdata,
 	}
 
 #ifdef DEBUG
-	brcmf_c_show_host_event(event, event_data);
-#endif				/* DEBUG */
+	if (BRCMF_EVENT_ON())
+		brcmf_c_show_host_event(event, event_data);
+#endif /* DEBUG */
 
 	return 0;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index b784920..fb508c2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -55,6 +55,7 @@ do {									\
 #define BRCMF_HDRS_ON()		(brcmf_msg_level & BRCMF_HDRS_VAL)
 #define BRCMF_BYTES_ON()	(brcmf_msg_level & BRCMF_BYTES_VAL)
 #define BRCMF_GLOM_ON()		(brcmf_msg_level & BRCMF_GLOM_VAL)
+#define BRCMF_EVENT_ON()	(brcmf_msg_level & BRCMF_EVENT_VAL)
 
 #else	/* (defined DEBUG) || (defined DEBUG) */
 
@@ -65,6 +66,7 @@ do {									\
 #define BRCMF_HDRS_ON()		0
 #define BRCMF_BYTES_ON()	0
 #define BRCMF_GLOM_ON()		0
+#define BRCMF_EVENT_ON()	0
 
 #endif				/* defined(DEBUG) */
 
-- 
1.7.9.5


