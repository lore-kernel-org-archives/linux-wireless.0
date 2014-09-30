Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:64798 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaI3IXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 04:23:23 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/6] brcmfmac: Fix sign issue with IOCTL return code in msgbuf.
Date: Tue, 30 Sep 2014 10:23:14 +0200
Message-ID: <1412065398-14316-3-git-send-email-arend@broadcom.com> (sfid-20140930_102331_306859_3AE33046)
In-Reply-To: <1412065398-14316-1-git-send-email-arend@broadcom.com>
References: <1412065398-14316-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Need a cast to assure correct value is propagated.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 8f8b937..106e6bf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -230,7 +230,7 @@ struct brcmf_msgbuf {
 	dma_addr_t ioctbuf_handle;
 	u32 ioctbuf_phys_hi;
 	u32 ioctbuf_phys_lo;
-	u32 ioctl_resp_status;
+	int ioctl_resp_status;
 	u32 ioctl_resp_ret_len;
 	u32 ioctl_resp_pktid;
 
@@ -767,7 +767,8 @@ brcmf_msgbuf_process_ioctl_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 
 	ioctl_resp = (struct msgbuf_ioctl_resp_hdr *)buf;
 
-	msgbuf->ioctl_resp_status = le16_to_cpu(ioctl_resp->compl_hdr.status);
+	msgbuf->ioctl_resp_status =
+			(s16)le16_to_cpu(ioctl_resp->compl_hdr.status);
 	msgbuf->ioctl_resp_ret_len = le16_to_cpu(ioctl_resp->resp_len);
 	msgbuf->ioctl_resp_pktid = le32_to_cpu(ioctl_resp->msg.request_id);
 
-- 
1.9.1

