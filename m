Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4193 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932377Ab1GNV3z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:29:55 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 35/35] staging: brcm80211: replace simple_strtoul usage
 in brcmfmac
Date: Thu, 14 Jul 2011 14:29:31 -0700
Message-ID: <1310678971-28952-36-git-send-email-frankyl@broadcom.com> (sfid-20110714_233000_843847_3C39B24D)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The usage of simple_strtoul is not preferred. Instead kstrtoul
should be used. This patch fixes this for the brcmfmac driver.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |   27 +++++++++++++++++-----
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 12c772d..3eee457 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -827,10 +827,13 @@ static int brcmf_c_pattern_atoh(char *src, char *dst)
 		return -EINVAL;
 	}
 	for (i = 0; *src != '\0'; i++) {
+		unsigned long res;
 		char num[3];
 		strncpy(num, src, 2);
 		num[2] = '\0';
-		dst[i] = (u8) simple_strtoul(num, NULL, 16);
+		if (kstrtoul(num, 16, &res))
+			return -1;
+		dst[i] = (u8)res;
 		src += 2;
 	}
 	return i;
@@ -840,6 +843,7 @@ void
 brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 			     int master_mode)
 {
+	unsigned long res;
 	char *argv[8];
 	int i = 0;
 	const char *str;
@@ -876,7 +880,9 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 	pkt_filterp = (struct brcmf_pkt_filter_enable *) (buf + str_len + 1);
 
 	/* Parse packet filter id. */
-	enable_parm.id = simple_strtoul(argv[i], NULL, 0);
+	enable_parm.id = 0;
+	if (!kstrtoul(argv[i], 0, &res))
+		enable_parm.id = (u32)res;
 
 	/* Parse enable/disable value. */
 	enable_parm.enable = enable;
@@ -913,6 +919,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	const char *str;
 	struct brcmf_pkt_filter pkt_filter;
 	struct brcmf_pkt_filter *pkt_filterp;
+	unsigned long res;
 	int buf_len;
 	int str_len;
 	int rc;
@@ -956,7 +963,9 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	pkt_filterp = (struct brcmf_pkt_filter *) (buf + str_len + 1);
 
 	/* Parse packet filter id. */
-	pkt_filter.id = simple_strtoul(argv[i], NULL, 0);
+	pkt_filter.id = 0;
+	if (!kstrtoul(argv[i], 0, &res))
+		pkt_filter.id = (u32)res;
 
 	if (NULL == argv[++i]) {
 		BRCMF_ERROR(("Polarity not provided\n"));
@@ -964,7 +973,9 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	}
 
 	/* Parse filter polarity. */
-	pkt_filter.negate_match = simple_strtoul(argv[i], NULL, 0);
+	pkt_filter.negate_match = 0;
+	if (!kstrtoul(argv[i], 0, &res))
+		pkt_filter.negate_match = (u32)res;
 
 	if (NULL == argv[++i]) {
 		BRCMF_ERROR(("Filter type not provided\n"));
@@ -972,7 +983,9 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	}
 
 	/* Parse filter type. */
-	pkt_filter.type = simple_strtoul(argv[i], NULL, 0);
+	pkt_filter.type = 0;
+	if (!kstrtoul(argv[i], 0, &res))
+		pkt_filter.type = (u32)res;
 
 	if (NULL == argv[++i]) {
 		BRCMF_ERROR(("Offset not provided\n"));
@@ -980,7 +993,9 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	}
 
 	/* Parse pattern filter offset. */
-	pkt_filter.u.pattern.offset = simple_strtoul(argv[i], NULL, 0);
+	pkt_filter.u.pattern.offset = 0;
+	if (!kstrtoul(argv[i], 0, &res))
+		pkt_filter.u.pattern.offset = (u32)res;
 
 	if (NULL == argv[++i]) {
 		BRCMF_ERROR(("Bitmask not provided\n"));
-- 
1.7.1


