Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:52893 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaJ1N7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 09:59:24 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 08/16] brcmfmac: (clean) Remove packet filter configuration.
Date: Tue, 28 Oct 2014 14:56:11 +0100
Message-ID: <1414504579-12562-9-git-send-email-arend@broadcom.com> (sfid-20141028_145926_694446_E303DB89)
In-Reply-To: <1414504579-12562-1-git-send-email-arend@broadcom.com>
References: <1414504579-12562-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Packet filters got configured but never used.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   | 166 ---------------------
 1 file changed, 166 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index d991f8e..6028fc4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -26,11 +26,9 @@
 #include "fwil_types.h"
 #include "tracepoint.h"
 
-#define PKTFILTER_BUF_SIZE		128
 #define BRCMF_DEFAULT_BCN_TIMEOUT	3
 #define BRCMF_DEFAULT_SCAN_CHANNEL_TIME	40
 #define BRCMF_DEFAULT_SCAN_UNASSOC_TIME	40
-#define BRCMF_DEFAULT_PACKET_FILTER	"100 0 0 0 0x01 0x00"
 
 /* boost value for RSSI_DELTA in preferred join selection */
 #define BRCMF_JOIN_PREF_RSSI_BOOST	8
@@ -86,165 +84,6 @@ bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 	return p != NULL;
 }
 
-/* Convert user's input in hex pattern to byte-size mask */
-static int brcmf_c_pattern_atoh(char *src, char *dst)
-{
-	int i;
-	if (strncmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
-		brcmf_err("Mask invalid format. Needs to start with 0x\n");
-		return -EINVAL;
-	}
-	src = src + 2;		/* Skip past 0x */
-	if (strlen(src) % 2 != 0) {
-		brcmf_err("Mask invalid format. Length must be even.\n");
-		return -EINVAL;
-	}
-	for (i = 0; *src != '\0'; i++) {
-		unsigned long res;
-		char num[3];
-		strncpy(num, src, 2);
-		num[2] = '\0';
-		if (kstrtoul(num, 16, &res))
-			return -EINVAL;
-		dst[i] = (u8)res;
-		src += 2;
-	}
-	return i;
-}
-
-static void
-brcmf_c_pktfilter_offload_enable(struct brcmf_if *ifp, char *arg, int enable,
-				 int master_mode)
-{
-	unsigned long res;
-	char *argv;
-	char *arg_save = NULL, *arg_org = NULL;
-	s32 err;
-	struct brcmf_pkt_filter_enable_le enable_parm;
-
-	arg_save = kstrdup(arg, GFP_ATOMIC);
-	if (!arg_save)
-		goto fail;
-
-	arg_org = arg_save;
-
-	argv = strsep(&arg_save, " ");
-
-	if (argv == NULL) {
-		brcmf_err("No args provided\n");
-		goto fail;
-	}
-
-	/* Parse packet filter id. */
-	enable_parm.id = 0;
-	if (!kstrtoul(argv, 0, &res))
-		enable_parm.id = cpu_to_le32((u32)res);
-
-	/* Enable/disable the specified filter. */
-	enable_parm.enable = cpu_to_le32(enable);
-
-	err = brcmf_fil_iovar_data_set(ifp, "pkt_filter_enable", &enable_parm,
-				       sizeof(enable_parm));
-	if (err)
-		brcmf_err("Set pkt_filter_enable error (%d)\n", err);
-
-	/* Control the master mode */
-	err = brcmf_fil_iovar_int_set(ifp, "pkt_filter_mode", master_mode);
-	if (err)
-		brcmf_err("Set pkt_filter_mode error (%d)\n", err);
-
-fail:
-	kfree(arg_org);
-}
-
-static void brcmf_c_pktfilter_offload_set(struct brcmf_if *ifp, char *arg)
-{
-	struct brcmf_pkt_filter_le *pkt_filter;
-	unsigned long res;
-	int buf_len;
-	s32 err;
-	u32 mask_size;
-	u32 pattern_size;
-	char *argv[8], *buf = NULL;
-	int i = 0;
-	char *arg_save = NULL, *arg_org = NULL;
-
-	arg_save = kstrdup(arg, GFP_ATOMIC);
-	if (!arg_save)
-		goto fail;
-
-	arg_org = arg_save;
-
-	buf = kmalloc(PKTFILTER_BUF_SIZE, GFP_ATOMIC);
-	if (!buf)
-		goto fail;
-
-	argv[i] = strsep(&arg_save, " ");
-	while (argv[i]) {
-		i++;
-		if (i >= 8) {
-			brcmf_err("Too many parameters\n");
-			goto fail;
-		}
-		argv[i] = strsep(&arg_save, " ");
-	}
-
-	if (i != 6) {
-		brcmf_err("Not enough args provided %d\n", i);
-		goto fail;
-	}
-
-	pkt_filter = (struct brcmf_pkt_filter_le *)buf;
-
-	/* Parse packet filter id. */
-	pkt_filter->id = 0;
-	if (!kstrtoul(argv[0], 0, &res))
-		pkt_filter->id = cpu_to_le32((u32)res);
-
-	/* Parse filter polarity. */
-	pkt_filter->negate_match = 0;
-	if (!kstrtoul(argv[1], 0, &res))
-		pkt_filter->negate_match = cpu_to_le32((u32)res);
-
-	/* Parse filter type. */
-	pkt_filter->type = 0;
-	if (!kstrtoul(argv[2], 0, &res))
-		pkt_filter->type = cpu_to_le32((u32)res);
-
-	/* Parse pattern filter offset. */
-	pkt_filter->u.pattern.offset = 0;
-	if (!kstrtoul(argv[3], 0, &res))
-		pkt_filter->u.pattern.offset = cpu_to_le32((u32)res);
-
-	/* Parse pattern filter mask. */
-	mask_size = brcmf_c_pattern_atoh(argv[4],
-			(char *)pkt_filter->u.pattern.mask_and_pattern);
-
-	/* Parse pattern filter pattern. */
-	pattern_size = brcmf_c_pattern_atoh(argv[5],
-		(char *)&pkt_filter->u.pattern.mask_and_pattern[mask_size]);
-
-	if (mask_size != pattern_size) {
-		brcmf_err("Mask and pattern not the same size\n");
-		goto fail;
-	}
-
-	pkt_filter->u.pattern.size_bytes = cpu_to_le32(mask_size);
-	buf_len = offsetof(struct brcmf_pkt_filter_le,
-			   u.pattern.mask_and_pattern);
-	buf_len += mask_size + pattern_size;
-
-	err = brcmf_fil_iovar_data_set(ifp, "pkt_filter_add", pkt_filter,
-				       buf_len);
-	if (err)
-		brcmf_err("Set pkt_filter_add error (%d)\n", err);
-
-fail:
-	kfree(arg_org);
-
-	kfree(buf);
-}
-
 int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 {
 	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
@@ -356,11 +195,6 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 		goto done;
 	}
 
-	/* Setup packet filter */
-	brcmf_c_pktfilter_offload_set(ifp, BRCMF_DEFAULT_PACKET_FILTER);
-	brcmf_c_pktfilter_offload_enable(ifp, BRCMF_DEFAULT_PACKET_FILTER,
-					 0, true);
-
 	/* do bus specific preinit here */
 	err = brcmf_bus_preinit(ifp->drvr->bus_if);
 done:
-- 
1.9.1

