Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:13917 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbaELIrq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 04:47:46 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 09/14] brcm80211: extend channel conversion functions for 80MHz support
Date: Mon, 12 May 2014 10:47:34 +0200
Message-ID: <1399884459-5048-10-git-send-email-arend@broadcom.com> (sfid-20140512_104754_671057_987CB5C6)
In-Reply-To: <1399884459-5048-1-git-send-email-arend@broadcom.com>
References: <1399884459-5048-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The channel values used by firmware is handled using conversion functions
depending on the type of chip. These functions were already in place but
lacked proper support for 80MHz channel definitions. This patch adds the
support for that.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmutil/d11.c      |   93 ++++++++++++++++----
 drivers/net/wireless/brcm80211/include/brcmu_d11.h |   14 +--
 .../net/wireless/brcm80211/include/brcmu_wifi.h    |    1 +
 3 files changed, 84 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmutil/d11.c b/drivers/net/wireless/brcm80211/brcmutil/d11.c
index 30e54e2..6cbc33d 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/d11.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/d11.c
@@ -21,43 +21,81 @@
 #include <brcmu_wifi.h>
 #include <brcmu_d11.h>
 
-static void brcmu_d11n_encchspec(struct brcmu_chan *ch)
+static u16 d11n_sb(enum brcmu_chan_sb sb)
 {
-	ch->chspec = ch->chnum & BRCMU_CHSPEC_CH_MASK;
+	switch (sb) {
+	case BRCMU_CHAN_SB_NONE:
+		return BRCMU_CHSPEC_D11N_SB_N;
+	case BRCMU_CHAN_SB_L:
+		return BRCMU_CHSPEC_D11N_SB_L;
+	case BRCMU_CHAN_SB_U:
+		return BRCMU_CHSPEC_D11N_SB_U;
+	default:
+		WARN_ON(1);
+	}
+	return 0;
+}
 
-	switch (ch->bw) {
+static u16 d11n_bw(enum brcmu_chan_bw bw)
+{
+	switch (bw) {
 	case BRCMU_CHAN_BW_20:
-		ch->chspec |= BRCMU_CHSPEC_D11N_BW_20 | BRCMU_CHSPEC_D11N_SB_N;
-		break;
+		return BRCMU_CHSPEC_D11N_BW_20;
 	case BRCMU_CHAN_BW_40:
+		return BRCMU_CHSPEC_D11N_BW_40;
 	default:
-		WARN_ON_ONCE(1);
-		break;
+		WARN_ON(1);
 	}
+	return 0;
+}
 
+static void brcmu_d11n_encchspec(struct brcmu_chan *ch)
+{
+	if (ch->bw == BRCMU_CHAN_BW_20)
+		ch->sb = BRCMU_CHAN_SB_NONE;
+
+	brcmu_maskset16(&ch->chspec, BRCMU_CHSPEC_CH_MASK,
+			BRCMU_CHSPEC_CH_SHIFT, ch->chnum);
+	brcmu_maskset16(&ch->chspec, BRCMU_CHSPEC_D11N_SB_MASK,
+			0, d11n_sb(ch->sb));
+	brcmu_maskset16(&ch->chspec, BRCMU_CHSPEC_D11N_BW_MASK,
+			0, d11n_bw(ch->bw));
+
+	ch->chspec &= ~BRCMU_CHSPEC_D11N_BND_MASK;
 	if (ch->chnum <= CH_MAX_2G_CHANNEL)
 		ch->chspec |= BRCMU_CHSPEC_D11N_BND_2G;
 	else
 		ch->chspec |= BRCMU_CHSPEC_D11N_BND_5G;
 }
 
-static void brcmu_d11ac_encchspec(struct brcmu_chan *ch)
+static u16 d11ac_bw(enum brcmu_chan_bw bw)
 {
-	ch->chspec = ch->chnum & BRCMU_CHSPEC_CH_MASK;
-
-	switch (ch->bw) {
+	switch (bw) {
 	case BRCMU_CHAN_BW_20:
-		ch->chspec |= BRCMU_CHSPEC_D11AC_BW_20;
-		break;
+		return BRCMU_CHSPEC_D11AC_BW_20;
 	case BRCMU_CHAN_BW_40:
+		return BRCMU_CHSPEC_D11AC_BW_40;
 	case BRCMU_CHAN_BW_80:
-	case BRCMU_CHAN_BW_80P80:
-	case BRCMU_CHAN_BW_160:
+		return BRCMU_CHSPEC_D11AC_BW_80;
 	default:
-		WARN_ON_ONCE(1);
-		break;
+		WARN_ON(1);
 	}
+	return 0;
+}
 
+static void brcmu_d11ac_encchspec(struct brcmu_chan *ch)
+{
+	if (ch->bw == BRCMU_CHAN_BW_20 || ch->sb == BRCMU_CHAN_SB_NONE)
+		ch->sb = BRCMU_CHAN_SB_L;
+
+	brcmu_maskset16(&ch->chspec, BRCMU_CHSPEC_CH_MASK,
+			BRCMU_CHSPEC_CH_SHIFT, ch->chnum);
+	brcmu_maskset16(&ch->chspec, BRCMU_CHSPEC_D11AC_SB_MASK,
+			BRCMU_CHSPEC_D11AC_SB_SHIFT, ch->sb);
+	brcmu_maskset16(&ch->chspec, BRCMU_CHSPEC_D11AC_BW_MASK,
+			0, d11ac_bw(ch->bw));
+
+	ch->chspec &= ~BRCMU_CHSPEC_D11AC_BND_MASK;
 	if (ch->chnum <= CH_MAX_2G_CHANNEL)
 		ch->chspec |= BRCMU_CHSPEC_D11AC_BND_2G;
 	else
@@ -73,6 +111,7 @@ static void brcmu_d11n_decchspec(struct brcmu_chan *ch)
 	switch (ch->chspec & BRCMU_CHSPEC_D11N_BW_MASK) {
 	case BRCMU_CHSPEC_D11N_BW_20:
 		ch->bw = BRCMU_CHAN_BW_20;
+		ch->sb = BRCMU_CHAN_SB_NONE;
 		break;
 	case BRCMU_CHSPEC_D11N_BW_40:
 		ch->bw = BRCMU_CHAN_BW_40;
@@ -112,6 +151,7 @@ static void brcmu_d11ac_decchspec(struct brcmu_chan *ch)
 	switch (ch->chspec & BRCMU_CHSPEC_D11AC_BW_MASK) {
 	case BRCMU_CHSPEC_D11AC_BW_20:
 		ch->bw = BRCMU_CHAN_BW_20;
+		ch->sb = BRCMU_CHAN_SB_NONE;
 		break;
 	case BRCMU_CHSPEC_D11AC_BW_40:
 		ch->bw = BRCMU_CHAN_BW_40;
@@ -128,6 +168,25 @@ static void brcmu_d11ac_decchspec(struct brcmu_chan *ch)
 		break;
 	case BRCMU_CHSPEC_D11AC_BW_80:
 		ch->bw = BRCMU_CHAN_BW_80;
+		ch->sb = brcmu_maskget16(ch->chspec, BRCMU_CHSPEC_D11AC_SB_MASK,
+					 BRCMU_CHSPEC_D11AC_SB_SHIFT);
+		switch (ch->sb) {
+		case BRCMU_CHAN_SB_LL:
+			ch->chnum -= CH_30MHZ_APART;
+			break;
+		case BRCMU_CHAN_SB_LU:
+			ch->chnum -= CH_10MHZ_APART;
+			break;
+		case BRCMU_CHAN_SB_UL:
+			ch->chnum += CH_10MHZ_APART;
+			break;
+		case BRCMU_CHAN_SB_UU:
+			ch->chnum += CH_30MHZ_APART;
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			break;
+		}
 		break;
 	case BRCMU_CHSPEC_D11AC_BW_8080:
 	case BRCMU_CHSPEC_D11AC_BW_160:
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_d11.h b/drivers/net/wireless/brcm80211/include/brcmu_d11.h
index 8660a2c..f9745ea 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_d11.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_d11.h
@@ -108,13 +108,7 @@ enum brcmu_chan_bw {
 };
 
 enum brcmu_chan_sb {
-	BRCMU_CHAN_SB_NONE = 0,
-	BRCMU_CHAN_SB_L,
-	BRCMU_CHAN_SB_U,
-	BRCMU_CHAN_SB_LL,
-	BRCMU_CHAN_SB_LU,
-	BRCMU_CHAN_SB_UL,
-	BRCMU_CHAN_SB_UU,
+	BRCMU_CHAN_SB_NONE = -1,
 	BRCMU_CHAN_SB_LLL,
 	BRCMU_CHAN_SB_LLU,
 	BRCMU_CHAN_SB_LUL,
@@ -123,6 +117,12 @@ enum brcmu_chan_sb {
 	BRCMU_CHAN_SB_ULU,
 	BRCMU_CHAN_SB_UUL,
 	BRCMU_CHAN_SB_UUU,
+	BRCMU_CHAN_SB_L = BRCMU_CHAN_SB_LLL,
+	BRCMU_CHAN_SB_U = BRCMU_CHAN_SB_LLU,
+	BRCMU_CHAN_SB_LL = BRCMU_CHAN_SB_LLL,
+	BRCMU_CHAN_SB_LU = BRCMU_CHAN_SB_LLU,
+	BRCMU_CHAN_SB_UL = BRCMU_CHAN_SB_LUL,
+	BRCMU_CHAN_SB_UU = BRCMU_CHAN_SB_LUU,
 };
 
 struct brcmu_chan {
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
index 74419d4..76b5d3a 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
@@ -29,6 +29,7 @@
 #define CH_UPPER_SB			0x01
 #define CH_LOWER_SB			0x02
 #define CH_EWA_VALID			0x04
+#define CH_30MHZ_APART			6
 #define CH_20MHZ_APART			4
 #define CH_10MHZ_APART			2
 #define CH_5MHZ_APART			1 /* 2G band channels are 5 Mhz apart */
-- 
1.7.9.5

