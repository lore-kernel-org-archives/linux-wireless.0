Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2152 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab3IYLGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 07:06:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 1/7] brcmfmac: sync firmware event list
Date: Wed, 25 Sep 2013 13:05:40 +0200
Message-ID: <1380107146-24026-2-git-send-email-arend@broadcom.com> (sfid-20130925_130610_699652_109DF0D9)
In-Reply-To: <1380107146-24026-1-git-send-email-arend@broadcom.com>
References: <1380107146-24026-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Update event list to keep sync with firmware development. Use calculated event
mask length instead of hard-coded value.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h  |    2 --
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h |    5 ++++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 2eb9e64..4de9aac 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -97,8 +97,6 @@
 #define	WLC_PHY_TYPE_LCN	8
 #define	WLC_PHY_TYPE_NULL	0xf
 
-#define BRCMF_EVENTING_MASK_LEN	16
-
 #define TOE_TX_CSUM_OL		0x00000001
 #define TOE_RX_CSUM_OL		0x00000002
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
index e679214..9ee5c51 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -102,7 +102,8 @@ struct brcmf_event;
 	BRCMF_ENUM_DEF(DCS_REQUEST, 73) \
 	BRCMF_ENUM_DEF(FIFO_CREDIT_MAP, 74) \
 	BRCMF_ENUM_DEF(ACTION_FRAME_RX, 75) \
-	BRCMF_ENUM_DEF(BCMC_CREDIT_SUPPORT, 127)
+	BRCMF_ENUM_DEF(BCMC_CREDIT_SUPPORT, 127) \
+	BRCMF_ENUM_DEF(PSTA_PRIMARY_INTF_IND, 128)
 
 #define BRCMF_ENUM_DEF(id, val) \
 	BRCMF_E_##id = (val),
@@ -114,6 +115,8 @@ enum brcmf_fweh_event_code {
 };
 #undef BRCMF_ENUM_DEF
 
+#define BRCMF_EVENTING_MASK_LEN		(roundup(BRCMF_E_LAST, 8)/8)
+
 /* flags field values in struct brcmf_event_msg */
 #define BRCMF_EVENT_MSG_LINK		0x01
 #define BRCMF_EVENT_MSG_FLUSHTXQ	0x02
-- 
1.7.10.4


