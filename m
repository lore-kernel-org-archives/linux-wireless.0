Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.21.23.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793538482;
	b=CNrqrd6E2XXOKnj6wViNtViVp0R1DDDbdiL1ptGADUeaz4NhTCDduOXsaGAzZvjU/KWf
	 +TIGnA5boGPyNXOIFrgGAwDpVKP1T1v4FNjKOkM+4ZeSFSCdbj/XUoftP2RZqfMy46OT8
	 L2LAG1/MhAagJPfhuIcNs7OG/VsGEcIRCocHpiwsaZT8p/cbfbSwOji/krvg7q3i0vgrf
	 bOFP1Z637i0tFtW5zCV5ePvq7oErhpjVAFBhAUNQASEbBnAl3p19lZlbAs7TEkRFyiHjD
	 JQRrrDjqd8usbP3YTSygrFKyNaQFaOaWKGBXzs6fklcn4F/OLb6XQd7Rv75RUF2XP3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793538482;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:From:
	 To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding;
	bh=LOQrackOzvulQI55Fofmx0K19518DzUS4ZJZrJER7nw=;
	b=CQ7JP0O8BqNfR+at50PH1KB9MZyPxgC+BT8S6rf3wMATEqG6JTzTbOvUYzjgPGsWLF0k
	 RK2SNGcszlQn2aLVuoX6zbhQ0zq4kt+ocS6+kjbnjqrtZkSzFfq6Ri3sFtWn8odO/i1eO
	 vmBwdvq9FeMwX2CtsGs35RwbkObaYwF80xEuDMiu4+DkBNCGcNwh9xxop/32GgFyc0Wll
	 EMJmXntEdURySbVAvRFUvwvdFQ0CTu6LZwJ4VJ/4QeQDGtLec9SbzYyJXvfMw/zLP5uP6
	 +Lr+zza7Unq5VgeE0gr7DwiZlwKJZADVp2nWcqU25P+snCwWWTjGoJlcq/bXgDDHxOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=disroot.org;
	spf=pass smtp.mailfrom=disroot.org;
	dkim=pass header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b=jIuWhcRY;
	arc=none smtp.remote-ip=178.21.23.139
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EBD606A324
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 13:08:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62EBD606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b=jIuWhcRY
Received: from mail01.layka.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 8CF58808FD;
	Sun, 01 Nov 2026 14:07:59 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id 5ktr9ptBA5tb; Sun,  1 Nov 2026 14:07:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1793538478; bh=M4EvY79seuh0PY4SqDq/uHtRoc9q07ywIr0wat10wvk=;
	h=From:To:Cc:Subject:Date;
	b=jIuWhcRYwPfJ+8uX6D59stGo0x9vXdgUF0o8nRcfniGtbX+4dNO8lKB4ecIAz2wJB
	 2UwmxQzePP5wE/22W3E0mPtA1a8dhF0wOSFSUWgfA8TaKrF7sahNN3Cy9RFF6+kURX
	 hUfATHZWU3Y+wBqdRSIu41hnRH1NhdBp2gDKIqz1vd59JyTaZVu+uDjbMEbj4i8A59
	 cfIUKqbOMLlc0tbQoxk5Bq8/HC23WYjJ07fMhZGwqplBIbq94YTpomsAwVX6cvz5Jb
	 zetFNhWNXFO9H6Goz6l7y94WRkmPuWmwVLAe6k8hEPm6Tkvs3ezhIK6dF82H2nJB6a
	 KtrAgWhoQtY9Q==
From: Florian Maurer <fmaurer@disroot.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Florian Maurer <fmaurer@disroot.org>,
	linux-wireless@vger.kernel.org,
	Simon Schippers <simon.schippers@tu-dortmund.de>
Subject: [PATCH wireless-next] wifi: mac80211: mesh: notify driver of peer capability changes
Date: Sun,  1 Nov 2026 13:06:36 +0000
Message-ID: <20261101130636.1867958-1-fmaurer@disroot.org>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mesh_sta_info_init() updates the supported rates and HT/VHT/HE/EHT
capabilities of a mesh peer whenever it (re)joins, e.g. after it left
and joined again with a different channel width or HT mode while its
station entry was kept. The changes are only propagated through
rate_control_rate_update() if WLAN_STA_RATE_CONTROL is set.

That flag is set by rate_control_rate_init() only when a software rate
control algorithm is in use. With hardware rate control
(IEEE80211_HW_HAS_RATE_CONTROL, e.g. ath10k, ath11k) it is never set,
so every call ends up in rate_control_rate_init(), which returns early
without software rate control, and the driver is never told about the
new capabilities. The firmware then keeps using the rates from the
initial peer setup, e.g. legacy rates when the peer was first seen
without HT, until the station is removed.

With hardware rate control, tell the driver about changes of a station
that is already uploaded via drv_link_sta_rc_update(), the same way
IBSS does in ieee80211_update_sta_info(): report them as
IEEE80211_RC_SUPP_RATES_CHANGED, plus IEEE80211_RC_NSS_CHANGED if
rx_nss changed, so that the driver sets up the rates of the peer
again. Also detect changed VHT/HE/EHT capabilities and rx_nss, which
were not reported at all so far. The callback must be atomic, so
calling it under plink_lock is fine. A pure bandwidth change on a
rejoin, e.g. HT20 -> HT40+, is then also reported to the driver, as
IEEE80211_RC_BW_CHANGED | IEEE80211_RC_SUPP_RATES_CHANGED.

Keep the existing behaviour for software rate control, apart from now
also getting IEEE80211_RC_SUPP_RATES_CHANGED for VHT/HE/EHT changes and
IEEE80211_RC_NSS_CHANGED for rx_nss changes.

Signed-off-by: Florian Maurer <fmaurer@disroot.org>
---
This touches the same FIXME as Simon's RFC [1], but addresses a
different case: a peer whose capabilities change between peerings.
It does not change anything for an established peer, so it does not
help when a peer comes back with the same capabilities.

Tested on IPQ8074 (ath11k, WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1)
with an equivalent change (rx_nss is derived elsewhere on 6.18)
backported to backports-6.18.55 (OpenWrt 25.12), build-tested (W=1) and
tested with mac80211_hwsim on wireless-next. In an open mesh (kernel
MPM) with a peering first set up without HT, then the peer rejoining
with HT20 while its station entry was kept, the tx rate to the peer went
from 54 Mbit/s to 229.4 Mbit/s (HE-MCS 9, NSS 2), like a fresh HT20
peering (206.5 Mbit/s, HE-MCS 8, NSS 2), and back to 54 Mbit/s for
HT20 -> NOHT. Without this change it stays at 54 Mbit/s after
NOHT -> HT20.

The software rate control part was only tested with mac80211_hwsim
(minstrel_ht, open mesh with kernel MPM, one peer leaving and rejoining
with NOHT/HT20/HT40+ for 12 cycles). The changed flags passed to
rate_control_rate_update() go from IEEE80211_RC_BW_CHANGED to
BW|SUPP_RATES|NSS on NOHT <-> HT20, the minstrel rate table follows
each rejoin as before. With hwsim mlo=1 (IEEE80211_HW_HAS_RATE_CONTROL)
the driver's link_sta_rc_update is now called on each rejoin; without
the patch it never is. In the mlo=1 pass both runs, with and without
the patch, hit the same pre-existing WARNs (rx.c:5640, rx.c:5711,
mac80211_hwsim_main.c:2270, mac80211.h:3428), some of them more often
with the patch. There were no new WARN sites and no lockdep or KASAN
reports.

Known limitation: if the peer rejoins while the local plink is still
ESTAB (e.g. a fast reboot), the early exit at the top of
mesh_sta_info_init() still skips parsing the new capabilities. I left
that alone, since it needs a separate change of when capabilities are
re-read.

[1] https://lore.kernel.org/linux-wireless/20260202133532.814017-1-simon.schippers@tu-dortmund.de/

 net/mac80211/mesh_plink.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 6ce3ae3fb39b..1412be92e8ba 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -430,6 +430,10 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_supported_band *sband;
 	u32 rates, changed = 0;
 	enum ieee80211_sta_rx_bandwidth bw = sta->sta.deflink.bandwidth;
+	struct ieee80211_sta_vht_cap vht_cap;
+	struct ieee80211_sta_he_cap he_cap;
+	struct ieee80211_sta_eht_cap eht_cap;
+	u8 rx_nss;
 
 	sband = ieee80211_get_sband(sdata);
 	if (!sband)
@@ -450,6 +454,11 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 		changed |= IEEE80211_RC_SUPP_RATES_CHANGED;
 	sta->sta.deflink.supp_rates[sband->band] = rates;
 
+	memcpy(&vht_cap, &sta->sta.deflink.vht_cap, sizeof(vht_cap));
+	memcpy(&he_cap, &sta->sta.deflink.he_cap, sizeof(he_cap));
+	memcpy(&eht_cap, &sta->sta.deflink.eht_cap, sizeof(eht_cap));
+	rx_nss = sta->sta.deflink.rx_nss;
+
 	if (ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, &sband->ht_cap,
 					      elems->ht_cap_elem,
 					      &sta->deflink))
@@ -473,6 +482,14 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	ieee80211_sta_init_nss_bw_capa(&sta->deflink,
 				       &sdata->deflink.conf->chanreq.oper);
 
+	if (memcmp(&vht_cap, &sta->sta.deflink.vht_cap, sizeof(vht_cap)) ||
+	    memcmp(&he_cap, &sta->sta.deflink.he_cap, sizeof(he_cap)) ||
+	    memcmp(&eht_cap, &sta->sta.deflink.eht_cap, sizeof(eht_cap)))
+		changed |= IEEE80211_RC_SUPP_RATES_CHANGED;
+
+	if (sta->sta.deflink.rx_nss != rx_nss)
+		changed |= IEEE80211_RC_NSS_CHANGED;
+
 	if (bw != sta->sta.deflink.bandwidth)
 		changed |= IEEE80211_RC_BW_CHANGED;
 
@@ -485,11 +502,20 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 		sta->sta.deflink.bandwidth = IEEE80211_STA_RX_BW_20;
 	}
 
-	/* FIXME: this check is wrong without SW rate control */
-	if (!test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
-		rate_control_rate_init(&sta->deflink);
-	else
+	if (test_sta_flag(sta, WLAN_STA_RATE_CONTROL)) {
 		rate_control_rate_update(local, sband, &sta->deflink, changed);
+		goto out;
+	}
+
+	/* WLAN_STA_RATE_CONTROL is never set with hardware rate control, so
+	 * tell the driver about changed capabilities of an uploaded station,
+	 * e.g. of a peer that rejoined. As in IBSS, report them as changed
+	 * supported rates.
+	 */
+	rate_control_rate_init(&sta->deflink);
+	if (changed && sta->uploaded)
+		drv_link_sta_rc_update(local, sdata, &sta->sta.deflink,
+				       changed | IEEE80211_RC_SUPP_RATES_CHANGED);
 out:
 	spin_unlock_bh(&sta->mesh->plink_lock);
 }
-- 
2.47.3

