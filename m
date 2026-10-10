Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBA63803EB;
	Sat, 10 Oct 2026 02:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791600144; cv=none; b=X5Pc3ssnb2sO1iiuPkohRuYUbl9me9oHNbF6whxz/nykix1/A8YYvgO7gyJVQW4wg3V78GIjFLbjl5GskCm6+2zx+txEbvXEEjakn4bUswfJBjWpKXBwWBUnWC0VyPFEAFQ2Tv6Ib+KUu3Cz95DAzEiCJlFq0qOz6suplP2v6Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791600144; c=relaxed/simple;
	bh=8yc0zugkBJzof1AlwHpfqAOlgpcVnnL/9zPM0W+0Cng=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=agCfppEdjAWpF/Pqsu82X8t3NdDV6p7L7jypaNcjdVQMk4x711fcAfRkpqphTPkiYkL6x+0cbTHwMV6cULi8MZ7+aMXVk+dCtwyu24o0BKC5ypNRirjpTpeq/uwBtzKQzbrv4q7CRGWc1I4J3FhBTMgGjpAJg55zxjQ3qmd9nBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cwrKi/1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cwrKi/1+"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D681AC2BCF7;
	Sat, 10 Oct 2026 02:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791600143;
	bh=8yc0zugkBJzof1AlwHpfqAOlgpcVnnL/9zPM0W+0Cng=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cwrKi/1+ZJf3gBWSOOPocCvsShGUAiCpSPm86HnNKg+tzYoapEEs5EQ14ngDnUgC1
	 HMpsXiwJ+UxP4416sKjUYUvEpp+cUkxDHfBO984JA8kZBR8j5BU6umDHN99Kt7btYg
	 1+X2H/tkJRN2HSuHNs/PVA9cR/2vrmLdc+nOgGFXkTX66a4uZMi/+j7PX037wb+79s
	 nS/zu9Af1AFsIfLhoL0Gi8KMErnxdW1BQxWag+2l7GmikkBhtXEHRHLr3/mtBK6gUH
	 y0i0IIIMfRljUbW8vERV13F+oeaxZWi5wc+s/xSDFiMvm8mh9dWkoziIZYorvpn8kP
	 2oWwTvZ7mEOTQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1A4CA9EBB;
	Sat, 10 Oct 2026 02:42:23 +0000 (UTC)
From: benthecarman via B4 Relay <devnull+benthecarman1.gmail.com@kernel.org>
Date: Fri, 09 Oct 2026 21:42:23 -0500
Subject: [PATCH 2/2] wifi: iwlwifi: mld: Fix injected 5 GHz legacy rate
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-next-v1-2-b370f5302d27@gmail.com>
References: <20261009-next-v1-0-b370f5302d27@gmail.com>
In-Reply-To: <20261009-next-v1-0-b370f5302d27@gmail.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, 
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 benthecarman <benthecarman@live.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791600143; l=1532;
 i=benthecarman1@gmail.com; s=20261009; h=from:subject:message-id;
 bh=pSIiTmEuNFIkLVvwgBMZ4Ct5zrF6uVX3C8GZKbTPvWA=;
 b=LIAybz80fCTnZ1BSv6A41an3QQM+78UE2NYejokmHRGdhMv+t4aeX1WlabimIBXQMxuxoxA7i
 VSAF7/aH+wpCCTuHlncsizrXRhnpJUfiPIeeP4dFvRXgRkkv3QWeuRD
X-Developer-Key: i=benthecarman1@gmail.com; a=ed25519;
 pk=8RDA9X90+5wKUu3kkgPYpamlxYvX93l7iXqMWrkhvOY=
X-Endpoint-Received: by B4 Relay for benthecarman1@gmail.com/20261009 with
 auth_id=1149
X-Original-From: benthecarman <benthecarman1@gmail.com>
Reply-To: benthecarman1@gmail.com

From: benthecarman <benthecarman@live.com>

iwl_mld_get_inject_tx_rate() hands the legacy rate index from mac80211
to iwl_mld_mac80211_rate_idx_to_fw(), which expects the driver's rate
indices. Outside 2.4 GHz the mac80211 index points into a bitrate
table that starts at 6 Mbps, so a 12 Mbps injection on 5 or 6 GHz goes
out as 5.5 Mbps CCK.

Add IWL_FIRST_OFDM_RATE outside 2.4 GHz, as mvm does for frames that
are not injected.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: benthecarman <benthecarman@live.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/tx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.c b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
index fc501ac0c..317573b5e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
@@ -599,7 +599,16 @@ static u32 iwl_mld_get_inject_tx_rate(struct iwl_mld *mld,
 		if (u32_get_bits(info->flags, IEEE80211_TX_CTL_STBC))
 			result |= RATE_MCS_STBC_MSK;
 	} else {
-		result = iwl_mld_mac80211_rate_idx_to_fw(mld, info, rate->idx);
+		int rate_idx = rate->idx;
+
+		/*
+		 * mac80211 indexes the band's bitrates, which start at
+		 * 6 Mbps outside 2.4 GHz; remap to our rate indices.
+		 */
+		if (info->band != NL80211_BAND_2GHZ)
+			rate_idx += IWL_FIRST_OFDM_RATE;
+
+		result = iwl_mld_mac80211_rate_idx_to_fw(mld, info, rate_idx);
 	}
 
 	if (info->control.antennas)

-- 
2.55.0


