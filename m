Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:58157 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551AbcFCVbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 17:31:22 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wrightf <wright.feng@broadcom.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 3/6] brcmfmac: use ndev->needed_headroom to reserve additional header space
Date: Fri,  3 Jun 2016 23:31:09 +0200
Message-Id: <1464989472-29684-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160603_233134_304557_5D31AE6E)
In-Reply-To: <1464989472-29684-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1464989472-29684-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: wrightf <wright.feng@broadcom.com>

When using nmap tool with FMAC, the nmap packets were be dropped by kernel
because the size was too short. The kernel message showed like
"nmap: packet size is too short (42 <= 50)". It is caused by the packet
length is shorter than ndev->hard_header_len. According to definition of
LL_RESERVED_SPACE() and hard_header_len, we should use hard_header_len
to reserve for L2 header, like ethernet header(ETH_HLEN) in our case and
use needed_headroom for the additional headroom needed by hardware.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Wright Feng <wright.feng@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index b590499..6570dba 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -516,7 +516,7 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 	/* set appropriate operations */
 	ndev->netdev_ops = &brcmf_netdev_ops_pri;
 
-	ndev->hard_header_len += drvr->hdrlen;
+	ndev->needed_headroom += drvr->hdrlen;
 	ndev->ethtool_ops = &brcmf_ethtool_ops;
 
 	drvr->rxsz = ndev->mtu + ndev->hard_header_len +
-- 
1.9.1

