Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.cypress.com ([157.95.67.100]:60013 "EHLO
        smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751949AbdIDHa2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 03:30:28 -0400
From: Wright Feng <wright.feng@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com
Cc: wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH] brcmfmac: return -EPERM when getting error in vendor command handler
Date: Mon,  4 Sep 2017 15:34:33 +0800
Message-Id: <1504510473-13549-1-git-send-email-wright.feng@cypress.com> (sfid-20170904_093037_992402_23CA2602)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware returns proprietary error code when getting error in
fil_cmd_data_set or fil_cmd_data_get. The vendor tools or
utilities which uses libnl may stuck in some commands when wl is down.
For example, issue "scan" command after issuing "down" command, the
"scan" command will be the blocking call and stuck as no response from
libnl. It is caused by that firmware returns BCME_NOTUP(-4) when wl
is down, but the -4 is -EINTR in Linux kernel, so libnl catches the error
and not passes to upper layer.
Because of that, the driver should return Linux error code instead of the
proprietary error code, and the tools or utilities need to get the real
firmware error code by command "bcmerror" or "bcmerrorstr" after receiving
the error.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
index 8eff275..2b88ba1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
@@ -80,8 +80,12 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
 	else
 		ret = brcmf_fil_cmd_data_get(ifp, cmdhdr->cmd, dcmd_buf,
 					     ret_len);
-	if (ret != 0)
+
+	if (ret != 0) {
+		brcmf_dbg(INFO, "error(%d), return -EPERM\n", ret);
+		ret = -EPERM;
 		goto exit;
+	}
 
 	wr_pointer = dcmd_buf;
 	while (ret_len > 0) {
-- 
1.9.1
