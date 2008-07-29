Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17144 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbYG2Frl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:41 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 22:47:41 -0700
From: <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>,
	Sujith Manoharan <smanoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 10/16] ath9k: Don't pass opmode twice to ath_vap_attach, return standard error values from add_interface.
Date: Mon, 28 Jul 2008 22:47:19 -0700
Message-ID: <d35b1b20a436e231abf4a74c3609955ad02d54c9.1217309552.git.lrodriguez@atheros.com> (sfid-20080729_081547_181022_ACCF5454)
In-Reply-To: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <smanoharan@atheros.com>

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index b6281e5..25ae517 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -627,7 +627,6 @@ int ath_vap_attach(struct ath_softc *sc,
 		   int if_id,
 		   struct ieee80211_vif *if_data,
 		   enum hal_opmode opmode,
-		   enum hal_opmode iv_opmode,
 		   int nostabeacons)
 {
 	struct ath_vap *avp;
@@ -664,7 +663,7 @@ int ath_vap_attach(struct ath_softc *sc,
 	memzero(avp, sizeof(struct ath_vap));
 	avp->av_if_data = if_data;
 	/* Set the VAP opmode */
-	avp->av_opmode = iv_opmode;
+	avp->av_opmode = opmode;
 	avp->av_bslot = -1;
 	INIT_LIST_HEAD(&avp->av_mcastq.axq_q);
 	INIT_LIST_HEAD(&avp->av_mcastq.axq_acq);
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 7024c90..10ec3ae 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -799,7 +799,6 @@ int ath_vap_attach(struct ath_softc *sc,
 		   int if_id,
 		   struct ieee80211_vif *if_data,
 		   enum hal_opmode opmode,
-		   enum hal_opmode iv_opmode,
 		   int nostabeacons);
 int ath_vap_detach(struct ath_softc *sc, int if_id);
 int ath_vap_config(struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 7a8b42e..59f1204 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -395,7 +395,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	/* Support only vap for now */
 
 	if (sc->sc_nvaps)
-		return -1;
+		return -ENOBUFS;
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
@@ -405,24 +405,25 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		ic_opmode = HAL_M_IBSS;
 		break;
 	default:
-		break;
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: Only STA and IBSS are supported currently\n",
+			__func__);
+		return -EOPNOTSUPP;
 	}
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Attach a VAP of type: %d\n",
 		__func__,
 		ic_opmode);
 
-	error = ath_vap_attach(sc, 0, conf->vif, ic_opmode, ic_opmode, 0);
+	error = ath_vap_attach(sc, 0, conf->vif, ic_opmode, 0);
 	if (error) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: Unable to attach vap, error: %d\n",
 			__func__, error);
-		goto bad;
+		return error;
 	}
 
 	return 0;
-bad:
-	return -1;
 }
 
 static void ath9k_remove_interface(struct ieee80211_hw *hw,
-- 
1.5.4.3

