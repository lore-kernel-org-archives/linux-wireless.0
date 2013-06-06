Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50605 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589Ab3FFK4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 06:56:21 -0400
Date: Thu, 6 Jun 2013 13:55:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Piotr Haber <phaber@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: [patch] brcmfmac: move dereference under check for NULL
Message-ID: <20130606105556.GD12953@debian> (sfid-20130606_125627_989317_A0655FD3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

skb_pull() dereferences the skb parameter.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index ea37bd4..c35296f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -861,9 +861,9 @@ static bool brcmf_fws_tim_update(struct brcmf_fws_info *fws,
 		      BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN + 2 +
 		      4 + fws->drvr->hdrlen;
 		skb = brcmu_pkt_buf_get_skb(len);
-		skb_pull(skb, len);
 		if (skb == NULL)
 			return false;
+		skb_pull(skb, len);
 		skcb = brcmf_skbcb(skb);
 		skcb->mac = entry;
 		skcb->state = BRCMF_FWS_SKBSTATE_TIM;
