Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:45125 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaGTLAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 07:00:47 -0400
Received: by mail-wg0-f52.google.com with SMTP id a1so5227897wgh.35
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 04:00:46 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: implement PPR (Power Per Rate) management/API
Date: Sun, 20 Jul 2014 13:00:21 +0200
Message-Id: <1405854022-11833-1-git-send-email-zajec5@gmail.com> (sfid-20140720_130051_149218_D624C5A0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Broadcom hardware supports auto-adjustment of TX power depending on the
currently used rate. So far all calculations were handled without any
helpers (API) using big arrays and magic offsets.
It seems Broadcom recently decided to clean this up by developing PPR.
Their wlc_ppr.h can be found in open parts of the SDK.
As we plan to implement support for rate-based TX power it makes sense
to also implement our version of PPR as well.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Makefile |   1 +
 drivers/net/wireless/b43/b43.h    |   7 ++
 drivers/net/wireless/b43/ppr.c    | 210 ++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/ppr.h    |  21 ++++
 4 files changed, 239 insertions(+)
 create mode 100644 drivers/net/wireless/b43/ppr.c
 create mode 100644 drivers/net/wireless/b43/ppr.h

diff --git a/drivers/net/wireless/b43/Makefile b/drivers/net/wireless/b43/Makefile
index 6e00b88..9f7965a 100644
--- a/drivers/net/wireless/b43/Makefile
+++ b/drivers/net/wireless/b43/Makefile
@@ -18,6 +18,7 @@ b43-y				+= xmit.o
 b43-y				+= dma.o
 b43-y				+= pio.o
 b43-y				+= rfkill.o
+b43-y				+= ppr.o
 b43-$(CONFIG_B43_LEDS)		+= leds.o
 b43-$(CONFIG_B43_PCMCIA)	+= pcmcia.o
 b43-$(CONFIG_B43_SDIO)		+= sdio.o
diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 4113b69..6cfd86d 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -791,6 +791,13 @@ struct b43_firmware {
 	bool pcm_request_failed;
 };
 
+enum b43_band {
+	B43_BAND_2G = 0,
+	B43_BAND_5G_LO = 1,
+	B43_BAND_5G_MI = 2,
+	B43_BAND_5G_HI = 3,
+};
+
 /* Device (802.11 core) initialization status. */
 enum {
 	B43_STAT_UNINIT = 0,	/* Uninitialized. */
diff --git a/drivers/net/wireless/b43/ppr.c b/drivers/net/wireless/b43/ppr.c
new file mode 100644
index 0000000..36c4b419
--- /dev/null
+++ b/drivers/net/wireless/b43/ppr.c
@@ -0,0 +1,210 @@
+#include "ppr.h"
+#include "b43.h"
+
+#define B43_PPR_CCK_RATES_NUM		4
+#define B43_PPR_OFDM_RATES_NUM		8
+#define B43_PPR_MCS_RATES_NUM		8
+
+#define B43_PPR_RATES_NUM	(B43_PPR_CCK_RATES_NUM +	\
+				 B43_PPR_OFDM_RATES_NUM * 2 +	\
+				 B43_PPR_MCS_RATES_NUM * 4)
+
+struct b43_ppr_rates {
+	u8 cck[B43_PPR_CCK_RATES_NUM];
+	u8 ofdm[B43_PPR_OFDM_RATES_NUM];
+	u8 ofdm_20_cdd[B43_PPR_OFDM_RATES_NUM];
+	u8 mcs_20[B43_PPR_MCS_RATES_NUM]; /* SISO */
+	u8 mcs_20_cdd[B43_PPR_MCS_RATES_NUM];
+	u8 mcs_20_stbc[B43_PPR_MCS_RATES_NUM];
+	u8 mcs_20_sdm[B43_PPR_MCS_RATES_NUM];
+} __packed;
+
+struct b43_ppr {
+	/* All powers are in qdbm (Q5.2) */
+	union {
+		u8 __all_rates[B43_PPR_RATES_NUM];
+		struct b43_ppr_rates rates;
+	} __packed;
+};
+
+#define ppr_for_each_entry(ppr, i, entry)				\
+	for (i = 0, entry = &(ppr)->__all_rates[i];			\
+	     i < B43_PPR_RATES_NUM;					\
+	     i++, entry++)
+
+struct b43_ppr *b43_ppr_alloc(struct b43_wldev *dev)
+{
+	return kzalloc(sizeof(struct b43_ppr), GFP_KERNEL);
+}
+
+void b43_ppr_clear(struct b43_wldev *dev, struct b43_ppr *ppr)
+{
+	memset(ppr, 0, sizeof(*ppr));
+}
+
+void b43_ppr_add(struct b43_wldev *dev, struct b43_ppr *ppr, int diff)
+{
+	int i;
+	u8 *rate;
+
+	ppr_for_each_entry(ppr, i, rate) {
+		*rate = clamp_val(*rate + diff, 0, 127);
+	}
+}
+
+void b43_ppr_apply_max(struct b43_wldev *dev, struct b43_ppr *ppr, u8 max)
+{
+	int i;
+	u8 *rate;
+
+	ppr_for_each_entry(ppr, i, rate) {
+		*rate = min(*rate, max);
+	}
+}
+
+void b43_ppr_apply_min(struct b43_wldev *dev, struct b43_ppr *ppr, u8 min)
+{
+	int i;
+	u8 *rate;
+
+	ppr_for_each_entry(ppr, i, rate) {
+		*rate = max(*rate, min);
+	}
+}
+
+u8 b43_ppr_get_max(struct b43_wldev *dev, struct b43_ppr *ppr)
+{
+	u8 res = 0;
+	int i;
+	u8 *rate;
+
+	ppr_for_each_entry(ppr, i, rate) {
+		res = max(*rate, res);
+	}
+
+	return res;
+}
+
+bool b43_ppr_load_max_from_sprom(struct b43_wldev *dev, struct b43_ppr *ppr,
+				 enum b43_band band)
+{
+	struct b43_ppr_rates *rates = &ppr->rates;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
+	struct b43_phy *phy = &dev->phy;
+	u8 maxpwr, off;
+	u32 *sprom_ofdm_po;
+	u16 *sprom_mcs_po;
+	u8 extra_cdd_po, extra_stbc_po;
+	int i;
+
+	switch (band) {
+	case B43_BAND_2G:
+		maxpwr = min(sprom->core_pwr_info[0].maxpwr_2g,
+			     sprom->core_pwr_info[1].maxpwr_2g);
+		sprom_ofdm_po = &sprom->ofdm2gpo;
+		sprom_mcs_po = sprom->mcs2gpo;
+		extra_cdd_po = (sprom->cddpo >> 0) & 0xf;
+		extra_stbc_po = (sprom->stbcpo >> 0) & 0xf;
+		break;
+	case B43_BAND_5G_LO:
+		maxpwr = min(sprom->core_pwr_info[0].maxpwr_5gl,
+			     sprom->core_pwr_info[1].maxpwr_5gl);
+		sprom_ofdm_po = &sprom->ofdm5glpo;
+		sprom_mcs_po = sprom->mcs5glpo;
+		extra_cdd_po = (sprom->cddpo >> 8) & 0xf;
+		extra_stbc_po = (sprom->stbcpo >> 8) & 0xf;
+		break;
+	case B43_BAND_5G_MI:
+		maxpwr = min(sprom->core_pwr_info[0].maxpwr_5g,
+			     sprom->core_pwr_info[1].maxpwr_5g);
+		sprom_ofdm_po = &sprom->ofdm5gpo;
+		sprom_mcs_po = sprom->mcs5gpo;
+		extra_cdd_po = (sprom->cddpo >> 4) & 0xf;
+		extra_stbc_po = (sprom->stbcpo >> 4) & 0xf;
+		break;
+	case B43_BAND_5G_HI:
+		maxpwr = min(sprom->core_pwr_info[0].maxpwr_5gh,
+			     sprom->core_pwr_info[1].maxpwr_5gh);
+		sprom_ofdm_po = &sprom->ofdm5ghpo;
+		sprom_mcs_po = sprom->mcs5ghpo;
+		extra_cdd_po = (sprom->cddpo >> 12) & 0xf;
+		extra_stbc_po = (sprom->stbcpo >> 12) & 0xf;
+		break;
+	default:
+		BUG_ON(1);
+		return false;
+	}
+
+	if (band == B43_BAND_2G) {
+		for (i = 0; i < 4; i++) {
+			off = ((sprom->cck2gpo >> (i * 4)) & 0xF) * 2;
+			rates->cck[i] = maxpwr - off;
+		}
+	}
+
+	/* OFDM */
+	for (i = 0; i < 8; i++) {
+		off = ((*sprom_ofdm_po >> (i * 4)) & 0xF) * 2;
+		rates->ofdm[i] = maxpwr - off;
+	}
+
+	/* MCS 20 SISO */
+	rates->mcs_20[0] = rates->ofdm[0];
+	rates->mcs_20[1] = rates->ofdm[2];
+	rates->mcs_20[2] = rates->ofdm[3];
+	rates->mcs_20[3] = rates->ofdm[4];
+	rates->mcs_20[4] = rates->ofdm[5];
+	rates->mcs_20[5] = rates->ofdm[6];
+	rates->mcs_20[6] = rates->ofdm[7];
+	rates->mcs_20[7] = rates->ofdm[7];
+
+	/* MCS 20 CDD */
+	for (i = 0; i < 4; i++) {
+		off = ((sprom_mcs_po[0] >> (i * 4)) & 0xF) * 2;
+		rates->mcs_20_cdd[i] = maxpwr - off;
+		if (phy->type == B43_PHYTYPE_N && phy->rev >= 3)
+			rates->mcs_20_cdd[i] -= extra_cdd_po;
+	}
+	for (i = 0; i < 4; i++) {
+		off = ((sprom_mcs_po[1] >> (i * 4)) & 0xF) * 2;
+		rates->mcs_20_cdd[4 + i] = maxpwr - off;
+		if (phy->type == B43_PHYTYPE_N && phy->rev >= 3)
+			rates->mcs_20_cdd[i] -= extra_cdd_po;
+	}
+
+	/* OFDM 20 CDD */
+	rates->ofdm_20_cdd[0] = rates->mcs_20_cdd[0];
+	rates->ofdm_20_cdd[1] = rates->mcs_20_cdd[0];
+	rates->ofdm_20_cdd[2] = rates->mcs_20_cdd[1];
+	rates->ofdm_20_cdd[3] = rates->mcs_20_cdd[2];
+	rates->ofdm_20_cdd[4] = rates->mcs_20_cdd[3];
+	rates->ofdm_20_cdd[5] = rates->mcs_20_cdd[4];
+	rates->ofdm_20_cdd[6] = rates->mcs_20_cdd[5];
+	rates->ofdm_20_cdd[7] = rates->mcs_20_cdd[6];
+
+	/* MCS 20 STBC */
+	for (i = 0; i < 4; i++) {
+		off = ((sprom_mcs_po[0] >> (i * 4)) & 0xF) * 2;
+		rates->mcs_20_stbc[i] = maxpwr - off;
+		if (phy->type == B43_PHYTYPE_N && phy->rev >= 3)
+			rates->mcs_20_stbc[i] -= extra_stbc_po;
+	}
+	for (i = 0; i < 4; i++) {
+		off = ((sprom_mcs_po[1] >> (i * 4)) & 0xF) * 2;
+		rates->mcs_20_stbc[4 + i] = maxpwr - off;
+		if (phy->type == B43_PHYTYPE_N && phy->rev >= 3)
+			rates->mcs_20_stbc[i] -= extra_stbc_po;
+	}
+
+	/* MCS 20 SDM */
+	for (i = 0; i < 4; i++) {
+		off = ((sprom_mcs_po[2] >> (i * 4)) & 0xF) * 2;
+		rates->mcs_20_sdm[i] = maxpwr - off;
+	}
+	for (i = 0; i < 4; i++) {
+		off = ((sprom_mcs_po[3] >> (i * 4)) & 0xF) * 2;
+		rates->mcs_20_sdm[4 + i] = maxpwr - off;
+	}
+
+	return true;
+}
diff --git a/drivers/net/wireless/b43/ppr.h b/drivers/net/wireless/b43/ppr.h
new file mode 100644
index 0000000..5a96c31
--- /dev/null
+++ b/drivers/net/wireless/b43/ppr.h
@@ -0,0 +1,21 @@
+#ifndef LINUX_B43_PPR_H_
+#define LINUX_B43_PPR_H_
+
+#include <linux/types.h>
+
+struct b43_ppr;
+struct b43_wldev;
+enum b43_band;
+
+struct b43_ppr *b43_ppr_alloc(struct b43_wldev *dev);
+void b43_ppr_clear(struct b43_wldev *dev, struct b43_ppr *ppr);
+
+void b43_ppr_add(struct b43_wldev *dev, struct b43_ppr *ppr, int diff);
+void b43_ppr_apply_max(struct b43_wldev *dev, struct b43_ppr *ppr, u8 max);
+void b43_ppr_apply_min(struct b43_wldev *dev, struct b43_ppr *ppr, u8 min);
+u8 b43_ppr_get_max(struct b43_wldev *dev, struct b43_ppr *ppr);
+
+bool b43_ppr_load_max_from_sprom(struct b43_wldev *dev, struct b43_ppr *ppr,
+				 enum b43_band band);
+
+#endif /* LINUX_B43_PPR_H_ */
-- 
1.8.4.5

