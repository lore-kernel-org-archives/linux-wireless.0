Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:45820 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753019AbeF1Kis (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 06:38:48 -0400
Received: by mail-lf0-f68.google.com with SMTP id m13-v6so3815188lfb.12
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2018 03:38:47 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] brcmfmac: update STA info struct to the v5
Date: Thu, 28 Jun 2018 12:36:23 +0200
Message-Id: <20180628103623.29103-1-zajec5@gmail.com> (sfid-20180628_123855_088941_21D82ED8)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

That struct is used when querying firmware for the STA. It seem is has
been changing during the time. Luckily its format seems to be backward
compatible starting with v2 (the only breakage was v1 -> v2).

The version that was supported by brcmfmac so far was v4. It was what
43602a1 and 4366b1 firmwares (7.35.177.56 and 10.10.69.3309 accordingly)
were using. It also seems to be used by early 4366c0 firmwares
(10.10.69.6908 and 10.10.69.69017).

The problem appears when switching to the 10.10.122.20 firmware. It uses
v5 and instead of falling back to v4 when submitted buffer isn't big
enough it fallbacks to the v3.

To receive all v4 specific info with the newest firmware we have to
submit a struct (buffer) that matches v5.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h  | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 9b3a58e89dd1..d5bb81e88762 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -174,6 +174,8 @@
 #define BRCMF_MFP_CAPABLE		1
 #define BRCMF_MFP_REQUIRED		2
 
+#define BRCMF_VHT_CAP_MCS_MAP_NSS_MAX	8
+
 /* MAX_CHUNK_LEN is the maximum length for data passing to firmware in each
  * ioctl. It is relatively small because firmware has small maximum size input
  * playload restriction for ioctls.
@@ -550,6 +552,8 @@ struct brcmf_sta_info_le {
 						/* w/hi bit set if basic */
 	__le32 in;		/* seconds elapsed since associated */
 	__le32 listen_interval_inms; /* Min Listen interval in ms for STA */
+
+	/* Fields valid for ver >= 3 */
 	__le32 tx_pkts;	/* # of packets transmitted */
 	__le32 tx_failures;	/* # of packets failed */
 	__le32 rx_ucast_pkts;	/* # of unicast packets received */
@@ -558,6 +562,8 @@ struct brcmf_sta_info_le {
 	__le32 rx_rate;	/* Rate of last successful rx frame */
 	__le32 rx_decrypt_succeeds;	/* # of packet decrypted successfully */
 	__le32 rx_decrypt_failures;	/* # of packet decrypted failed */
+
+	/* Fields valid for ver >= 4 */
 	__le32 tx_tot_pkts;    /* # of tx pkts (ucast + mcast) */
 	__le32 rx_tot_pkts;    /* # of data packets recvd (uni + mcast) */
 	__le32 tx_mcast_pkts;  /* # of mcast pkts txed */
@@ -594,6 +600,14 @@ struct brcmf_sta_info_le {
 						*/
 	__le32 rx_pkts_retried;        /* # rx with retry bit set */
 	__le32 tx_rate_fallback;       /* lowest fallback TX rate */
+
+	/* Fields valid for ver >= 5 */
+	struct {
+		__le32 count;					/* # rates in this set */
+		u8 rates[BRCMF_MAXRATES_IN_SET];		/* rates in 500kbps units w/hi bit set if basic */
+		u8 mcs[BRCMF_MCSSET_LEN];			/* supported mcs index bit map */
+		__le16 vht_mcs[BRCMF_VHT_CAP_MCS_MAP_NSS_MAX];	/* supported mcs index bit map per nss */
+	} rateset_adv;
 };
 
 struct brcmf_chanspec_list {
-- 
2.13.7
