Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [207.46.229.174])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7794C33D4E9
	for <linux-wireless@vger.kernel.org>; Fri, 29 May 2026 14:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.46.229.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780065301; cv=none; b=QVhAy0JMYA7sC2RP1gRVKwEYK5WY2MrIL2r6X+hwIgJBUgA6koyAnhmHypOCFsdRZsg8a27/e/3wqbLUNxtJbmm9e1a+LR9dGMVOzGQOqNvES77HrLu9mFzhUTO8sMzjUybZtbPrn+EhLG+JHzeAbE0/B7p30XAd3mDQ4b1Dlrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780065301; c=relaxed/simple;
	bh=l7Pwe43xDJmVxpHQtSFv9nm04HWQDf/yzjTu/w/iJtc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TccCsXbbw7zvRmLaiZlzwfN63bNzHthlxntK177779BegQnMlmgIY/LA02O/8vH1XtJTh3AVIbcVoagP51cXI+hpPABG71j6hdqxldBKi0j2KTC1bd5d5DzrwzVEjUjGHO3cnl8oKNajqjZCYOcKNbNMd6qKwD8KUTlwrfcwOpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=207.46.229.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowABXdb8GpBlqa1Q9AA--.24012S2;
	Fri, 29 May 2026 22:34:46 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	nbd@openwrt.org,
	linville@tuxdriver.com,
	yuantan098@gmail.com,
	zcliangcn@gmail.com,
	bird@lzu.edu.cn,
	xuyuqiabc@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH v2 1/1] wifi: mac80211: validate minstrel tx status rates
Date: Fri, 29 May 2026 22:34:42 +0800
Message-ID: <20260529143446.1374404-1-n05ec@lzu.edu.cn>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowABXdb8GpBlqa1Q9AA--.24012S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGF4kZFWfWw4kAryDZrW8JFb_yoWrAF47pa
	1xGry5t3y3Jr1xJrn7Jw40yFWfCF4fA34fKrZ8G34fZFnaqr45Xw1Igr98XrW3GFZxur1F
	qa1ktrn09a15CrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvl1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
	x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
	GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
	8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtVW8ZwCY02Avz4vE-syl
	42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8GwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQECCWoZTE8FhQADs4

From: Yuqi Xu <xuyuqiabc@gmail.com>

minstrel_ht_tx_status() accepts both legacy tx status entries and
rate_info-based status entries, then turns the reported HT/VHT rate
into a minstrel group and rate index.

The validation helpers only checked that the entry was present and had
tries recorded. They did not verify that the reported HT stream count,
VHT NSS, VHT bandwidth encoding, and MCS value were representable by
minstrel_ht's rate tables. As a result, malformed tx status metadata
could produce group or rate indices outside the tables that
minstrel_ht_get_stats() and minstrel_ht_ri_get_stats() index.

Teach the existing tx status validation path to enforce the exact
constraints used by minstrel HT's tables for both status formats.
Reject HT rates beyond the supported stream groups, and reject VHT
rates with unsupported bandwidth encodings, invalid NSS values, or
MCS values outside the table.

This keeps the fix at the existing trust boundary and leaves the
stats lookup path unchanged.

Fixes: ec8aa669b839 ("mac80211: add the minstrel_ht rate control algorithm")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
Changes in v2:
- shorten the subject line
- align the From/Signed-off-by address
- drop the Assisted-by tag
- v1 Link: https://lore.kernel.org/all/0e3f97ca5cfbeb67a8e60ca5c266f4335950816b.1779619788.git.xuyq21@lenovo.com/

 net/mac80211/rc80211_minstrel_ht.c | 47 +++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index b73ef3adfcc5..a35d42c77ac5 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -323,6 +323,43 @@ minstrel_ht_is_legacy_group(int group)
 	       group == MINSTREL_OFDM_GROUP;
 }
 
+static bool
+minstrel_ht_txstat_valid_rate(struct ieee80211_tx_rate *rate)
+{
+	unsigned int bw;
+
+	if (rate->flags & IEEE80211_TX_RC_MCS)
+		return rate->idx < MINSTREL_MAX_STREAMS * 8;
+
+	if (!(rate->flags & IEEE80211_TX_RC_VHT_MCS))
+		return true;
+
+	bw = !!(rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) +
+	     2 * !!(rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH);
+
+	return !(rate->flags & IEEE80211_TX_RC_160_MHZ_WIDTH) &&
+	       bw <= BW_80 &&
+	       ieee80211_rate_get_vht_nss(rate) <= MINSTREL_MAX_STREAMS &&
+	       ieee80211_rate_get_vht_mcs(rate) < MCS_GROUP_RATES;
+}
+
+static bool
+minstrel_ht_ri_txstat_valid_rate(struct rate_info *rate)
+{
+	if (rate->flags & RATE_INFO_FLAGS_MCS)
+		return rate->mcs < MINSTREL_MAX_STREAMS * 8;
+
+	if (!(rate->flags & RATE_INFO_FLAGS_VHT_MCS))
+		return true;
+
+	return (rate->bw == RATE_INFO_BW_20 ||
+		rate->bw == RATE_INFO_BW_40 ||
+		rate->bw == RATE_INFO_BW_80) &&
+	       rate->nss >= 1 &&
+	       rate->nss <= MINSTREL_MAX_STREAMS &&
+	       rate->mcs < MCS_GROUP_RATES;
+}
+
 /*
  * Look up an MCS group index based on mac80211 rate information
  */
@@ -1205,8 +1242,9 @@ minstrel_ht_txstat_valid(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	if (!rate->count)
 		return false;
 
-	if (rate->flags & IEEE80211_TX_RC_MCS ||
-	    rate->flags & IEEE80211_TX_RC_VHT_MCS)
+	if ((rate->flags & IEEE80211_TX_RC_MCS ||
+	     rate->flags & IEEE80211_TX_RC_VHT_MCS) &&
+	    minstrel_ht_txstat_valid_rate(rate))
 		return true;
 
 	for (i = 0; i < ARRAY_SIZE(mp->cck_rates); i++)
@@ -1235,8 +1273,9 @@ minstrel_ht_ri_txstat_valid(struct minstrel_priv *mp,
 	if (!rate_status->try_count)
 		return false;
 
-	if (rate_status->rate_idx.flags & RATE_INFO_FLAGS_MCS ||
-	    rate_status->rate_idx.flags & RATE_INFO_FLAGS_VHT_MCS)
+	if ((rate_status->rate_idx.flags & RATE_INFO_FLAGS_MCS ||
+	     rate_status->rate_idx.flags & RATE_INFO_FLAGS_VHT_MCS) &&
+	    minstrel_ht_ri_txstat_valid_rate(&rate_status->rate_idx))
 		return true;
 
 	for (i = 0; i < ARRAY_SIZE(mp->cck_rates); i++) {
-- 
2.54.0

