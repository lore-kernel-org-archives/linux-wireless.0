Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792664327;
	b=lt38SG7m1LFVt6sJ6mrqLXhYHzP20Q2nQBzhajXEqH3UB85MdFto6yqmgU1nsPqAZs8z
	 xDMrzko1qPhpKTIq+y8m0PkV9WNYbwzMMqnDa7+YSg9dVFZ9Msmkwa9AYdobMa79VtSAV
	 ArY58oVSqEAJwy+PSUbdqne4vqEsutuxzcm5pZVN/dSSROc+R76YCsUmZTeuYCMERyUpc
	 OcjDVU2h5rfFKw2tyIXsSv74crlvOxngN5gIOzzshLBZ6eDGPZbCl92rablygbOI18vxJ
	 Zfx3aEAIYj1upD32e4CClwBQLpyfLFZ6LmLeeJzckQ8nCTRb6tos/XdUgZiuwUeXFdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792664327;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=jD/Op+QJIvr7Eci+eltA0t8HaDadQdflRRGDPUbyCEo=;
	b=Qn19uvX2hQkKqmfB1VYZMKwayN74BuRRYryumlhuaQUtRFSYEA2qJxHbzvrPMd7NnkRj
	 Akn5CnhGpxaSTTUxeev3URcGUxGK7QfyjUSn9Y+cYjXfmmDniwQ2DleD6HOPpAdEZQea6
	 5625RZxI9czVsmeBh1EZIvRgfrQ5xH7l2rHqHKeCLvF60QmZE5x3BPCiqjarU79gFXnP6
	 Q5GHHCS9QZp5HW9daA3pLhgS9dccoz0a52lY0qAELjEqw6LROhcshUTMfv9TlVV+peVHb
	 W7cJlNz6kzAS2UndTzOCbT54FFwoO09lCfU6oYUGJbHz1ki53SBzhFYSlqULWARyf6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=izJQIjJK;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1691606A324
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 10:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=izJQIjJK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=jD/Op+QJIvr7Eci+eltA0t8HaDadQdflRRGDPUbyCEo=;
	t=1792664326; x=1793873926; b=izJQIjJKeZpFQ7HdbiveqIYiLsh+j6yRYJpkpAVb9sy0OAT
	OJnLu2BMiAc74i/aFC/OOp2wOCQteBtXkU9qdMK6qgHzzlOr21QS+zQjw60qUcy1GcAKp8zvol+R7
	blDdTGj4zk3qjA9LW1q2vvR4rx1geL6ZnDspdMQOZFDMEVySbg20yxXFoXbR8oULREYSGTWyyiVmb
	sqgnbDFieHw0GP3rfbmu8IH8gkuoeldKYWZIfBb78rXqioNQ51xTwx2iTZDSL116ZuWXl5DLWjGS4
	1iQIKpmJELnboXrB7o+Z6vSXeXsrumNjCS8AwJuIR4RTVRfJLSqzpNOAJ0w3UFYg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xJpsi-00000004Ifb-2sjU;
	Thu, 22 Oct 2026 12:18:44 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 3/6] wifi: ath11k: register regulatory before wiphy
Date: Thu, 22 Oct 2026 12:15:34 +0200
Message-ID: <20261022101836.148512-10-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022101836.148512-8-johannes@sipsolutions.net>
References: <20261022101836.148512-8-johannes@sipsolutions.net>
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

From: Johannes Berg <johannes.berg@intel.com>

This order is going to become required, since userspace
can query the regulatory in the window between the two
registrations.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1a237adaa37d..04acd526a3ab 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -10649,6 +10649,13 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	    ab->hw_params.bios_sar_capa)
 		ar->hw->wiphy->sar_capa = ab->hw_params.bios_sar_capa;
 
+	/* Apply the regd received during initialization. */
+	ret = ath11k_regd_update(ar);
+	if (ret) {
+		ath11k_err(ar->ab, "ath11k regd update failed: %d\n", ret);
+		goto err_free_if_combs;
+	}
+
 	ret = ieee80211_register_hw(ar->hw);
 	if (ret) {
 		ath11k_err(ar->ab, "ieee80211 registration failed: %d\n", ret);
@@ -10663,13 +10670,6 @@ static int __ath11k_mac_register(struct ath11k *ar)
 		 */
 		ar->hw->wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MONITOR);
 
-	/* Apply the regd received during initialization */
-	ret = ath11k_regd_update(ar);
-	if (ret) {
-		ath11k_err(ar->ab, "ath11k regd update failed: %d\n", ret);
-		goto err_unregister_hw;
-	}
-
 	if (ab->hw_params.current_cc_support && ab->new_alpha2[0]) {
 		memcpy(&ar->alpha2, ab->new_alpha2, 2);
 		ret = ath11k_reg_set_cc(ar);
-- 
2.56.0

