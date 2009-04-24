Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42427 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbZDXTpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 15:45:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: remove some (bogus?) 'may be used uninitialized' warnings
Date: Fri, 24 Apr 2009 15:39:18 -0400
Message-Id: <1240601958-7273-2-git-send-email-linville@tuxdriver.com> (sfid-20090424_214558_529941_F82A5B69)
In-Reply-To: <1240601958-7273-1-git-send-email-linville@tuxdriver.com>
References: <1240601958-7273-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net/mac80211/tx.c: In function =E2=80=98ieee80211_tx_h_select_key=E2=80=
=99:
net/mac80211/tx.c:448: warning: =E2=80=98key=E2=80=99 may be used unini=
tialized in this function

drivers/net/wireless/ath/ath9k/rc.c: In function =E2=80=98ath_rc_rate_g=
etidx=E2=80=99:
drivers/net/wireless/ath/ath9k/rc.c:815: warning: =E2=80=98nextindex=E2=
=80=99 may be used uninitialized in this function

drivers/net/wireless/hostap/hostap_plx.c: In function =E2=80=98prism2_p=
lx_probe=E2=80=99:
drivers/net/wireless/hostap/hostap_plx.c:438: warning: =E2=80=98cor_ind=
ex=E2=80=99 may be used uninitialized in this function
drivers/net/wireless/hostap/hostap_plx.c:438: warning: =E2=80=98cor_off=
set=E2=80=99 may be used uninitialized in this function

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/rc.c      |    2 +-
 drivers/net/wireless/hostap/hostap_plx.c |    2 +-
 net/mac80211/tx.c                        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless=
/ath/ath9k/rc.c
index a13668b..8f3cf10 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -812,7 +812,7 @@ static u8 ath_rc_rate_getidx(struct ath_softc *sc,
 			     u16 min_rate)
 {
 	u32 j;
-	u8 nextindex;
+	u8 nextindex =3D 0;
=20
 	if (min_rate) {
 		for (j =3D RATE_TABLE_SIZE; j > 0; j--) {
diff --git a/drivers/net/wireless/hostap/hostap_plx.c b/drivers/net/wir=
eless/hostap/hostap_plx.c
index cbf15d7..0e5d510 100644
--- a/drivers/net/wireless/hostap/hostap_plx.c
+++ b/drivers/net/wireless/hostap/hostap_plx.c
@@ -435,7 +435,7 @@ static int prism2_plx_probe(struct pci_dev *pdev,
 	unsigned long pccard_attr_mem;
 	unsigned int pccard_attr_len;
 	void __iomem *attr_mem =3D NULL;
-	unsigned int cor_offset, cor_index;
+	unsigned int cor_offset =3D 0, cor_index =3D 0;
 	u32 reg;
 	local_info_t *local =3D NULL;
 	struct net_device *dev =3D NULL;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9ab4982..1865622 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -445,7 +445,7 @@ ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_key *key;
+	struct ieee80211_key *key =3D NULL;
 	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)tx->skb->data;
=20
--=20
1.6.0.6

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
