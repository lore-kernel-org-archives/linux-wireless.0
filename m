Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2414 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab1IWAIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 20:08:14 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 06/19] staging: brcm80211: remove unconditional code
 blocks from brcmfmac
Date: Thu, 22 Sep 2011 17:07:43 -0700
Message-ID: <1316736476-23725-7-git-send-email-frankyl@broadcom.com> (sfid-20110923_020842_581824_E8B01F27)
In-Reply-To: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
References: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Using a block statement to scope function variables is not
common in linux kernel development. Browsed through the brcmfmac
to remove those.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |  132 +++++++++++-----------
 1 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index c9bf92a..0c41c1c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -198,6 +198,11 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 		BRCMF_E_PFN_SCAN_COMPLETE, "SCAN_COMPLETE"}
 	};
 	uint event_type, flags, auth_type, datalen;
+	static u32 seqnum_prev;
+	struct msgtrace_hdr hdr;
+	u32 nblost;
+	char *s, *p;
+
 	event_type = be32_to_cpu(event->event_type);
 	flags = be16_to_cpu(event->flags);
 	status = be32_to_cpu(event->status);
@@ -348,55 +353,52 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 		break;
 
 	case BRCMF_E_TRACE:
-		{
-			static u32 seqnum_prev;
-			struct msgtrace_hdr hdr;
-			u32 nblost;
-			char *s, *p;
-
-			buf = (unsigned char *) event_data;
-			memcpy(&hdr, buf, sizeof(struct msgtrace_hdr));
-
-			if (hdr.version != MSGTRACE_VERSION) {
-				brcmf_dbg(ERROR, "MACEVENT: %s [unsupported version --> brcmf version:%d dongle version:%d]\n",
-					  event_name,
-					  MSGTRACE_VERSION, hdr.version);
-				/* Reset datalen to avoid display below */
-				datalen = 0;
-				break;
-			}
-
-			/* There are 2 bytes available at the end of data */
-			*(buf + sizeof(struct msgtrace_hdr)
-				 + be16_to_cpu(hdr.len)) = '\0';
-
-			if (be32_to_cpu(hdr.discarded_bytes)
-			    || be32_to_cpu(hdr.discarded_printf))
-				brcmf_dbg(ERROR, "WLC_E_TRACE: [Discarded traces in dongle --> discarded_bytes %d discarded_printf %d]\n",
-					  be32_to_cpu(hdr.discarded_bytes),
-					  be32_to_cpu(hdr.discarded_printf));
-
-			nblost = be32_to_cpu(hdr.seqnum) - seqnum_prev - 1;
-			if (nblost > 0)
-				brcmf_dbg(ERROR, "WLC_E_TRACE: [Event lost --> seqnum %d nblost %d\n",
-					  be32_to_cpu(hdr.seqnum), nblost);
-			seqnum_prev = be32_to_cpu(hdr.seqnum);
-
-			/* Display the trace buffer. Advance from \n to \n to
-			 * avoid display big
-			 * printf (issue with Linux printk )
-			 */
-			p = (char *)&buf[sizeof(struct msgtrace_hdr)];
-			while ((s = strstr(p, "\n")) != NULL) {
-				*s = '\0';
-				printk(KERN_DEBUG"%s\n", p);
-				p = s + 1;
-			}
-			printk(KERN_DEBUG "%s\n", p);
+		buf = (unsigned char *) event_data;
+		memcpy(&hdr, buf, sizeof(struct msgtrace_hdr));
 
+		if (hdr.version != MSGTRACE_VERSION) {
+			brcmf_dbg(ERROR,
+				  "MACEVENT: %s [unsupported version --> brcmf"
+				  " version:%d dongle version:%d]\n",
+				  event_name, MSGTRACE_VERSION, hdr.version);
 			/* Reset datalen to avoid display below */
 			datalen = 0;
+			break;
+		}
+
+		/* There are 2 bytes available at the end of data */
+		*(buf + sizeof(struct msgtrace_hdr)
+			 + be16_to_cpu(hdr.len)) = '\0';
+
+		if (be32_to_cpu(hdr.discarded_bytes)
+		    || be32_to_cpu(hdr.discarded_printf))
+			brcmf_dbg(ERROR,
+				  "WLC_E_TRACE: [Discarded traces in dongle -->"
+				  " discarded_bytes %d discarded_printf %d]\n",
+				  be32_to_cpu(hdr.discarded_bytes),
+				  be32_to_cpu(hdr.discarded_printf));
+
+		nblost = be32_to_cpu(hdr.seqnum) - seqnum_prev - 1;
+		if (nblost > 0)
+			brcmf_dbg(ERROR, "WLC_E_TRACE: [Event lost --> seqnum "
+				  " %d nblost %d\n", be32_to_cpu(hdr.seqnum),
+				  nblost);
+		seqnum_prev = be32_to_cpu(hdr.seqnum);
+
+		/* Display the trace buffer. Advance from \n to \n to
+		 * avoid display big
+		 * printf (issue with Linux printk )
+		 */
+		p = (char *)&buf[sizeof(struct msgtrace_hdr)];
+		while ((s = strstr(p, "\n")) != NULL) {
+			*s = '\0';
+			printk(KERN_DEBUG"%s\n", p);
+			p = s + 1;
 		}
+		printk(KERN_DEBUG "%s\n", p);
+
+		/* Reset datalen to avoid display below */
+		datalen = 0;
 		break;
 
 	case BRCMF_E_RSSI:
@@ -405,8 +407,9 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 		break;
 
 	default:
-		brcmf_dbg(EVENT, "MACEVENT: %s %d, MAC %s, status %d, reason %d, auth %d\n",
-			  event_name, event_type, eabuf,
+		brcmf_dbg(EVENT,
+			  "MACEVENT: %s %d, MAC %s, status %d, reason %d, "
+			  "auth %d\n", event_name, event_type, eabuf,
 			  (int)status, (int)reason, (int)auth_type);
 		break;
 	}
@@ -428,6 +431,7 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 {
 	/* check whether packet is a BRCM event pkt */
 	struct brcmf_event *pvt_data = (struct brcmf_event *) pktdata;
+	struct brcmf_if_event *ifevent;
 	char *event_data;
 	u32 type, status;
 	u16 flags;
@@ -459,26 +463,22 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 
 	switch (type) {
 	case BRCMF_E_IF:
-		{
-			struct brcmf_if_event *ifevent =
-					(struct brcmf_if_event *) event_data;
-			brcmf_dbg(TRACE, "if event\n");
-
-			if (ifevent->ifidx > 0 &&
-				 ifevent->ifidx < BRCMF_MAX_IFS) {
-				if (ifevent->action == BRCMF_E_IF_ADD)
-					brcmf_add_if(drvr_priv, ifevent->ifidx,
-						   NULL, event->ifname,
-						   pvt_data->eth.h_dest,
-						   ifevent->flags,
-						   ifevent->bssidx);
-				else
-					brcmf_del_if(drvr_priv, ifevent->ifidx);
-			} else {
-				brcmf_dbg(ERROR, "Invalid ifidx %d for %s\n",
-					  ifevent->ifidx, event->ifname);
-			}
+		ifevent = (struct brcmf_if_event *) event_data;
+		brcmf_dbg(TRACE, "if event\n");
+
+		if (ifevent->ifidx > 0 && ifevent->ifidx < BRCMF_MAX_IFS) {
+			if (ifevent->action == BRCMF_E_IF_ADD)
+				brcmf_add_if(drvr_priv, ifevent->ifidx, NULL,
+					     event->ifname,
+					     pvt_data->eth.h_dest,
+					     ifevent->flags, ifevent->bssidx);
+			else
+				brcmf_del_if(drvr_priv, ifevent->ifidx);
+		} else {
+			brcmf_dbg(ERROR, "Invalid ifidx %d for %s\n",
+				  ifevent->ifidx, event->ifname);
 		}
+
 		/* send up the if event: btamp user needs it */
 		*ifidx = brcmf_ifname2idx(drvr_priv, event->ifname);
 		break;
-- 
1.7.1


