Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:64798 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325AbaI3IXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 04:23:25 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 5/6] brcmfmac: Fix crash on cleanup.
Date: Tue, 30 Sep 2014 10:23:17 +0200
Message-ID: <1412065398-14316-6-git-send-email-arend@broadcom.com> (sfid-20140930_102337_000324_EFC2216A)
In-Reply-To: <1412065398-14316-1-git-send-email-arend@broadcom.com>
References: <1412065398-14316-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When driver gets unloaded due to error situation there is a chance
a packet gets received while fws has already been cleaned up. This
will result in kernel crash. This patch adds a check to avoid this
crash.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index d42f7d0..183f08d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1636,7 +1636,7 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 	if (!signal_len)
 		return 0;
 	/* if flow control disabled, skip to packet data and leave */
-	if (!fws->fw_signals) {
+	if ((!fws) || (!fws->fw_signals)) {
 		skb_pull(skb, signal_len);
 		return 0;
 	}
-- 
1.9.1

