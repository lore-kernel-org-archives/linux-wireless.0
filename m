Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5D93E51E2
	for <linux-wireless@vger.kernel.org>; Wed,  6 May 2026 09:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778059958; cv=none; b=W27gsOdOl/ro3PU7ukmSL+UbFY9IOHTlgvSru9X+emVihkU8AbOEkBP9bKxncolik1eex39uv1sHMVnSh/MWtcJEbhbM9x8tn801U6V3xcpIK7m1RvSw5EurAv7b6qJIFuc7S+Wsomq6FTMrbe97pxnX7JrbI66ZUq1Tqi/p8Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778059958; c=relaxed/simple;
	bh=5hw8t6+03h5GKEt+6wzsE4YPVv0Kn68U9mCG78WS/MM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=INyQIxJtXEOrdF0aO7gNl6CioiT1UPU2RnXM/LV8d9YNW1Fxu9e7hxbOLCYLkgVA1A1nKnqFd5RnjOFmnSePvbeXfRXSdb3LPlDXQkO0pif8alU1bGm5Ql/FrII8qaCP3QyghNeNqtClCoKQh+duY3xJa0lyJgFP1ud1Tf9FP3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=JSLc44ER; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="JSLc44ER"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=6tasgu3nfTBr/hhMm4mGalBWq5Eq5G6LeaeKzvMy+Kg=; t=1778059957; x=1779269557; 
	b=JSLc44ERWUiRMZNocNPonIomdY/IhSfRsYdUFm0UXk8eOklObhQC+31OComAn8KY+HJOTiiwkRM
	1AAixv7ugLJOgD3zXqaXcMZTogBoCD9+Sf9qVEk+y9X6DP6EQO4ZbNa4Nmv7yhu6Fcbdb9Rj4yYnM
	EEhNKizaLPWmif2UetStmyBhTFfzXSiFbRGoJuFuNtKzjHnvFQ/Vwpyyrx4r8T/qwYifD8pRJMe7k
	W5GnILzdNBziQ7QRzqPlErhKXpA7muWqUufhUtRIAtPm1TRaIkWzUm9pAAPNKWLUwJrCjouKyoywj
	jGypM/E6N8f7dds85bArvd73xpBDlnREiylg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wKYcM-00000000nKE-1Dc7;
	Wed, 06 May 2026 11:32:34 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211_hwsim: claim HT STBC capability
Date: Wed,  6 May 2026 11:32:32 +0200
Message-ID: <20260506093231.155762-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This is already claimed for VHT and HE, so it doesn't really
make sense to not claim it for HT, and this causes sigma-dut
failures since it assumes VHT support implies HT support.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 3a0c4366dfdb..923196173efc 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -5815,7 +5815,9 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 					    IEEE80211_HT_CAP_GRN_FLD |
 					    IEEE80211_HT_CAP_SGI_20 |
 					    IEEE80211_HT_CAP_SGI_40 |
-					    IEEE80211_HT_CAP_DSSSCCK40;
+					    IEEE80211_HT_CAP_DSSSCCK40 |
+					    IEEE80211_HT_CAP_TX_STBC |
+					    IEEE80211_HT_CAP_RX_STBC;
 			sband->ht_cap.ampdu_factor = 0x3;
 			sband->ht_cap.ampdu_density = 0x6;
 			memset(&sband->ht_cap.mcs, 0,
-- 
2.53.0

