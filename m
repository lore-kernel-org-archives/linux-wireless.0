Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:5691 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbbKYKcx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 05:32:53 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 09/11] brcmfmac: assure net_ratelimit() is declared before use
Date: Wed, 25 Nov 2015 11:32:45 +0100
Message-ID: <1448447567-12189-10-git-send-email-arend@broadcom.com> (sfid-20151125_113304_860426_79BD1789)
In-Reply-To: <1448447567-12189-1-git-send-email-arend@broadcom.com>
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under some kernel configuration we get build issue with implicit
declaration of net_ratelimit() function. Fix this by explicitly
including the file providing the prototype.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index d0d9676..6687812 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -17,6 +17,8 @@
 #ifndef BRCMFMAC_DEBUG_H
 #define BRCMFMAC_DEBUG_H
 
+#include <linux/net.h>	/* net_ratelimit() */
+
 /* message levels */
 #define BRCMF_TRACE_VAL		0x00000002
 #define BRCMF_INFO_VAL		0x00000004
-- 
1.9.1

