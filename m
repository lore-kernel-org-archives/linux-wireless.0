Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651945;
	b=AQG12Txf5Zm/1mYjXpsw4fGBNQ1FSwOar4ugt89hlQCsNeAFkx2aqnd64JHYOfc9ApyD
	 koIl2u/q47Re2fbABYt+kX1XQu8NzglYGh1gEiCKVIj84eV2+zLnsL38eKWSmNMHBb0O1
	 2XKrNP08YID5Hry7Ml3pwYJ5xrBtDmZ1PXl6EEF9IOCvp6+ZLWgRaC23WLtzmTJYtrpVD
	 SWVE7yxaZl2UAc4XWOFHqwMBqMywOtQN3j3ckalKuT5+GG/Y2WMyiAd3tM5nSW3GxFWSN
	 DDyv1gMLJSU4sC5hkJmbW/dPWdHSh23cfqKJFIPsQNhyjJwBHShIAI+19PrFIIOQHoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651945;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=eQ4tz6N0WeYNb+t8ppFO4UPsXqy46qnjj6rqi8Er98Y=;
	b=DS74Tmb8DcuLvc8A+hzq7l51H7XLWhoSBPDfa+hngbX3ATJKSUNlGmcaNKZSjHn5n9tl
	 XJOuDqgMLIFbhQrqgVcKx18RF2O5IvJc8MbCLeZsBZ/CIbPcopH05YblUdLF5oCmYAGQC
	 ds+lDyS/J2PHdB6MZaOHIW1yPznGLkqDnHeoduSup3nz70NJHDVXAjCqQfAvyBBrFcvRR
	 9HaOj8EiqVol4ySEnTtoPkmthXXr54Ewu+SAPEUncpaF1shkHlOrBnrWZiD2wzbcHOU63
	 FmgdMGJNP8pGui3uD6JRdtOO8CD5jenNsm5IXQVe5xWjBBNGqoUZSnilx4/V2RMvXnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=q8XmKaij;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4488E606A333
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=q8XmKaij
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=eQ4tz6N0WeYNb+t8ppFO4UPsXqy46qnjj6rqi8Er98Y=;
	t=1793651945; x=1794861545; b=q8XmKaijTTWD1uWI1jABMHifkHA5pTL4/oI2VFo/Xb3Dnw5
	900dos46ivLVL1nL+9dTyeLk4HK179ivv3nxa/ZGVXer3E1mAle2aPvx0LRZj2+u/nIM3PigG00Ys
	CeTfwXDcj5QXaxUBBm9isSnWr0bNZ7AMul1FnaWLQ5gg9J8SCzz9r8QhQ9F0nR9WTBR+stAox24oi
	lHAHxEU7RdoVAO1JmFWutNPs+ikfZxQfol8VaMtWfHvLSsOeALddivi3wRT3e4L63ZeiURBuoy2j0
	OEyBEBP37qbErzZ5UV9NBkWpq/PJGloSPigJ8fnnCJrUph7HI+/NuQ3bmaI/0DGA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNyo3-00000001vzr-0W6Z;
	Mon, 02 Nov 2026 21:39:03 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 25/30] net/fq_impl: allow pulling packets from the same flow
Date: Mon,  2 Nov 2026 21:23:15 +0100
Message-ID: <20261102203831.1058362-57-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102203831.1058362-32-johannes@sipsolutions.net>
References: <20261102203831.1058362-32-johannes@sipsolutions.net>
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

If fq_tin_dequeue() returns a packet, also (optionally)
fill a flow pointer and add a function to pull another
packet from the same flow. This will be used for A-MSDU
aggregation in mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/fq_impl.h | 34 +++++++++++++++++++++++++++++++++-
 net/mac80211/tx.c     |  2 +-
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/net/fq_impl.h b/include/net/fq_impl.h
index 8aca881937da..eb8802dd2a26 100644
--- a/include/net/fq_impl.h
+++ b/include/net/fq_impl.h
@@ -87,9 +87,14 @@ static int fq_flow_drop(struct fq *fq, struct fq_flow *flow,
 	return packets;
 }
 
+/*
+ * Dequeue the next packet from the tin; if @flowp isn't %NULL
+ * set it to the flow for use with fq_flow_dequeue_next().
+ */
 static struct sk_buff *fq_tin_dequeue(struct fq *fq,
 				      struct fq_tin *tin,
-				      fq_tin_dequeue_t dequeue_func)
+				      fq_tin_dequeue_t dequeue_func,
+				      struct fq_flow **flowp)
 {
 	struct fq_flow *flow;
 	struct list_head *head;
@@ -131,6 +136,33 @@ static struct sk_buff *fq_tin_dequeue(struct fq *fq,
 	tin->tx_bytes += skb->len;
 	tin->tx_packets++;
 
+	if (flowp)
+		*flowp = flow;
+
+	return skb;
+}
+
+/*
+ * Dequeue another packet from the flow that fq_tin_dequeue() returned,
+ * e.g. to aggregate packets.
+ *
+ * Note: If the lock was released between calls, the caller must check
+ *	 that flow->tin is still the same tin.
+ */
+static struct sk_buff *fq_flow_dequeue_next(struct fq *fq,
+					    struct fq_flow *flow)
+{
+	struct fq_tin *tin = flow->tin;
+	struct sk_buff *skb;
+
+	skb = fq_flow_dequeue(fq, flow);
+	if (!skb)
+		return NULL;
+
+	flow->deficit -= skb->len;
+	tin->tx_bytes += skb->len;
+	tin->tx_packets++;
+
 	return skb;
 }
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7d1d1754d931..fbe77131799d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4222,7 +4222,7 @@ static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		if (unlikely(test_bit(IEEE80211_TXQ_STOP, &txqi->flags)))
 			goto out;
 
-		skb = fq_tin_dequeue(fq, tin, fq_tin_dequeue_func);
+		skb = fq_tin_dequeue(fq, tin, fq_tin_dequeue_func, NULL);
 	}
 
 	if (!skb)
-- 
2.56.0

