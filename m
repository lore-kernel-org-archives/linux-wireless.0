Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993019;
	b=qtZ2eUIxWaAT1hSfGiPYlj0RSKmmxBhHSBkSk0VyDHR0gZyYYPkAi07TfPBCiI0HZymB
	 p7d/T6uQ1fM+oPoUclSlS4MfMrOZR9UwAOIXU7/zi6PYSVjzrYUTGQoubNNXjqlfaPWvf
	 UNSOZZ0Ibp27y6a5zrE8kkMzW0PVVdJJNTaAL4jM5shG1+/437NVFchglyXrUNhmkJd09
	 ju1uBW6EhDzQGB8qgf44ZQ+APPLJ7PI6xxsLlRiLoCbSKT73OH2hUQ1rzg4UbxlYnWRls
	 STvkjJ87TsXzzaCKZk137sDh+V8OBPTv3ggbot0s65nA/u9QZ4jDkVMY5TQ+3CcvOrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993019;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8OuNNgHAOVhz+FAVwYZqTinDyQukbU2g3tn+Bgg72Xk=;
	b=vFVyO+kR5Sxg2xEYCNRS5rC/QGvKxP6HTLqDKPLZ1NeyWLq7VjHSECpakDJMNpdWXywv
	 DGq/rO4Vv4aIQD/frFUtPhh/PGgelIJaVNxwaJYEJh7gmOtKCxOdy5y7MYVKTKX8DR8Pq
	 5X2ntqvI7EuI2IOMjHAys4QlF0KIDS/iKk3vESTquxhDAAyKf0Jcj0cJAEupGGrr4I3Lb
	 b1mOANpUxTygVOgnLmZJBuWLOhLVi2rBoU0hd1crNTdAs/CkXEWpIe613NHi0i+Cc233F
	 k1WDJ9c1yDlD+T4MZMicrGY4NBXfbOFasf26yVVJeUbLPWI2CizveTsFNaCi7HrItMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="K/V4KxJq";
	arc=none smtp.remote-ip=209.85.210.178
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F61E606A31B
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:36:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F61E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=K/V4KxJq
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8a064dcfcfdso761143b3a.2
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993018; x=1793597818; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8OuNNgHAOVhz+FAVwYZqTinDyQukbU2g3tn+Bgg72Xk=;
        b=K/V4KxJqmVPd2yEjPPvvJnmfBjhvydkHb41gLzTN2YMDJXWrWN8g8ihSHYgcrDAeEq
         CZJh5Qg5ExRKMPCkkXOEcNveQjcfAW0dO4+TQ0MVpldCnTDn0ul3CZQG5eiHaETy2YZf
         zwJI+TcFjUp5I/tRJX2OwIG9WpIuMdicbia2QqluYC5D1kwlw6ooGwacsZ0TYdV78FZn
         49NqPH5xzj9exeFpjvucGv/7Dct1FyDYtNsjXE1UD2osBC6c5gSFyDWBQqYb6hXwr5SS
         nXx3q1qNm0uQ/DianS23Ge8DC2lh+BHW/4IDUJqBOCmFlJb3NCW4Mtf00xG9h3UDy/uI
         9AQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993018; x=1793597818;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8OuNNgHAOVhz+FAVwYZqTinDyQukbU2g3tn+Bgg72Xk=;
        b=ZupzyXAER74eSJ8eu4CR8J/gYB4aFjFfNP6WD6PyATRXZ7UfOUmzXquF5i//iBU+OY
         7UA3+MgZVfYSrNTExNUPanxSMZfAgipB4Fa3Xfovz+xAfHumnykrWZdP02SMyZf3R6SZ
         ELILON/h8UUx97ADQ/A3fQZV3bzzp1Zup7CcAFgtu2B1Z2/IMikVq+HKrSxKwTi3Caz3
         0vD0tvA/2Aqu7o5miseuqrDpXwvrX+cdMkJSQ5arqFG6Oc0bia/yuv2+xuNoW1ksYvWl
         jKeRIuVkkNdAX8KxwvXZyZswqJG1dk7u+cUOB0HtZ3awSoDRdY/DfouDVGNg3Zs1l874
         Ja9w==
X-Gm-Message-State: AFq9FYKMXzmuvlE3eXBLQ/vh/02KJ7Y1sXeoz0V4pxqxllJNM4ilsUdJ
	YhW/NNwtyN+b6qIFasIEFv+P3f0bXumo1OVn0Op28q9s4Gt4yNF8dvIH5paXCoxuJetytg==
X-Gm-Gg: AYBFou0b18TW4MtWQUvAN41xzpwA0IwGXHJCqbjbWhcD11EKDJ1BjL2266qFySFGfbh
	hc+/gWztvpjqiAU7Y8xSOGdqrogUtYDyFWYzJCIrhAjHRxdOAqTm3GfvPrdcy66OoRFZVC1251k
	BIJdsL8E5alm1taZENyxIgAMS/lSI+CyOS6u8HJMAvZMJ0gaiQdekkPLc5wRD2nQCcYm8pipaiO
	y0LOPuLu10iEBGx3NgaKFlEsfs5HwJT1NA91s5VsosCk+s788AnVT2YHXh3r7VX+ExBZXg6zSXo
	x5O5vfNLqbafN2rzk05tOsZI/3UlQ7PShfCoiFJ6zaT3v/j8f6UxmUww/eLMFXBkWyP36Cuzogu
	WatvRBRiBY/EJWD+eUCa0Sp9to2vBSue/9dtA/jjF9diiep+Tw3MkCmk3XBGQspmOSRDL+1hvXg
	Lqxdjj3U5vtrq5xFdtmm8Z4ePBVyAVTeySQ5q2fKOEaCfCq6t4mtpak6fYwV9gxVIBbx1t1S/sj
	yhMqk+3wgNiCsLE++D+Gbq60JFrzIVi4U/C/sv2kQYU9eH520ip+vGJmfHMxqbvj7iQywYj/Lsa
	orAt
X-Received: by 2002:a05:6a00:301e:b0:8a0:5d8f:6675 with SMTP id d2e1a72fcca58-8a369c1e10emr4233130b3a.58.1792993018446;
        Sun, 25 Oct 2026 22:36:58 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:36:58 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>,
	Ho Jie Feng <hjf3108@gmail.com>,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH wireless-next 03/17] wifi: brcmsmac: look up OFDM rates in rate.c
Date: Mon, 26 Oct 2026 13:36:09 +0800
Message-ID: <20261026053633.361454-4-ragulbaby@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026053633.361454-1-ragulbaby@gmail.com>
References: <20261026053633.361454-1-ragulbaby@gmail.com>
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

Move the OFDM rate table next to its only user, ofdm_phy2mac_rate(),
which leaves rate.c independent of the PHY code. No functional change.

Signed-off-by: Ragul Balaji <ragulbaby@gmail.com>
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 .../broadcom/brcm80211/brcmsmac/phy/phy_cmn.c | 17 -----------------
 .../broadcom/brcm80211/brcmsmac/phy/phy_hal.h |  2 --
 .../broadcom/brcm80211/brcmsmac/rate.c        | 19 +++++++++++++++++++
 .../broadcom/brcm80211/brcmsmac/rate.h        |  7 -------
 4 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_cmn.c
index 7eae73ef7..d519e950c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -101,18 +101,6 @@ static const struct chan_info_basic chan_info_all[] = {
 	{216, 5080}
 };
 
-static const u8 ofdm_rate_lookup[] = {
-
-	BRCM_RATE_48M,
-	BRCM_RATE_24M,
-	BRCM_RATE_12M,
-	BRCM_RATE_6M,
-	BRCM_RATE_54M,
-	BRCM_RATE_36M,
-	BRCM_RATE_18M,
-	BRCM_RATE_9M
-};
-
 #define PHY_WREG_LIMIT  24
 
 void wlc_phyreg_enter(struct brcms_phy_pub *pih)
@@ -2486,11 +2474,6 @@ u8 wlc_phy_stf_chain_active_get(struct brcms_phy_pub *pih)
 	return active_bitmap;
 }
 
-const u8 *wlc_phy_get_ofdm_rate_lookup(void)
-{
-	return ofdm_rate_lookup;
-}
-
 void wlc_phy_ldpc_override_set(struct brcms_phy_pub *ppi, bool ldpc)
 {
 	return;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_hal.h
index 7ffff7f51..c5aaaec43 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_hal.h
@@ -234,8 +234,6 @@ void wlc_phy_ofdm_rateset_war(struct brcms_phy_pub *pih, bool war);
 void wlc_phy_bf_preempt_enable(struct brcms_phy_pub *pih, bool bf_preempt);
 void wlc_phy_machwcap_set(struct brcms_phy_pub *ppi, u32 machwcap);
 
-const u8 *wlc_phy_get_ofdm_rate_lookup(void);
-
 s8 wlc_phy_get_tx_power_offset_by_mcs(struct brcms_phy_pub *ppi,
 				      u8 mcs_offset);
 s8 wlc_phy_get_tx_power_offset(struct brcms_phy_pub *ppi, u8 tbl_offset);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c
index 6841bc005..ac577c8e8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c
@@ -266,6 +266,25 @@ const struct brcms_c_rateset cck_rates = {
 	  0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
+static const u8 ofdm_rate_lookup[] = {
+
+	BRCM_RATE_48M,
+	BRCM_RATE_24M,
+	BRCM_RATE_12M,
+	BRCM_RATE_6M,
+	BRCM_RATE_54M,
+	BRCM_RATE_36M,
+	BRCM_RATE_18M,
+	BRCM_RATE_9M
+};
+
+/* Convert encoded rate value in plcp header to numerical rates in 500 KHz
+ * increments */
+static inline u8 ofdm_phy2mac_rate(u8 rlpt)
+{
+	return ofdm_rate_lookup[rlpt & 0x7];
+}
+
 /* check if rateset is valid.
  * if check_brate is true, rateset without a basic rate is considered NOT valid.
  */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h
index e178b1a0e..7c1d43323 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h
@@ -198,13 +198,6 @@ static inline u8 cck_rspec(u8 cck)
 	return cck & RSPEC_RATE_MASK;
 }
 
-/* Convert encoded rate value in plcp header to numerical rates in 500 KHz
- * increments */
-static inline u8 ofdm_phy2mac_rate(u8 rlpt)
-{
-	return wlc_phy_get_ofdm_rate_lookup()[rlpt & 0x7];
-}
-
 static inline u8 cck_phy2mac_rate(u8 signal)
 {
 	return signal/5;
-- 
2.53.0

