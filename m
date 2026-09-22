Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35885386C22
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 20:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790107645; cv=none; b=OUng6fzsYhhbpQQSRWPCek02xhroP4MobL1o5MsZ7iQn8KjyKTnExzEzk1+1DXfoQ9s4udnzZ9Q2PYkeYnbTvtkkk28XLZvKsCya4+kBRwePfQnPjhNBZL7Eam0M0ZTA/QP9G0zD843Ae+fYn1/pPDGd2fN2mt+47RFQEQdWWSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790107645; c=relaxed/simple;
	bh=IMkQjgdhefb1LPvjElZJJR8K3ybljP1EVDwWBcHscBU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IpPL9NwlDfWIDm3QecWj6RcuIZn7okO31qeoikVu+lFj0GyQW1z84U6N7K9M0vcOyX5uASB/Ma8GMMNvRi+BZ8xfwBJM6HB3rXTj/MFK8dSjSYWQjbSqE90sgOBi3eT1p3ZVkKbPWfIk+1co4jyDQnwJnCNqHBQgO8wHweWZQjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P+Tl8Ilc; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P+Tl8Ilc"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-482f633cd78so195932f8f.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 13:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790107613; x=1790712413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KsPUs6EBonqM96r2eMKS/17pMpIetLZ9bP0EB0PlUy8=;
        b=P+Tl8Ilc9f89Ew9+txoB4vCjjeNJx8Yk+q6HK2LXRoo2+gkTEHusokVnjAeSHzNM83
         SeZYanXx7kO5sD6lid4hR+jJyhr/1QuHJo3ujjc4GqLDcxELszy75Lm3stxaPa6XnpI7
         hLVFZNkpYnUI5meY11Gra0RD7VnOWcbbgARK+30ppXtcmILDjDkF353jrLqSlhYs44Rn
         3ZjnfyzTe/EtoSejeEnVbvTd8+MfsEIC+iSpxkaC0gIqjn232E1IJsEOwZmp5T8w0J+q
         t3lsOE3iWh2KVqWs4lKTig0yFBVFcN0IaQUF2czHY/HvT9rcoyMFTSZDGaRaCgpDqsYY
         6dFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790107613; x=1790712413;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KsPUs6EBonqM96r2eMKS/17pMpIetLZ9bP0EB0PlUy8=;
        b=hb8XTY+hHrrYcrvpc61tEdfd6E7LhvuT6eQy8MslfteSy8wUThLT3js5gk9PqtRF+2
         Sa4vILrmxnoG4DCR/6aD6lWqg+cGR7YUGXlVZy6/OyoxdJ6b9BKiP0Z7s1okzWbKZv1b
         qAAB4P3hKkAhgC4BgFkVWIFrBu4A9lwEtDfuebJ5BKXfTHM7D1ES6owSkltsVbI/0faO
         UcFgV3YJxIFaeA4kikkdnyEABANbW24Tb3bJoLHEaRY15KtFTZo6twyCshnTG4APJxJK
         E3+TOkdTJDlUM6W7XIb1jYbTc+gLHjcLAw55ANZm1bcdYOInpeHhlUEvb3skoTHW/2zi
         nGsQ==
X-Forwarded-Encrypted: i=1; AKwUvBwa56hoGAOIFXQ9txjR1LJpW84TN3DFGWVesksNuoDXKqTW0clVds0qgGnK/aaPqrsAirv2laBrQ9zoZCiKhw==@vger.kernel.org
X-Gm-Message-State: AFuF++lHA8q2DhxP5vlHWMYrR3qxbrYw/ZrHRoahPUgbmnz93bEa7Q+r
	DNZa6e8ura3a6W85W0dnq8kyG6C8ao6mSxOUeJVpH15CmEhN+5X4cO7V
X-Gm-Gg: AYBFou1ZHGuWoykdfVOlhhi1QHTzyVSW2g7sZCfHBe3FOIuq8M35U3Ar4kOKHbkdOCU
	7HUHEazgnFxN29k/9XMBgOUfUNHZsQqO+47r+LIW0l7CcMH8z79msH1CIPFSL3ScKehUzqYEZv1
	kvYKD5H89BjpKcq8jT0PF/MtV4T6ZZ17Z86GdpYXAPxpQxxCDVKgChOaZjpniBpF7pm8Dkrlwln
	faUyYWaWx7+FpecX0XEFipsRMHGoxG/GR7duqFxxEmGuPf3S+KQ9IjTLe6V3Bvm4kZp8wYxkB7f
	cOSbzu0cjnvT7dTNDFGpVV/iQ+tXp+HJ7l4nKokCVQOuyS0iR9eOIrgYv8HRQYEKcQgR2ZvZLgc
	e+mqCUN9b2a6Q/ZGmV7L4WOlkKWhCz+k+y3V5qCVNY4UsEBKA2e28SbRomRzdDuvSLSEawTgTVs
	csGgWHapTlfi/ji40a3ZukO2HxUIuyhUoDfKBo7ACN5TD8AD1OAoiTaC8t6ROAE3ctCapNaEfza
	A==
X-Received: by 2002:a5d:5889:0:b0:488:6526:d60f with SMTP id ffacd0b85a97d-48867011b2cmr1079258f8f.0.1790107613400;
        Tue, 22 Sep 2026 13:06:53 -0700 (PDT)
Received: from vitor-nb ([2001:8a0:c4c6:f00:7647:61a8:deea:142f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886877a2a5sm919062f8f.26.2026.09.22.13.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 13:06:52 -0700 (PDT)
From: Vitor Soares <ivitro@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Vitor Soares <vitor.soares@toradex.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	baochen.qiang@oss.qualcomm.com,
	kang.yang@oss.qualcomm.com
Subject: [PATCH ath-next v4] wifi: ath12k: advertise interface MAC address pool
Date: Tue, 22 Sep 2026 21:06:42 +0100
Message-ID: <20260922200643.1133491-2-ivitro@gmail.com>
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
advertise_iface_mac_pool and enable it for WCN7850 and QCC2072. The flag
is read from the first radio, as all radios behind a wiphy are
expected to have the same setting.

Other platforms keep the existing behavior.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1

Assisted-by: LLM
Signed-off-by: Vitor Soares <vitor.soares@toradex.com>
Tested-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
v4:
- Document why the first radio's hw_params is used.
- Add QCC2072 Tested-on and Kang Yang's Tested-by.
- Link for v3: https://lore.kernel.org/ath12k/20260921173033.846332-2-ivitro@gmail.com/

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
 drivers/net/wireless/ath/ath12k/mac.c      | 54 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wifi7/hw.c |  6 +++
 3 files changed, 61 insertions(+)

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
index d4116ba0da08..c131358efb69 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -14743,6 +14743,56 @@ static void ath12k_mac_cleanup_unregister(struct ath12k *ar)
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
+	/*
+	 * wiphy->addresses is per wiphy, so the generated interface MAC
+	 * pool is advertised for the whole ath12k_hw. The hw_params flag is
+	 * expected to be consistent across all radios in an ath12k_hw, so
+	 * use the first radio as the source.
+	 */
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
@@ -14762,6 +14812,7 @@ static void ath12k_mac_hw_unregister(struct ath12k_hw *ah)
 		ath12k_mac_cleanup_unregister(ar);
 
 	ath12k_mac_cleanup_iface_combinations(ah);
+	ath12k_mac_cleanup_mac_address_list(ah);
 
 	SET_IEEE80211_DEV(hw, NULL);
 }
@@ -14878,6 +14929,7 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 	wiphy->available_antennas_tx = antennas_tx;
 
 	SET_IEEE80211_PERM_ADDR(hw, mac_addr);
+	ath12k_mac_setup_mac_address_list(ah, mac_addr);
 	SET_IEEE80211_DEV(hw, ab->dev);
 
 	ret = ath12k_mac_setup_iface_combinations(ah);
@@ -15120,6 +15172,8 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
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

