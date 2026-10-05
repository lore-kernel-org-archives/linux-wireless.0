Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740FF380FD8
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 20:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233410; cv=none; b=E0X7vazm1ZTYdSXsZDEzOge6Z2jyj2UWHCMs3CB1wZ9eTwY60ysQHVdkcbXSE4adhXMwwewy7yQK/8+CfURFQ6F40uCeZuzlTv/p402fOvequE5GFveotyvg6iX0Pi593hejliYSSQPw47W64qGWfwLvcs3yJlUKGT2K/egYAK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233410; c=relaxed/simple;
	bh=rSwBQguv4Teq8oOgIfrxXthGTFIbt+2GuA0TEI7JfFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igoTe/huIidVYA9yOogsmqFmmJFT/exKpK3QMtcL4nKQMeHKgdUyut8TnJce1DKGWNYqPCnM8A3uoh0v1B8EkpouFKRaYCbbjzxhT85ZCw+sLk8PEznKHLyMhxQMxooFFg8jBTFx8jz5RcUmbmnImOs9yi6YyJjepT3JQC3YYHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=qLm26rms; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="qLm26rms"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=5ODUUxWnA+hLb+TblYTPCDh4KRhLjHzcSioyFRK+e74=;
	t=1791233405; x=1792443005; b=qLm26rmsAaBwUHo2MhOW6URhyLI0B5pqQvHRaTwbiFffHFW
	qNoL0rGmHu6wwELJicwncw/6U8htG/z7bHi28s7Ld0AtrTL3NADY0zAc9VX688hqeyNur7O6j9qFq
	ssKZJU3yNtlVUsAcf34rh05ivuWb0YF8HiFYGk8xY5PhfnairVdZNuEeS76O/h8Z3Mb82Tst8vd9V
	rWoBzqd7/+JKZQ46u9mqH5DLGCFplnLkSsWDmHYNOlBBjC5H6dzhWmp5cdFbGnw6kk3aBprdzgmFr
	250mR9uxuMgmo/bdFOx0WO6qM6Ply2z+Kc9cJ3+8LOS1fp52NAcRNNvGmGAYSKoA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDpdF-00000005cw8-3NKQ;
	Mon, 05 Oct 2026 22:49:57 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 06/10] wifi: mac80211: limit injected HT/VHT MCSes
Date: Mon,  5 Oct 2026 22:47:57 +0200
Message-ID: <20261005224950.68e210b8487a.I2ee0e4664c54cf31002eb9e4f5190fd05ff4130f@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005204950.2303430-12-johannes@sipsolutions.net>
References: <20261005204950.2303430-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

With radiotap injection the HT/VHT MCSes can be just
about anything, but that can later get problematic.

Limit them to the rates the device reports, which is
presumably going to be a subset of what mac80211 can
do, except for HT MCS 32 which some devices report as
supported, but then TX status can't deal with it.

If it's not supported just ignore the config.

Assisted-by: LLM
Fixes: dfdfc2beb0dd ("mac80211: Parse legacy and HT rate in injected frames")
Fixes: 646e76bb5daf ("mac80211: parse VHT info in injected frames")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ff493e9203e3..34f3a4ac7278 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2172,6 +2172,27 @@ static bool ieee80211_rate_bw_usable(u16 rate_flags,
 	return width <= cfg80211_chandef_get_width(chandef);
 }
 
+static bool
+ieee80211_vht_tx_rate_supported(const struct ieee80211_sta_vht_cap *vht_cap,
+				u8 mcs, u8 nss)
+{
+	u16 map = le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map);
+
+	if (!vht_cap->vht_supported)
+		return false;
+
+	switch ((map >> (2 * (nss - 1))) & 3) {
+	case IEEE80211_VHT_MCS_SUPPORT_0_7:
+		return mcs <= 7;
+	case IEEE80211_VHT_MCS_SUPPORT_0_8:
+		return mcs <= 8;
+	case IEEE80211_VHT_MCS_SUPPORT_0_9:
+		return mcs <= 9;
+	default:
+		return false;
+	}
+}
+
 bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 				 struct net_device *dev,
 				 const struct cfg80211_chan_def *chandef,
@@ -2368,14 +2389,20 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 					hweight8(info->control.antennas))
 				info->control.antennas = 0;
 
-			info->control.rates[0].idx = rate;
+			/* MCS 32 and up aren't handled, e.g. by TX status */
+			if (sband && sband->ht_cap.ht_supported && rate < 32 &&
+			    sband->ht_cap.mcs.rx_mask[rate / 8] & BIT(rate % 8))
+				info->control.rates[0].idx = rate;
 		} else if (rate_flags & IEEE80211_TX_RC_VHT_MCS) {
 			/* reset antennas if not enough */
 			if (vht_nss > hweight8(info->control.antennas))
 				info->control.antennas = 0;
 
-			ieee80211_rate_set_vht(info->control.rates, vht_mcs,
-					       vht_nss);
+			if (sband &&
+			    ieee80211_vht_tx_rate_supported(&sband->vht_cap,
+							    vht_mcs, vht_nss))
+				ieee80211_rate_set_vht(info->control.rates,
+						       vht_mcs, vht_nss);
 		} else if (sband) {
 			for (i = 0; i < sband->n_bitrates; i++) {
 				if (rate * 5 != sband->bitrates[i].bitrate)
-- 
2.55.0

