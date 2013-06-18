Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2417 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046Ab3FRL3t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 07:29:49 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 3/8] brcmfmac: remove dependency with nl80211.h
Date: Tue, 18 Jun 2013 13:29:24 +0200
Message-ID: <1371554970-23495-4-git-send-email-arend@broadcom.com> (sfid-20130618_132959_357907_4E058AB9)
In-Reply-To: <1371554970-23495-1-git-send-email-arend@broadcom.com>
References: <1371554970-23495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware-signalling code used NL80211_NUM_ACS, but it has
its own definition enum brcmf_fws_fifo, which is more appropriate
to use. This effectively removes the need to include nl80211.h.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index e66b723..b702f3e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -22,7 +22,6 @@
 #include <linux/etherdevice.h>
 #include <linux/err.h>
 #include <linux/jiffies.h>
-#include <uapi/linux/nl80211.h>
 #include <net/cfg80211.h>
 
 #include <brcmu_utils.h>
@@ -142,7 +141,7 @@ static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
 #define BRCMF_FWS_FLOWCONTROL_HIWATER			128
 #define BRCMF_FWS_FLOWCONTROL_LOWATER			64
 
-#define BRCMF_FWS_PSQ_PREC_COUNT		((NL80211_NUM_ACS + 1) * 2)
+#define BRCMF_FWS_PSQ_PREC_COUNT		((BRCMF_FWS_FIFO_COUNT + 1) * 2)
 #define BRCMF_FWS_PSQ_LEN				256
 
 #define BRCMF_FWS_HTOD_FLAG_PKTFROMHOST			0x01
-- 
1.7.10.4


