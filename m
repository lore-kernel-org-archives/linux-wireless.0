Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:7737 "EHLO
	mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161109AbcBQK10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 05:27:26 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 12/21] brcmfmac: increase timeout for tx eapol
Date: Wed, 17 Feb 2016 11:27:01 +0100
Message-Id: <1455704830-10088-13-git-send-email-arend@broadcom.com> (sfid-20160217_112745_789828_88CA5390)
In-Reply-To: <1455704830-10088-1-git-send-email-arend@broadcom.com>
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When keys get set and updated this has to happen after eapol got
transmitted (without key or old key) before the key can be updated.
To make sure the order of sending eapol and configuring key is done
correctly a timeout for tx of eapol is applied. This timeout is set
to 50 msec, which is not always enough. Especially in AP mode and
key updates the timeout may need to be much longer because client(s)
can be in powersave. Increase the timeout from 50 to 950 msec.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index dcf9393..3087d10 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -42,7 +42,7 @@ MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11 wireless LAN fullmac driver.");
 MODULE_LICENSE("Dual BSD/GPL");
 
-#define MAX_WAIT_FOR_8021X_TX			msecs_to_jiffies(50)
+#define MAX_WAIT_FOR_8021X_TX			msecs_to_jiffies(950)
 
 /* AMPDU rx reordering definitions */
 #define BRCMF_RXREORDER_FLOWID_OFFSET		0
-- 
1.9.1

