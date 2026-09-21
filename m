Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E1F4E0B78
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 17:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790011846; cv=none; b=uBqfrmscIZhPLmXBClMs4U2lZhtecz5D76CecRAqszogNSBbNoadSXS9W2A2FZBCCeG4gb61XhEQC2MHNi1+bUh1JegkoIBo8ERXJp7S/HFgibWAe1AfsplOHbYwhHuFoCQQdR9AvdZG/z+OEUXG14CJruNwk7QW0gTn+MtVGF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790011846; c=relaxed/simple;
	bh=SmkHF4FiGhY6vkAj210MpG+mQj2Z0pAr8tccZVz5/z0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IX1T4OmH0POAU5Hju5lHGMOljiuL23kFiNL2NiN5s9f0jp3gx2cz29n7auM3hH1TtW3reVrqkefrVz5bSZxtBS3d35n9eaCSeIe8NcSdvdiHaoE0Go0OXoL0R0L3+WjHcayHoB5Kir2Ko2WYrk2bsKPgJ64w+6Wy2e/QG9yrgQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fkXtroz1; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fkXtroz1"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e2406so17020985e9.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 10:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790011843; x=1790616643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s8pWNm66LVdiHzafdbCttJBcf3IazbTGcwd5qfxU4As=;
        b=fkXtroz1Aezsq76ZTCKm/n5nmmCiFSwMIiqZGJM5VGroxdf5y/Q1Jokpu4Xis/MbVb
         ToT6Yg0k8V+nxtOsf3gJQQeP1EmowUA8Z3jjlBbyV7FNbg9tNZnsxKl5Y8nEZ8qFbLOu
         NtRL+yM4pEsAb6BWGkH2d+Hhw/Tm8EUH+cZlFJRWMnei6/YAzM596rPTT1xXxarFXSug
         imU9OHoopzOz8IZHbDLFJbExl3IR7gmXcXu5RwZF6L15xm0ht0uiVodG7zj3nicg2/mq
         wQs+gEmqTp2cMXgPMOab0di2/NbpfveKLi/4Qz5RLlvG4M3i/Ivs2hpdbeIeZrEdmYgp
         pESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790011843; x=1790616643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s8pWNm66LVdiHzafdbCttJBcf3IazbTGcwd5qfxU4As=;
        b=KVdfd5Xv2oJMyHHR+rKl/w4QjiDl0BY2+CFJwpHULv7H8/NEMEefwQGG99SBFBM1Ox
         NKHGbpw1yVPg8xBN37ois58H/DRYpv75DlluxV16mrktsMw9papx9b2WdvvKBplZ4mj2
         7sL1yfZ2GR27KWPXFaiUsK+1qjCqdeXIOuCkFAt4/RJkWopEp/Qh7/5KIdfCKkprv4mx
         rO3l8J4RdJIEjnjMRqKlOxHtpXPMO/bNXwRwln99PN5kY9QByV94nw3J+k2C8Pq7Vyie
         tHpHa8qdwoBIEAXN9PkHE+x9BfNVQ4tmAq8vPmvL2FENitAFABplewS6m0ISzIC58jW5
         Sivw==
X-Forwarded-Encrypted: i=1; AKwUvBzuMInF/dGBJjFpEzaSqHjsmIi+A5OlKda5FisO7PS34ZUmtf0yai6dC+7nyXOtYapAd0VNTPVGRI+X6p9OrQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lJ9qTSyFlcPqD/ow8GlbavTEoIRO0c2FFl0pk6esnCCh1XIGS1
	KQ9SyNMngYHh8je9DmUB64ByW8S3MteDr3lz+zZfpWvoBJs5HPIUFrAt
X-Gm-Gg: AYBFou1+ebax/I4YK7x2JUwsPxxWW8pX39lHd1I5KtszDPwugC8kq3fEmXPWSqzi/i4
	cepOo9uR+8CGRb/Eh5Klyqga6vOdzZ+HqYTPkvQV3G/N8ZwVj5s4iAN+96Lo9lFT78ITJKj/UI/
	kK0rOm6uGlfH0uSRKun5s0UNd1dA7EHbfNrpm8QC61zIESuKM6J0i04UEexhxxajLDpDz9FbKmC
	44dLzlEGT9t77q0WTjsYPbFAQY6wwB8yGAvO2w2XCqUca30nTDnjKonL7JPeJYKrBvsGResLDHc
	gMeM/TJ0x29R1HnISV1BtnT+7NO4J089//YQYPiGRP17Emj+HhdeG1xp/DTbbHOSfz/nFeLxFBI
	NUdSy5IzuodyXwVxIqpVe7lEwp3bXKV4EAl8jCJ1s5g4UjolgTKG51E0MPS4IN/FAP4fwapwY7/
	Hut3fkqVFOXinG7Y4fgjFFr/0nf76LKKwd4v3v4ghyY0ZgUxGBcVLUnzkXES8p7y8=
X-Received: by 2002:a05:600c:34c6:b0:49e:65f2:db64 with SMTP id 5b1f17b1804b1-49fd88607e7mr6562135e9.5.1790011843197;
        Mon, 21 Sep 2026 10:30:43 -0700 (PDT)
Received: from vitor-nb ([2001:8a0:c4c6:f00:e34f:2f52:ae98:3e30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fd8ccd0e1sm6146505e9.6.2026.09.21.10.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 10:30:42 -0700 (PDT)
From: Vitor Soares <ivitro@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Vitor Soares <vitor.soares@toradex.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	baochen.qiang@oss.qualcomm.com,
	kang.yang@oss.qualcomm.com
Subject: [PATCH ath-next v3] wifi: ath12k: advertise interface MAC address pool
Date: Mon, 21 Sep 2026 18:30:33 +0100
Message-ID: <20260921173033.846332-2-ivitro@gmail.com>
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
Keep the first entry as the wiphy's permanent MAC address. Generate the
remaining entries as locally administered variants by changing only the
upper nibble of the first octet, which naturally limits the pool to 16
unique addresses.

The cfg80211 definition of wiphy->addresses does not specify where the
addresses must come from. Some ath12k platforms use it as an interface
MAC address pool, while others use it for firmware-provided per-radio
addresses. Gate the generated address pool behind
advertise_iface_mac_pool and enable it for WCN7850 and QCC2072.

Other platforms keep the existing behavior.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Assisted-by: LLM
Signed-off-by: Vitor Soares <vitor.soares@toradex.com>
---
v3:
- Rename host_alloc_iface_mac to advertise_iface_mac_pool.
- Clear wiphy->addresses and wiphy->n_addresses during cleanup.
- Drop the single-radio check and rely on hw_params gating.
- Enable the generated interface MAC pool for WCN7850 and QCC2072
  (QCC2072 compile-tested only).
- Follow kernel block comment style.
- Link for v2: https://lore.kernel.org/all/20260915152815.254016-2-ivitro@gmail.com/

v2:
- Gate generated interface MAC address list behind hw_params
  host_alloc_iface_mac, as suggested by Kang Yang.
- Enable it only for WCN7850, the only part available for testing here.
- Add Assisted-by: tag.
- Link for v1: https://lore.kernel.org/all/20260902082219.3010793-2-ivitro@gmail.com/
---
 drivers/net/wireless/ath/ath12k/hw.h       |  1 +
 drivers/net/wireless/ath/ath12k/mac.c      | 48 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wifi7/hw.c |  6 +++
 3 files changed, 55 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index e790de5737db..c58db8482aa4 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -238,6 +238,7 @@ struct ath12k_hw_params {
 	} client;
 
 	bool host_alloc_ml_id;
+	bool advertise_iface_mac_pool;
 };
 
 struct ath12k_hw_ops {
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index d4116ba0da08..46f5f338f44c 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -14743,6 +14743,50 @@ static void ath12k_mac_cleanup_unregister(struct ath12k *ar)
 	kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
 }
 
+static void ath12k_mac_cleanup_mac_address_list(struct ath12k_hw *ah)
+{
+	kfree(ah->hw->wiphy->addresses);
+	ah->hw->wiphy->addresses = NULL;
+	ah->hw->wiphy->n_addresses = 0;
+}
+
+static void ath12k_mac_setup_mac_address_list(struct ath12k_hw *ah,
+					      const u8 *mac_addr)
+{
+	struct mac_address *addresses;
+	struct ath12k *ar;
+	u16 n_addresses;
+	int i;
+
+	ar = ath12k_ah_to_ar(ah, 0);
+	if (!ar->ab->hw_params->advertise_iface_mac_pool)
+		return;
+
+	/*
+	 * Only the upper nibble of the first octet is varied, so at most 16
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
@@ -14762,6 +14806,7 @@ static void ath12k_mac_hw_unregister(struct ath12k_hw *ah)
 		ath12k_mac_cleanup_unregister(ar);
 
 	ath12k_mac_cleanup_iface_combinations(ah);
+	ath12k_mac_cleanup_mac_address_list(ah);
 
 	SET_IEEE80211_DEV(hw, NULL);
 }
@@ -14878,6 +14923,7 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 	wiphy->available_antennas_tx = antennas_tx;
 
 	SET_IEEE80211_PERM_ADDR(hw, mac_addr);
+	ath12k_mac_setup_mac_address_list(ah, mac_addr);
 	SET_IEEE80211_DEV(hw, ab->dev);
 
 	ret = ath12k_mac_setup_iface_combinations(ah);
@@ -15120,6 +15166,8 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 		ath12k_mac_cleanup_unregister(ar);
 	}
 
+	ath12k_mac_cleanup_mac_address_list(ah);
+
 	SET_IEEE80211_DEV(hw, NULL);
 
 	return ret;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index ae8df80928b0..ad362244ed9b 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -445,6 +445,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		},
 
 		.host_alloc_ml_id = true,
+		.advertise_iface_mac_pool = false,
 	},
 	{
 		.name = "wcn7850 hw2.0",
@@ -539,6 +540,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		},
 
 		.host_alloc_ml_id = false,
+		.advertise_iface_mac_pool = true,
 	},
 	{
 		.name = "qcn9274 hw2.0",
@@ -629,6 +631,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		},
 
 		.host_alloc_ml_id = true,
+		.advertise_iface_mac_pool = false,
 	},
 	{
 		.name = "ipq5332 hw1.0",
@@ -713,6 +716,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		},
 
 		.host_alloc_ml_id = true,
+		.advertise_iface_mac_pool = false,
 	},
 	{
 		.name = "qcc2072 hw1.0",
@@ -808,6 +812,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		},
 
 		.host_alloc_ml_id = false,
+		.advertise_iface_mac_pool = true,
 	},
 	{
 		.name = "ipq5424 hw1.0",
@@ -895,6 +900,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		},
 
 		.host_alloc_ml_id = true,
+		.advertise_iface_mac_pool = false,
 	},
 };
 
-- 
2.55.0

