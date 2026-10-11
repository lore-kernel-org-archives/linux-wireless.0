Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBC03BED35
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 12:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791722202; cv=none; b=gRUGdkTRfTYfd0xxogcw0XyoYM4GotebZElB391AVYo5FXe55p2qZFr5SOkUvmxTXe2XbIPergM+poGcaA1VFK6VieEYanBpIQXzE2VFx3i8cCsIfQtgWbu+u5834Glq2dw0kCnu1/7enXKhRTXMMht4GDFVE9vFyGMoHq+nOys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791722202; c=relaxed/simple;
	bh=e4EvqaQnW0lErPnImlp7Aleqv64KBBMOESgvdtVPhG0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SGFiFv1r9QR0xJJaZsxLHiMk534aCJ634iZPStHNezm4c+BIiO6FVmnaL4HArVzlR98nemhT3VHjKmqQEOAipwK6ciNlK1d7tMe1f8BO3V9Y0IsWyfajOhMm3L4djJq3hn8We8gwJivM3ZMutYvuiWei7kZyKG8BknQZgkCwKyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=ds3lUStY; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="ds3lUStY"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c31745ad205so507945566b.0
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 05:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791722195; x=1792326995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pzss4JcabUItox2qeyTRJ/af2NkdjCKndfZJuFTzwT4=;
        b=ds3lUStYBtjg4dUJw4bq4iPULjzAT/hCkRPJ6RWuoIGLWcUmx9NOqFqwihd5e2FtMt
         apNkf204jyTo+4wR5nEsghxCU2rh47zbktlHgu+bmGbQkAyjnjhsva/lLQ+fqHLSqKWm
         NdnBtKrOFGPxV+Q/ZeDbDxnzhsXWrii/XRvPt9q/dRBoPCvyLNWMX0x3Iw0q0L1LtmFQ
         dPWdk+PuzyjRQ6ESHw99Y1W4PlT9KDm/tmePLmpytsSlWE0WGR/K2MRqD8L1RfHVbq10
         e08yKcCVY4WZ3CzclSz2OPssfoYPSNBnG5Xgb66QtNSrXP7D7uo14CruCpV3JMnbu6BQ
         vhQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791722195; x=1792326995;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pzss4JcabUItox2qeyTRJ/af2NkdjCKndfZJuFTzwT4=;
        b=cZIsM1dnqeyM9yAt6op489X059LCdNZYuEFgOl3u0hFTqvd3P3vZih9zqmBlNHd806
         TldwMXCmmikXwOz1thUDO5pWXKNxIfsvRx0YQ6rJe09nuYq6CQf61/OPe4dVUZKiEVBG
         qCRk3cW+EwQ/kghE+BGueQLyuUMS1xR8oawjgYPiBLZSzNo4HAese4ZQHub6ci7E9nCr
         XSg4vlQo9Z+0tMKFU25zhtoIlSCflihHFqxfBmtvr3WuffPDHL+hlO+x9rHUCgEC4cV1
         YbJVloFDibBA/a3kjJLeaUcLuXAT2bKMXyHV2Re99+s2h9MANxIAZYOuVvWLfR0EC7nv
         gJuw==
X-Forwarded-Encrypted: i=1; AKwUvByQq4Jlyir9loWaummRNBq6l+2Ibdbze21jI8mTE9efzm+/L/OABzB7ZAvEo4SACJ+IJRPvqabh6s/KeWjSOw==@vger.kernel.org
X-Gm-Message-State: AFq9FYK3aqUPj8Uv3Q2L44Wecw3aVACjyaGYKGdwyFB7pZYEwwFKYOCH
	h6PT1gxK5ebQcy7smRpQ2OC7M0vXuYU3aA5Sl1yaqhq/atU02kGfq7qN5Xv7la+K/A==
X-Gm-Gg: AYBFou2BsQo5RBgwxJQX7oRU/pZaD3Jt5gTkOFR9xKHXsB5/RBgD8dICIbm9fMs0GM7
	JoMbCXOGnj5jD0I3nX1Jx9JZSpbVkbPbq3Q61QJZMoRhb6TIHkZZ+C7xzkvR3CsbnfX+JoeTfmU
	IZIJ/i3uQYf9Awc0g1UzUVwXIatgqIXPlQp5HIs66b2zN1Wpy4O5u68jHESwHM/h8CBgIUwlmtd
	g19BDa/8SAkkw/WRVpKBtNwYEneILBrpVwbe798vfqSUkxbex0bGNp6vxWb1Hp29RE7J1Pbxf6K
	GH/xC2X2WiFVqtNvwcayXjaogb8Yu5Dn/R6yEHZzXUS8T8QSlQhcNo515/W2t2/TMIuOgYf/CSe
	B/M1XDJfDS+haQBNYsCZ0TofnfnIV+fr0zPQHVZnjlqqTWE586HmJd86kvLC6C8jF1UQBHSb4v+
	iTyPz3yV5klygMC9ORvEyR96M1mVpWNVNIwZCI1vID4qpJ+/4/wIh14zUWobZi9jwr3ByKsYKK7
	A6BIGf8fnzzxjGZTxXCJcNa4QRqX/c4/lTpUYTKOFTUm4CTp9LaWdnCBlxYlVYtQ30SaBZD1DuD
	nYTOMaUsk8ptz+FB12nRcFoEp0yDb7DxejoT9NU0M2Rz65U+wT9jwe203GDRjFXluqEGF8biKcv
	tox35mj1sgPg+X3M7wwAPVsIPEb/c+KredliYNvLwWlzScH87Szzw8D/yWYau6BL/r9IFPSLN/N
	eI6JS4GQ==
X-Received: by 2002:a17:907:6d19:b0:c31:6a37:f281 with SMTP id a640c23a62f3a-c31a9a28baemr762386066b.2.1791722195363;
        Sun, 11 Oct 2026 05:36:35 -0700 (PDT)
Received: from Desktop.fritz.box ([217.26.236.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c344ab1453bsm59920966b.67.2026.10.11.05.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 05:36:34 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: ath11k: apply the 160 MHz NSS ratio to the radio
Date: Sun, 11 Oct 2026 14:36:30 +0200
Message-ID: <20261011123631.1664734-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The firmware reports the NSS a radio supports at 160 MHz as a ratio of
its 80 MHz NSS. Peer assoc applies that ratio to the peer's NSS instead,
so on a radio with a 1:2 ratio a two-stream peer is sent one stream at
160 MHz. The HE 160 and 80+80 MCS maps copy the 80 MHz map, so a
4-chain radio with that ratio offers 4 streams at 160 MHz where it
supports 2.

Take the 160 MHz NSS from the radio's TX chains, as ath12k does since
commit a82ce08775bc ("wifi: ath12k: add extended NSS bandwidth support
for 160 MHz"), and limit the 160 and 80+80 MCS maps to the ratio when
the firmware reports one.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
On a Xiaomi AX3600 (IPQ8071A, 4-chain 5 GHz radio, firmware reports
WMI_NSS_RATIO_1BY2_NSS), `iw phy` lists 4 streams in the HE 160 MHz
MCS sets without this patch and 2 with it.

 drivers/net/wireless/ath/ath11k/mac.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index c1fa42edd3630..6cd163cab9bd7 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2278,7 +2278,7 @@ static void ath11k_peer_assoc_h_vht(struct ath11k *ar,
 
 	if (arg->peer_phymode == MODE_11AC_VHT160 ||
 	    arg->peer_phymode == MODE_11AC_VHT80_80) {
-		tx_nss = ath11k_get_nss_160mhz(ar, max_nss);
+		tx_nss = ath11k_get_nss_160mhz(ar, ar->num_tx_chains);
 		rx_nss = min(arg->peer_nss, tx_nss);
 		arg->peer_bw_rxnss_override = ATH11K_BW_NSS_MAP_ENABLE;
 
@@ -2588,7 +2588,7 @@ static void ath11k_peer_assoc_h_he(struct ath11k *ar,
 
 	if (arg->peer_phymode == MODE_11AX_HE160 ||
 	    arg->peer_phymode == MODE_11AX_HE80_80) {
-		tx_nss = ath11k_get_nss_160mhz(ar, max_nss);
+		tx_nss = ath11k_get_nss_160mhz(ar, ar->num_tx_chains);
 		rx_nss = min(arg->peer_nss, tx_nss);
 		arg->peer_bw_rxnss_override = ATH11K_BW_NSS_MAP_ENABLE;
 
@@ -5940,7 +5940,7 @@ static void ath11k_mac_set_hemcsmap(struct ath11k *ar,
 				    struct ieee80211_sta_he_cap *he_cap,
 				    int band)
 {
-	u16 txmcs_map, rxmcs_map;
+	u16 txmcs_map, rxmcs_map, txmcs_map_160, rxmcs_map_160;
 	u32 i;
 
 	rxmcs_map = 0;
@@ -5958,18 +5958,28 @@ static void ath11k_mac_set_hemcsmap(struct ath11k *ar,
 		else
 			rxmcs_map |= IEEE80211_HE_MCS_NOT_SUPPORTED << (i * 2);
 	}
+
+	txmcs_map_160 = txmcs_map;
+	rxmcs_map_160 = rxmcs_map;
+	if (cap->nss_ratio_enabled) {
+		for (i = ath11k_get_nss_160mhz(ar, ar->num_tx_chains); i < 8; i++)
+			txmcs_map_160 |= IEEE80211_HE_MCS_NOT_SUPPORTED << (i * 2);
+		for (i = ath11k_get_nss_160mhz(ar, ar->num_rx_chains); i < 8; i++)
+			rxmcs_map_160 |= IEEE80211_HE_MCS_NOT_SUPPORTED << (i * 2);
+	}
+
 	he_cap->he_mcs_nss_supp.rx_mcs_80 =
 		cpu_to_le16(rxmcs_map & 0xffff);
 	he_cap->he_mcs_nss_supp.tx_mcs_80 =
 		cpu_to_le16(txmcs_map & 0xffff);
 	he_cap->he_mcs_nss_supp.rx_mcs_160 =
-		cpu_to_le16(rxmcs_map & 0xffff);
+		cpu_to_le16(rxmcs_map_160);
 	he_cap->he_mcs_nss_supp.tx_mcs_160 =
-		cpu_to_le16(txmcs_map & 0xffff);
+		cpu_to_le16(txmcs_map_160);
 	he_cap->he_mcs_nss_supp.rx_mcs_80p80 =
-		cpu_to_le16(rxmcs_map & 0xffff);
+		cpu_to_le16(rxmcs_map_160);
 	he_cap->he_mcs_nss_supp.tx_mcs_80p80 =
-		cpu_to_le16(txmcs_map & 0xffff);
+		cpu_to_le16(txmcs_map_160);
 }
 
 static int ath11k_mac_copy_he_cap(struct ath11k *ar,
-- 
2.53.0

