Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3344 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025Ab1GVS5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 14:57:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 05/29] staging: brcm80211: remove unused rx status
 definitions
Date: Fri, 22 Jul 2011 20:56:52 +0200
Message-ID: <1311361036-3175-6-git-send-email-arend@broadcom.com> (sfid-20110722_205741_086935_D50B19AC)
In-Reply-To: <1311361036-3175-1-git-send-email-arend@broadcom.com>
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The file pub.h contained a number of definitions that are not
used in the brcmsmac driver and consequently have been removed.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/pub.h |   33 ------------------------------
 1 files changed, 0 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 9b847b3..bfbdc3a 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -308,39 +308,6 @@ struct wl_rxsts {
 	struct brcms_if *wlif;	/* wl interface */
 };
 
-/* status per error RX pkt */
-#define WL_RXS_CRC_ERROR		0x00000001	/* CRC Error in packet */
-#define WL_RXS_RUNT_ERROR		0x00000002	/* Runt packet */
-#define WL_RXS_ALIGN_ERROR		0x00000004	/* Misaligned packet */
-#define WL_RXS_OVERSIZE_ERROR		0x00000008	/* packet bigger than RX_LENGTH (usually 1518) */
-#define WL_RXS_WEP_ICV_ERROR		0x00000010	/* Integrity Check Value error */
-#define WL_RXS_WEP_ENCRYPTED		0x00000020	/* Encrypted with WEP */
-#define WL_RXS_PLCP_SHORT		0x00000040	/* Short PLCP error */
-#define WL_RXS_DECRYPT_ERR		0x00000080	/* Decryption error */
-#define WL_RXS_OTHER_ERR		0x80000000	/* Other errors */
-
-/* phy type */
-#define WL_RXS_PHY_A			0x00000000	/* A phy type */
-#define WL_RXS_PHY_B			0x00000001	/* B phy type */
-#define WL_RXS_PHY_G			0x00000002	/* G phy type */
-#define WL_RXS_PHY_N			0x00000004	/* N phy type */
-
-/* encoding */
-#define WL_RXS_ENCODING_CCK		0x00000000	/* CCK encoding */
-#define WL_RXS_ENCODING_OFDM		0x00000001	/* OFDM encoding */
-
-/* preamble */
-#define WL_RXS_UNUSED_STUB		0x0	/* stub to match with wlc_ethereal.h */
-#define WL_RXS_PREAMBLE_SHORT		0x00000001	/* Short preamble */
-#define WL_RXS_PREAMBLE_LONG		0x00000002	/* Long preamble */
-#define WL_RXS_PREAMBLE_MIMO_MM		0x00000003	/* MIMO mixed mode preamble */
-#define WL_RXS_PREAMBLE_MIMO_GF		0x00000004	/* MIMO green field preamble */
-
-#define WL_RXS_NFRM_AMPDU_FIRST		0x00000001	/* first MPDU in A-MPDU */
-#define WL_RXS_NFRM_AMPDU_SUB		0x00000002	/* subsequent MPDU(s) in A-MPDU */
-#define WL_RXS_NFRM_AMSDU_FIRST		0x00000004	/* first MSDU in A-MSDU */
-#define WL_RXS_NFRM_AMSDU_SUB		0x00000008	/* subsequent MSDU(s) in A-MSDU */
-
 enum wlc_par_id {
 	IOV_MPC = 1,
 	IOV_RTSTHRESH,
-- 
1.7.4.1


