Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:3852 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJ1N6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 09:58:53 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 06/16] brcmfmac: do not use firmware error code in driver
Date: Tue, 28 Oct 2014 14:56:09 +0100
Message-ID: <1414504579-12562-7-git-send-email-arend@broadcom.com> (sfid-20141028_145856_421587_6B8E1826)
In-Reply-To: <1414504579-12562-1-git-send-email-arend@broadcom.com>
References: <1414504579-12562-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Passing the firmware error codes up the driver may be mapped to
linux error numbers which may impact proper fault analysis. So
better pass up a generic failure code, ie. -EBADE and only show
firmware error code in FIL debug message.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index 42da73e..dccbdc1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -122,12 +122,11 @@ brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 		err = brcmf_proto_query_dcmd(drvr, ifp->ifidx, cmd, data, len);
 
 	if (err >= 0)
-		err = 0;
-	else
-		brcmf_dbg(FIL, "Failed: %s (%d)\n",
-			  brcmf_fil_get_errstr((u32)(-err)), err);
+		return 0;
 
-	return err;
+	brcmf_dbg(FIL, "Failed: %s (%d)\n",
+		  brcmf_fil_get_errstr((u32)(-err)), err);
+	return -EBADE;
 }
 
 s32
-- 
1.9.1

