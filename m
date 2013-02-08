Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3754 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760216Ab3BHO4p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:45 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 19/27] brcmfmac: Put printing action frames code under
 debug flag.
Date: Fri, 8 Feb 2013 15:53:54 +0100
Message-ID: <1360335242-12608-20-git-send-email-arend@broadcom.com> (sfid-20130208_160332_391912_022839AD)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index c04d596..9f87a85 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -300,6 +300,9 @@ static bool brcmf_p2p_is_gas_action(void *frame, u32 frame_len)
  *
  * Print information about the p2p action frame
  */
+
+#ifdef DEBUG
+
 static void brcmf_p2p_print_actframe(bool tx, void *frame, u32 frame_len)
 {
 	struct brcmf_p2p_pub_act_frame *pact_frm;
@@ -404,6 +407,14 @@ static void brcmf_p2p_print_actframe(bool tx, void *frame, u32 frame_len)
 	}
 }
 
+#else
+
+static void brcmf_p2p_print_actframe(bool tx, void *frame, u32 frame_len)
+{
+}
+
+#endif
+
 /**
  * brcmf_p2p_set_firmware() - prepare firmware for peer-to-peer operation.
  *
-- 
1.7.10.4


