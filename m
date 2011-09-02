Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1781 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab1IBOAz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 10:00:55 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 02/12] staging: brcm80211: replace 0 integer with NULL
 pointer
Date: Fri, 2 Sep 2011 16:00:29 +0200
Message-ID: <1314972039-27098-3-git-send-email-rvossen@broadcom.com> (sfid-20110902_160103_949805_8AB1DD06)
In-Reply-To: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
References: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Running sparse showed following warning: Using plain integer as NULL
pointer. This has been fixed.

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 3abd434..cb7393c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -840,7 +840,7 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 	const char *str;
 	int buf_len;
 	int str_len;
-	char *arg_save = 0, *arg_org = 0;
+	char *arg_save = NULL, *arg_org = NULL;
 	int rc;
 	char buf[128];
 	struct brcmf_pkt_filter_enable enable_parm;
@@ -915,9 +915,9 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	int rc;
 	u32 mask_size;
 	u32 pattern_size;
-	char *argv[8], *buf = 0;
+	char *argv[8], *buf = NULL;
 	int i = 0;
-	char *arg_save = 0, *arg_org = 0;
+	char *arg_save = NULL, *arg_org = NULL;
 
 	arg_save = kstrdup(arg, GFP_ATOMIC);
 	if (!arg_save) {
@@ -1099,7 +1099,7 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 	/* query for 'ver' to get version info from firmware */
 	memset(buf, 0, sizeof(buf));
 	ptr = buf;
-	brcmu_mkiovar("ver", 0, 0, buf, sizeof(buf));
+	brcmu_mkiovar("ver", NULL, 0, buf, sizeof(buf));
 	brcmf_proto_cdc_query_ioctl(drvr, 0, BRCMF_C_GET_VAR, buf, sizeof(buf));
 	strsep(&ptr, "\n");
 	/* Print fw version info */
-- 
1.7.4.1


