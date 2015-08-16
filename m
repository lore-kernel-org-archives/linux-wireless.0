Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:32554 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbHPGzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 02:55:54 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 7/7] brcmfmac: bump highest event number for 4339 firmware
Date: Sun, 16 Aug 2015 08:55:39 +0200
Message-ID: <1439708139-7527-8-git-send-email-arend@broadcom.com> (sfid-20150816_085601_425800_5E7D5366)
In-Reply-To: <1439708139-7527-1-git-send-email-arend@broadcom.com>
References: <1439708139-7527-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The event mask length is determined by the highest event number
that is specified in the driver. When this length is shorter than
firmware expects setting event mask will fail and device becomes
pretty useless. This issue was reported with bcm4339 firmware that
was recently released.

Reported-by: Pontus Fuchs <pontusf@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Pontus Fuchs <pontusf@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
index cbf033f..1326898 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -85,7 +85,6 @@ struct brcmf_event;
 	BRCMF_ENUM_DEF(IF, 54) \
 	BRCMF_ENUM_DEF(P2P_DISC_LISTEN_COMPLETE, 55) \
 	BRCMF_ENUM_DEF(RSSI, 56) \
-	BRCMF_ENUM_DEF(PFN_SCAN_COMPLETE, 57) \
 	BRCMF_ENUM_DEF(EXTLOG_MSG, 58) \
 	BRCMF_ENUM_DEF(ACTION_FRAME, 59) \
 	BRCMF_ENUM_DEF(ACTION_FRAME_COMPLETE, 60) \
@@ -103,8 +102,7 @@ struct brcmf_event;
 	BRCMF_ENUM_DEF(FIFO_CREDIT_MAP, 74) \
 	BRCMF_ENUM_DEF(ACTION_FRAME_RX, 75) \
 	BRCMF_ENUM_DEF(TDLS_PEER_EVENT, 92) \
-	BRCMF_ENUM_DEF(BCMC_CREDIT_SUPPORT, 127) \
-	BRCMF_ENUM_DEF(PSTA_PRIMARY_INTF_IND, 128)
+	BRCMF_ENUM_DEF(BCMC_CREDIT_SUPPORT, 127)
 
 #define BRCMF_ENUM_DEF(id, val) \
 	BRCMF_E_##id = (val),
@@ -112,7 +110,11 @@ struct brcmf_event;
 /* firmware event codes sent by the dongle */
 enum brcmf_fweh_event_code {
 	BRCMF_FWEH_EVENT_ENUM_DEFLIST
-	BRCMF_E_LAST
+	/* this determines event mask length which must match
+	 * minimum length check in device firmware so it is
+	 * hard-coded here.
+	 */
+	BRCMF_E_LAST = 139
 };
 #undef BRCMF_ENUM_DEF
 
-- 
1.9.1

