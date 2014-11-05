Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:52587 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaKEVJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 16:09:43 -0500
Received: by mail-wi0-f171.google.com with SMTP id r20so1249959wiv.16
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 13:09:42 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/11] staging: vt6655: device_get_options remove unused device parameters
Date: Wed,  5 Nov 2014 21:08:53 +0000
Message-Id: <1415221739-3045-5-git-send-email-tvboxspy@gmail.com> (sfid-20141105_220948_865768_24EBC9BA)
In-Reply-To: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
References: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IP_byte_align
Channel
PreambleType
RTSThreshold
ConnectionRate
OPMode
b80211hEnable

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      |   3 --
 drivers/staging/vt6655/device_main.c | 100 -----------------------------------
 2 files changed, 103 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 903d782..2f522977 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -209,9 +209,6 @@ typedef struct __device_opt {
 	int         nRxDescs1;		/* Number of RX descriptors1 */
 	int         nTxDescs[2];	/* Number of TX descriptors 0, 1 */
 	int         int_works;		/* interrupt limits */
-	int         rts_thresh;		/* rts threshold */
-	int         data_rate;
-	int         channel_num;
 	int         short_retry;
 	int         long_retry;
 	int         bbp_type;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 1731ef5..37bbcf8 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -93,85 +93,16 @@ DEVICE_PARAM(TxDescriptors0, "Number of transmit descriptors0");
 #define TX_DESC_DEF1     64
 DEVICE_PARAM(TxDescriptors1, "Number of transmit descriptors1");
 
-#define IP_ALIG_DEF     0
-/* IP_byte_align[] is used for IP header unsigned long byte aligned
-   0: indicate the IP header won't be unsigned long byte aligned.(Default) .
-   1: indicate the IP header will be unsigned long byte aligned.
-   In some environment, the IP header should be unsigned long byte aligned,
-   or the packet will be droped when we receive it. (eg: IPVS)
-*/
-DEVICE_PARAM(IP_byte_align, "Enable IP header dword aligned");
-
 #define INT_WORKS_DEF   20
 #define INT_WORKS_MIN   10
 #define INT_WORKS_MAX   64
 
 DEVICE_PARAM(int_works, "Number of packets per interrupt services");
 
-#define CHANNEL_MIN     1
-#define CHANNEL_MAX     14
-#define CHANNEL_DEF     6
-
-DEVICE_PARAM(Channel, "Channel number");
-
-/* PreambleType[] is the preamble length used for transmit.
-   0: indicate allows long preamble type
-   1: indicate allows short preamble type
-*/
-
-#define PREAMBLE_TYPE_DEF     1
-
-DEVICE_PARAM(PreambleType, "Preamble Type");
-
-#define RTS_THRESH_MIN     512
-#define RTS_THRESH_MAX     2347
 #define RTS_THRESH_DEF     2347
 
-DEVICE_PARAM(RTSThreshold, "RTS threshold");
-
 #define FRAG_THRESH_DEF     2346
 
-#define DATA_RATE_MIN     0
-#define DATA_RATE_MAX     13
-#define DATA_RATE_DEF     13
-/* datarate[] index
-   0: indicate 1 Mbps   0x02
-   1: indicate 2 Mbps   0x04
-   2: indicate 5.5 Mbps 0x0B
-   3: indicate 11 Mbps  0x16
-   4: indicate 6 Mbps   0x0c
-   5: indicate 9 Mbps   0x12
-   6: indicate 12 Mbps  0x18
-   7: indicate 18 Mbps  0x24
-   8: indicate 24 Mbps  0x30
-   9: indicate 36 Mbps  0x48
-   10: indicate 48 Mbps  0x60
-   11: indicate 54 Mbps  0x6c
-   12: indicate 72 Mbps  0x90
-   13: indicate auto rate
-*/
-
-DEVICE_PARAM(ConnectionRate, "Connection data rate");
-
-#define OP_MODE_DEF     0
-
-DEVICE_PARAM(OPMode, "Infrastruct, adhoc, AP mode ");
-
-/* OpMode[] is used for transmit.
-   0: indicate infrastruct mode used
-   1: indicate adhoc mode used
-   2: indicate AP mode used
-*/
-
-/* PSMode[]
-   0: indicate disable power saving mode
-   1: indicate enable power saving mode
-*/
-
-#define PS_MODE_DEF     0
-
-DEVICE_PARAM(PSMode, "Power saving mode");
-
 #define SHORT_RETRY_MIN     0
 #define SHORT_RETRY_MAX     31
 #define SHORT_RETRY_DEF     8
@@ -195,20 +126,6 @@ DEVICE_PARAM(LongRetryLimit, "long frame retry limits");
 
 DEVICE_PARAM(BasebandType, "baseband type");
 
-/* 80211hEnable[]
-   0: indicate disable 802.11h
-   1: indicate enable 802.11h
-*/
-
-#define X80211h_MODE_DEF     0
-
-DEVICE_PARAM(b80211hEnable, "802.11h mode");
-
-/* 80211hEnable[]
-   0: indicate disable 802.11h
-   1: indicate enable 802.11h
-*/
-
 #define DIVERSITY_ANT_DEF     0
 
 DEVICE_PARAM(bDiversityANTEnable, "ANT diversity mode");
@@ -294,18 +211,11 @@ static void device_get_options(struct vnt_private *pDevice)
 	pOpts->nRxDescs1 = RX_DESC_DEF1;
 	pOpts->nTxDescs[0] = TX_DESC_DEF0;
 	pOpts->nTxDescs[1] = TX_DESC_DEF1;
-	pOpts->flags |= DEVICE_FLAGS_IP_ALIGN;
 	pOpts->int_works = INT_WORKS_DEF;
-	pOpts->rts_thresh = RTS_THRESH_DEF;
-	pOpts->data_rate = DATA_RATE_DEF;
-	pOpts->channel_num = CHANNEL_DEF;
 
-	pOpts->flags |= DEVICE_FLAGS_PREAMBLE_TYPE;
-	pOpts->flags |= DEVICE_FLAGS_OP_MODE;
 	pOpts->short_retry = SHORT_RETRY_DEF;
 	pOpts->long_retry = LONG_RETRY_DEF;
 	pOpts->bbp_type = BBP_TYPE_DEF;
-	pOpts->flags |= DEVICE_FLAGS_80211h_MODE;
 	pOpts->flags |= DEVICE_FLAGS_DiversityANT;
 }
 
@@ -320,23 +230,13 @@ device_set_options(struct vnt_private *pDevice)
 	ether_addr_copy(pDevice->abySNAP_RFC1042, abySNAP_RFC1042);
 	ether_addr_copy(pDevice->abySNAP_Bridgetunnel, abySNAP_Bridgetunnel);
 
-	pDevice->uChannel = pDevice->sOpts.channel_num;
-	pDevice->wRTSThreshold = pDevice->sOpts.rts_thresh;
 	pDevice->byShortRetryLimit = pDevice->sOpts.short_retry;
 	pDevice->byLongRetryLimit = pDevice->sOpts.long_retry;
-	pDevice->wMaxTransmitMSDULifetime = DEFAULT_MSDU_LIFETIME;
-	pDevice->byShortPreamble = (pDevice->sOpts.flags & DEVICE_FLAGS_PREAMBLE_TYPE) ? 1 : 0;
-	pDevice->byOpMode = (pDevice->sOpts.flags & DEVICE_FLAGS_OP_MODE) ? 1 : 0;
-	pDevice->b11hEnable = (pDevice->sOpts.flags & DEVICE_FLAGS_80211h_MODE) ? 1 : 0;
 	pDevice->bDiversityRegCtlON = (pDevice->sOpts.flags & DEVICE_FLAGS_DiversityANT) ? 1 : 0;
-	pDevice->uConnectionRate = pDevice->sOpts.data_rate;
-	if (pDevice->uConnectionRate < RATE_AUTO)
-		pDevice->bFixRate = true;
 	pDevice->byBBType = pDevice->sOpts.bbp_type;
 	pDevice->byPacketType = (VIA_PKT_TYPE)pDevice->byBBType;
 	pDevice->byAutoFBCtrl = AUTO_FB_0;
 	pDevice->bUpdateBBVGA = true;
-	pDevice->byFOETuning = 0;
 	pDevice->byPreambleType = 0;
 
 	pr_debug(" uChannel= %d\n", (int)pDevice->uChannel);
-- 
2.1.0

