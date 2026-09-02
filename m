Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782C6385D7F
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 08:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788337350; cv=none; b=PZujIu9UCLmzHxt7aIpXXjLyLiAE3Ii3JIKC2wSokvoSummIbuN4SJhaHIuVbQYbBoFMxr/N6GkkgLy3ih3QK7vLJqY6RdU5LweJ59pyKdz2+CR9ZnayIMVhCqvbZqcYRkN+hnU30i/5xcs4+yhSUfgFVR+B1o+6Jp4IkKbExNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788337350; c=relaxed/simple;
	bh=oa6HjGViZFyoRJTy/Z2W2UNJiXRoDabPV0p1bGeDSUk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fcFF8Aa3WPOV9+7EDiVg8sZZ91JgRS2kQYXKPUMkpZn9RQq5IAZiyAAcvFQVhLY003l6pMcLUBv9tW7JAiclIVU8Dcmopb88P6BQQpCrxizPgExJkY4Rt5IHPYMjkKCV0K5ox1CaC7kYZAiHuLTEBE7BGWluWmDp8bdrCHODYes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r3wSR1M0; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r3wSR1M0"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49b0d8bc2aaso6855305e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 01:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788337347; x=1788942147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ST0JywuIijs9AyXrfzYTAQmxlPvMrq1DLcWk/E2Kd+c=;
        b=r3wSR1M0Ek5YvFsPi2mgqJ4woTPjSWVqC/4MFzlWs559LC2b6i5PPGUEIRKTFv4dBP
         AjkxaQ0Gk1SQ9Q0ncAR49H9g8PzSfpIEoCBRk2zvFCfFkjHt4jd7QNxTa7hV6vY2juyt
         m2c6XzN5gSOKKoliPpPtuUL5goqlrHjT+SqYzNvk2+nbxTvaHKkXBHhsAKVTcKeiBnEe
         iQSupFYo5JsKpEO9Vzh4ZwJ926yTk1js0997M1h58oHFbbEHgthggMA62WRDlQPLo/eX
         yD4f+XVkkj9coZ0jX3NQZOcC/T5YRz0dt/iBSo9QMCGIVcei0Ad5HjYbkvrM5vf09Z0H
         dypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788337347; x=1788942147;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ST0JywuIijs9AyXrfzYTAQmxlPvMrq1DLcWk/E2Kd+c=;
        b=kCJOtl9E9RgPMo4diNblQpaDZZFluxFjJ9eJlgldGoYt9+i7Lfi+M0fmLK19UGHVYi
         AUfPsAGJ2I47RFNzTEnv+CRGPBMS01KiYTBCdUmqcAnSkV0I6ULE5t6c4ic+gvBqQIba
         fCFos+ZlCOILQJUhXHZQrAdjqnvr2zwhb4OK5v9RCs2fDNO3XN/q8LMTYhnKl6AUATh+
         JjEoCzM/AiG/4HWHhDBGlpKAr6W9ud9L4u4se5bik8oh4COcWNHdQMShRicYa/kUegw4
         Rhxh5ANogxlKfSIuF7k4FZJF+4jx/RsjzCO8AkFK6s2uCjeS2O/zBPlsiFV/JjwpoXhC
         oqkA==
X-Forwarded-Encrypted: i=1; AHgh+Rqc8TZgQtOwtPBGVbIDFJ4LdWrDRm9CZk+NFlSMXmZ57Ah7EUc4rRhIS+3kIcbwZ0xJJznsH/91Y+et4MwY6A==@vger.kernel.org
X-Gm-Message-State: AFuF++mxB9Fpr7Tu0VA3eMhvHDamBtKlPhjXhVuLnYPdtQmeAFaPwugP
	y02yACPyxUOlm4IuzkCXff2oPgpIL3BI0kAyNfnKUDTt9vlLoX+q8BK+
X-Gm-Gg: AR+sD11w+MkrCv5dghclkGxZtKVmGLcYjuUfFz0XY07eTK0u3LPNZLWFIDdKxibCqo/
	nYG9SdXbATgTtRflEuTcBWhQZxdIgkgHiE988SOs9DAQ6dJ6UmLMsA8DDqQp9HcaUDt/HQ0nEKw
	c6kjSo22hucaBfK4olu6RqLXqzgRQzN1i4oECWidk5XQRMMSUWxn+Q68OsKt4MbAQfuVWgvk3yE
	Zx66Hcy7J/f8Z8ZZwkMDwhkBCoqEsoNQmNMsqiollalZssQ08/csaoCmeJP6iml173BIYODZDOR
	2Wcj1TucwNA8S0Ohvw7GOqH5o16Uo9T7Cw9QgIOoAusxHQGG8eR8L6p/wpRyGL8eAuUaU496s8j
	3EKwgWRttNmHSpR6DP9/4plDEmNFyA3T4d3NNys2A8NM02uvHjsaiBhIXmdNXi9Oi77dC2jUf1j
	XdtiUmDTL1yp5VUZdT0d64hFZnKk5pyN9gh4WYhhD0jVc9PgeD28E=
X-Received: by 2002:a05:600c:c170:b0:49b:d45:703e with SMTP id 5b1f17b1804b1-49ce57f072fmr62819355e9.8.1788337346382;
        Wed, 02 Sep 2026 01:22:26 -0700 (PDT)
Received: from vitor-nb ([2001:8a0:c4c6:f00:e66:da8a:ae8a:96d3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448ee9cf7sm4992947f8f.25.2026.09.02.01.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 01:22:25 -0700 (PDT)
From: Vitor Soares <ivitro@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Vitor Soares <vitor.soares@toradex.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next] wifi: ath12k: provide MAC address list for single-radio wiphys
Date: Wed,  2 Sep 2026 09:22:18 +0100
Message-ID: <20260902082219.3010793-2-ivitro@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vitor Soares <vitor.soares@toradex.com>

ath12k supports creating vdevs with addresses provided by mac80211.
Userspace can already make concurrent interfaces work by explicitly
assigning different locally administered addresses.

However, ath12k does not advertise an address list, so when a second
interface is created without an explicit address, mac80211 has nothing
to pick from and falls back to the permanent address. If the first
interface is already running with that address, bringing up the second
one fails with -ENOTUNIQ.

As in ath11k, provide a list of usable addresses so
ieee80211_assign_perm_addr() can hand each new interface an unused one.
Keep the first entry as the radio's own MAC address. Generate the
remaining entries as locally administered variants by changing only the
upper nibble of the first octet, which naturally limits the pool to 16
unique addresses.

Handle only single-radio wiphys. Wiphys with more than one radio behave
exactly as before.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Signed-off-by: Vitor Soares <vitor.soares@toradex.com>
---
Note that a device which is not MLO capable registers one wiphy per
radio, so each radio of a multi-radio device also gets a pool, seeded
from that radio's own MAC. I only have single-radio WCN7850 hardware,
so that case is untested.
---
 drivers/net/wireless/ath/ath12k/mac.c | 48 +++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 9a775602775d..bee6701f1029 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -14685,6 +14685,50 @@ static void ath12k_mac_cleanup_unregister(struct ath12k *ar)
 	kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
 }
 
+static void ath12k_mac_cleanup_mac_address_list(struct ath12k_hw *ah)
+{
+	kfree(ah->hw->wiphy->addresses);
+}
+
+static void ath12k_mac_setup_mac_address_list(struct ath12k_hw *ah,
+					      const u8 *mac_addr)
+{
+	struct ath12k *ar = ath12k_ah_to_ar(ah, 0);
+	struct mac_address *addresses;
+	u16 n_addresses;
+	int i;
+
+	/* The pool is derived from one base address, so it can describe only a
+	 * single-radio wiphy: with more radios each radio has its own base
+	 * address, possibly from a different ath12k_base.
+	 */
+	if (ah->num_radio != 1)
+		return;
+
+	/* Only the upper nibble of the first octet is varied, so at most 16
+	 * addresses can be derived from one base.
+	 */
+	n_addresses = min_t(u16, TARGET_NUM_VDEVS(ar->ab), 16);
+	if (n_addresses <= 1)
+		return;
+
+	addresses = kzalloc_objs(*addresses, n_addresses);
+	if (!addresses)
+		return;
+
+	ether_addr_copy(addresses[0].addr, mac_addr);
+	for (i = 1; i < n_addresses; i++) {
+		ether_addr_copy(addresses[i].addr, mac_addr);
+		/* set Local Administered Address bit */
+		addresses[i].addr[0] |= 0x2;
+
+		addresses[i].addr[0] += i << 4;
+	}
+
+	ah->hw->wiphy->addresses = addresses;
+	ah->hw->wiphy->n_addresses = n_addresses;
+}
+
 static void ath12k_mac_hw_unregister(struct ath12k_hw *ah)
 {
 	struct ieee80211_hw *hw = ah->hw;
@@ -14704,6 +14748,7 @@ static void ath12k_mac_hw_unregister(struct ath12k_hw *ah)
 		ath12k_mac_cleanup_unregister(ar);
 
 	ath12k_mac_cleanup_iface_combinations(ah);
+	ath12k_mac_cleanup_mac_address_list(ah);
 
 	SET_IEEE80211_DEV(hw, NULL);
 }
@@ -14820,6 +14865,7 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 	wiphy->available_antennas_tx = antennas_tx;
 
 	SET_IEEE80211_PERM_ADDR(hw, mac_addr);
+	ath12k_mac_setup_mac_address_list(ah, mac_addr);
 	SET_IEEE80211_DEV(hw, ab->dev);
 
 	ret = ath12k_mac_setup_iface_combinations(ah);
@@ -15041,6 +15087,8 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 		ath12k_mac_cleanup_unregister(ar);
 	}
 
+	ath12k_mac_cleanup_mac_address_list(ah);
+
 	SET_IEEE80211_DEV(hw, NULL);
 
 	return ret;
-- 
2.55.0

