Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1546 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210Ab3CCLqO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:46:14 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/13] brcmfmac: make debug module parameter more clear
Date: Sun, 3 Mar 2013 12:45:22 +0100
Message-ID: <1362311132-29561-4-git-send-email-arend@broadcom.com> (sfid-20130303_131304_043020_0ADDDADC)
In-Reply-To: <1362311132-29561-1-git-send-email-arend@broadcom.com>
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The module parameter definition for brcmf_msg_level has been
reworked to a named module parameter with description so
modinfo is a bit more informative:

parm:           debug:level of debug output (int)

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 6e3846c..a4d01f3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -40,7 +40,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 
 /* Error bits */
 int brcmf_msg_level;
-module_param(brcmf_msg_level, int, 0);
+module_param_named(debug, brcmf_msg_level, int, S_IRUSR | S_IWUSR);
+MODULE_PARM_DESC(debug, "level of debug output");
 
 /* P2P0 enable */
 static int brcmf_p2p_enable;
-- 
1.7.6


