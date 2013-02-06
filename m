Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4279 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601Ab3BFRlJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:41:09 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/12] brcmfmac: Add logging for FIL int set/get cmds.
Date: Wed, 6 Feb 2013 18:40:40 +0100
Message-ID: <1360172447-2424-6-git-send-email-arend@broadcom.com> (sfid-20130206_184127_850866_D50E6C77)
In-Reply-To: <1360172447-2424-1-git-send-email-arend@broadcom.com>
References: <1360172447-2424-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index d8d8b65..f6ffcf6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -100,6 +100,7 @@ brcmf_fil_cmd_int_set(struct brcmf_if *ifp, u32 cmd, u32 data)
 	__le32 data_le = cpu_to_le32(data);
 
 	mutex_lock(&ifp->drvr->proto_block);
+	brcmf_dbg(FIL, "cmd=%d, value=%d\n", cmd, data);
 	err = brcmf_fil_cmd_data(ifp, cmd, &data_le, sizeof(data_le), true);
 	mutex_unlock(&ifp->drvr->proto_block);
 
@@ -116,6 +117,7 @@ brcmf_fil_cmd_int_get(struct brcmf_if *ifp, u32 cmd, u32 *data)
 	err = brcmf_fil_cmd_data(ifp, cmd, &data_le, sizeof(data_le), false);
 	mutex_unlock(&ifp->drvr->proto_block);
 	*data = le32_to_cpu(data_le);
+	brcmf_dbg(FIL, "cmd=%d, value=%d\n", cmd, *data);
 
 	return err;
 }
-- 
1.7.10.4


