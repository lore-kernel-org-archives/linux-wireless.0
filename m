Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA6E23C4F3;
	Sat, 10 Oct 2026 02:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791600144; cv=none; b=oFFwehcyhwYdCLPSuXW0njraepkQCKa348AIXSuHRJjCHK1J8fjXaPaUZrfqIk82wA8vIyCVsmoHPpEAZFE8W3nDPPDvDk/C6kFeqGWS6cmLof5sarIbSOi1ohvwSeADfJT4dc/PcTB3/eW5cFuNtyXi5k9nUrP+WW5891/D+Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791600144; c=relaxed/simple;
	bh=kkBexPvLRbpUan8ZY42wvNuO+G66DYo8qrAwPdK8f1w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qaWIbHBG2X6lXp47k2QduItviCfNPYxBFHu80xJt6hs5KPG8Qllr1xiaj5nOMdFto8Pu6FldWnm7topyP0Vl+jma7Tue4rcOo4Zr5Uy9eE/TXKTTvXnOc1/tBNQtW6hg3OllWar9dJr/GGvoj7X3OCQQFbJohWobAl8BsPbQMCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r2G2967V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r2G2967V"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA513C2BCFB;
	Sat, 10 Oct 2026 02:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791600143;
	bh=kkBexPvLRbpUan8ZY42wvNuO+G66DYo8qrAwPdK8f1w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=r2G2967VXwNdTVhzL/VMKeec9o6f7t2NjQ3M8i0KRyqPBAXoxMCv5pAR0n+CuGADs
	 mI4is7sAn4GvGNdh1yh4jNeHV1nh1tlzLG+4uTZsAjSZ2i377I6p2bJtGSW4zkVWtu
	 iT+YvD6bz2xH9rufaePEMK6xbdwMbND+7ZkpEoQr9NwFpG/6QbhlKxnOCXtKyL+yLA
	 ALZI1e2KBOhaaQgGXK7NQh4mWcsMNDXtyeRaAGz2LSy8A/NTwYKUMOKwahV+aiwxF9
	 mAVJD3zPNu4GXoBUvcawvYqzYESg4p7vTaUrd/DI8+V5QhwFCIJ/gKXDxr0tmqRoBB
	 QULAlYAWoWB0A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6A1CA9EBD;
	Sat, 10 Oct 2026 02:42:23 +0000 (UTC)
From: benthecarman via B4 Relay <devnull+benthecarman1.gmail.com@kernel.org>
Date: Fri, 09 Oct 2026 21:42:22 -0500
Subject: [PATCH 1/2] wifi: iwlwifi: mvm: Fix injected 5 GHz legacy rate
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-next-v1-1-b370f5302d27@gmail.com>
References: <20261009-next-v1-0-b370f5302d27@gmail.com>
In-Reply-To: <20261009-next-v1-0-b370f5302d27@gmail.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, 
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 benthecarman <benthecarman@live.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791600143; l=1797;
 i=benthecarman1@gmail.com; s=20261009; h=from:subject:message-id;
 bh=P1RM3YW4KpS+4q5w9KhQAa5Z7jbnUcHDOW45kcK15og=;
 b=OMaeSjn4aSgDqNa+kQSdmrGQL83w9Yy8oyxQiGaO6Pb72e9IuHSQgJ1llIVzIUz4TYBQCAXJO
 b9aDE2vEwgpAGUGkwqfL9vYYjaxT28Z3pWpXHRYkMlINlEW4Zkb7SNg
X-Developer-Key: i=benthecarman1@gmail.com; a=ed25519;
 pk=8RDA9X90+5wKUu3kkgPYpamlxYvX93l7iXqMWrkhvOY=
X-Endpoint-Received: by B4 Relay for benthecarman1@gmail.com/20261009 with
 auth_id=1149
X-Original-From: benthecarman <benthecarman1@gmail.com>
Reply-To: benthecarman1@gmail.com

From: benthecarman <benthecarman@live.com>

iwl_mvm_get_inject_tx_rate() passes the legacy rate index from
mac80211 straight to iwl_mvm_convert_rate_idx(). That index points
into the band's own bitrate table, which outside 2.4 GHz starts at
6 Mbps (iwl_cfg80211_rates[RATES_52_OFFS]), while the driver's indices
start with the four CCK rates. A frame injected at 12 Mbps on 5 or
6 GHz, index 2, therefore goes out as 5.5 Mbps CCK, which no receiver
on those bands can decode.

The non-injected path, iwl_mvm_get_tx_rate(), already adds
IWL_FIRST_OFDM_RATE outside 2.4 GHz. Do the same for injection.

Seen on an AX211 injecting data frames at 12 Mbps on channel 44: the
TX response showed rate_n_flags 0x8002 (CCK) and the peer never ACKed.
With this change it shows 0x8102 (12 Mbps OFDM) and every unicast
frame is ACKed on the first attempt.

Fixes: b99c4607973a ("wifi: iwlwifi: mvm: refactor TX rate handling")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: benthecarman <benthecarman@live.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index d3c2fe830..fb7e48aa3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -331,6 +331,14 @@ static u32 iwl_mvm_get_inject_tx_rate(struct iwl_mvm *mvm,
 	} else {
 		int rate_idx = info->control.rates[0].idx;
 
+		/*
+		 * mac80211 indexes the band's bitrates, which start at
+		 * 6 Mbps outside 2.4 GHz; remap to our rate indices as
+		 * iwl_mvm_get_tx_rate() does.
+		 */
+		if (info->band != NL80211_BAND_2GHZ)
+			rate_idx += IWL_FIRST_OFDM_RATE;
+
 		result = iwl_mvm_convert_rate_idx(mvm, info, rate_idx);
 	}
 

-- 
2.55.0


