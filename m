Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F6B380FD2
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 20:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233409; cv=none; b=rEhF0/hFn1lmLC6gnWkiQBOQC9/VC0iGNCGZZjZeBPniJ4CBVrSQX6GXOLrd/w4kHRVYJdWi+4cuSOvWbypgr3dImB3bew4yKL83irgheuiNfxQS0fx9WiJoORIPN+VyxzUi739aXJbfBEG/ddT3nJZzq4VcBVHTCIx/ea3QA9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233409; c=relaxed/simple;
	bh=/qIxtn9K9jlTsofgQ7TWDKTLvzOmU9aeWkwk4YBxuSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYSoqnyCRwpGoho1CdP31WuzCPYBkVjytyu8IF5/QozV3EJHk7/hcZ552O/WTp+Uzdy4GVtyy91M8ldx8ZiZQlg+yEiz1rtNy3codXbOoGrGVtRROhJhSsEP7cWV6VnWcy+DT8FtiIYWQcN9sEM6zRQ1QTGQSSOIZic/ZSjV63I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=nAyxwLR1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="nAyxwLR1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=PgayW0FJtwnp20GUJAMJZ7dL1QEttsy1TI1R9l05sIk=;
	t=1791233405; x=1792443005; b=nAyxwLR1ZitkVR/MdTP+izap8CND9PPkj/G8asr4nz5Loez
	CZ0tDcQ+wxArD6Yr7KxlOdYjNkdac35xrrGgW1V/97AeUqWffECuGZJjM7xyQtbeSfAv5yI1MySLX
	epDZL3Jf8hdJNLnPJWQpPSR1GMm5cVRf79Cnrc955ZZTTjdaS4sVfSI9ReEuGC4oKY+9bEhE6o1RI
	QqukyfMNpw3wxbANKqAQ/+VbwwkpxwV5l1NlDYPQPdfMVDn3yAgMu6/+PdF34eGWvkLQaUjiKid09
	CEGBYL0iqD+IMWayYP2CByinSQtLSMDoai1TMa2blJiB5nwAi4z0RXeCwjgFkVGg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDpdF-00000005cw8-18Y2;
	Mon, 05 Oct 2026 22:49:57 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/10] wifi: mac80211: init radiotap iter after length checks
Date: Mon,  5 Oct 2026 22:47:56 +0200
Message-ID: <20261005224950.b5c2c31790d2.I091422db411b595bde4dba2de69334cd2aeb33b0@changeid>
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

The radiotap iterator initialization will already parse
the presence bitmaps, so it accesses a good part of the
header. This might not be present in the linear part of
the SKB, we haven't checked it at this point. Check the
lengths first.

Assisted-by: LLM
Fixes: cb17ed29a7a5 ("mac80211: parse radiotap header when selecting Tx queue")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1953ec35c783..ff493e9203e3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2182,8 +2182,6 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
-						   NULL);
 	u16 txflags;
 	u16 rate = 0;
 	bool rate_found = false;
@@ -2192,11 +2190,14 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 	u8 mcs_known, mcs_flags, mcs_bw;
 	u16 vht_known;
 	u8 vht_mcs = 0, vht_nss = 0;
-	int i;
+	int ret, i;
 
 	if (!ieee80211_validate_radiotap_len(skb))
 		return false;
 
+	ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
+					       NULL);
+
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
 		       IEEE80211_TX_CTL_DONTFRAG;
 
-- 
2.55.0

