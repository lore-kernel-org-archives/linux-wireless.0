Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2952 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab1GEWDU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 30/31] staging: brcm80211: simpler string handling in
 brcmf_c_pktfilter_offload_set()
Date: Wed, 6 Jul 2011 00:02:57 +0200
Message-ID: <1309903378-29021-31-git-send-email-arend@broadcom.com> (sfid-20110706_000327_805904_84552752)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Replaced two functions with strcpy().

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index c37128d..fdec468 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -958,13 +958,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 		goto fail;
 	}
 
-	memcpy(arg_save, arg, strlen(arg) + 1);
-
-	if (strlen(arg) > PKTFILTER_BUF_SIZE) {
-		BRCMF_ERROR(("Not enough buffer %d < %d\n", (int)strlen(arg),
-			     (int)sizeof(buf)));
-		goto fail;
-	}
+	strcpy(arg_save, arg);
 
 	argv[i] = strsep(&arg_save, " ");
 	while (argv[i++])
@@ -977,9 +971,8 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	}
 
 	str = "pkt_filter_add";
+	strcpy(buf, str);
 	str_len = strlen(str);
-	strncpy(buf, str, str_len);
-	buf[str_len] = '\0';
 	buf_len = str_len + 1;
 
 	pkt_filterp = (struct brcmf_pkt_filter *) (buf + str_len + 1);
-- 
1.7.4.1


