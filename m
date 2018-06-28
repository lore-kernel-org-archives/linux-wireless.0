Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38255 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753056AbeF1GTJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 02:19:09 -0400
Received: by mail-lj1-f195.google.com with SMTP id v15-v6so3507924ljk.5
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2018 23:19:08 -0700 (PDT)
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
Subject: [PATCH] brcmfmac: define more bits for the flags of struct brcmf_sta_info_le
Date: Thu, 28 Jun 2018 08:16:13 +0200
Message-Id: <20180628061613.16648-1-zajec5@gmail.com> (sfid-20180628_081914_593247_E49343C4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

That struct is passed by a firmware when querying for STA info. Flags
are used to indicate what info could be obtained.

These new defines may allow passing more info to the cfg80211 in the
future. They had been obtained from Broadcom's SDK file wlioctl_defs.h
used by DD-WRT.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 29 ++++++++++++++++++----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 4b290705e3e6..9b3a58e89dd1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -32,11 +32,30 @@
 #define	BRCMF_BSS_INFO_VERSION	109 /* curr ver of brcmf_bss_info_le struct */
 #define BRCMF_BSS_RSSI_ON_CHANNEL	0x0002
 
-#define BRCMF_STA_WME              0x00000002      /* WMM association */
-#define BRCMF_STA_AUTHE            0x00000008      /* Authenticated */
-#define BRCMF_STA_ASSOC            0x00000010      /* Associated */
-#define BRCMF_STA_AUTHO            0x00000020      /* Authorized */
-#define BRCMF_STA_SCBSTATS         0x00004000      /* Per STA debug stats */
+#define BRCMF_STA_BRCM			0x00000001	/* Running a Broadcom driver */
+#define BRCMF_STA_WME			0x00000002	/* WMM association */
+#define BRCMF_STA_NONERP		0x00000004	/* No ERP */
+#define BRCMF_STA_AUTHE			0x00000008	/* Authenticated */
+#define BRCMF_STA_ASSOC			0x00000010	/* Associated */
+#define BRCMF_STA_AUTHO			0x00000020	/* Authorized */
+#define BRCMF_STA_WDS			0x00000040	/* Wireless Distribution System */
+#define BRCMF_STA_WDS_LINKUP		0x00000080	/* WDS traffic/probes flowing properly */
+#define BRCMF_STA_PS			0x00000100	/* STA is in power save mode from AP's viewpoint */
+#define BRCMF_STA_APSD_BE		0x00000200	/* APSD delv/trigger for AC_BE is default enabled */
+#define BRCMF_STA_APSD_BK		0x00000400	/* APSD delv/trigger for AC_BK is default enabled */
+#define BRCMF_STA_APSD_VI		0x00000800	/* APSD delv/trigger for AC_VI is default enabled */
+#define BRCMF_STA_APSD_VO		0x00001000	/* APSD delv/trigger for AC_VO is default enabled */
+#define BRCMF_STA_N_CAP			0x00002000	/* STA 802.11n capable */
+#define BRCMF_STA_SCBSTATS		0x00004000	/* Per STA debug stats */
+#define BRCMF_STA_AMPDU_CAP		0x00008000	/* STA AMPDU capable */
+#define BRCMF_STA_AMSDU_CAP		0x00010000	/* STA AMSDU capable */
+#define BRCMF_STA_MIMO_PS		0x00020000	/* mimo ps mode is enabled */
+#define BRCMF_STA_MIMO_RTS		0x00040000	/* send rts in mimo ps mode */
+#define BRCMF_STA_RIFS_CAP		0x00080000	/* rifs enabled */
+#define BRCMF_STA_VHT_CAP		0x00100000	/* STA VHT(11ac) capable */
+#define BRCMF_STA_WPS			0x00200000	/* WPS state */
+#define BRCMF_STA_DWDS_CAP		0x01000000	/* DWDS CAP */
+#define BRCMF_STA_DWDS			0x02000000	/* DWDS active */
 
 /* size of brcmf_scan_params not including variable length array */
 #define BRCMF_SCAN_PARAMS_FIXED_SIZE	64
-- 
2.13.7
