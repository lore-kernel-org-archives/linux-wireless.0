Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4CC545DBA
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 12:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081335; cv=none; b=alOA1jZLnM3eGmJCv/T2jOBDNd+LPpF5u1mNJ7XvFl4AT1wE9w3ZvAleCw/cqHAShz0+fuNjpAahdLUP1UfizHQ2/H8e3fG8yiSoc8IuAal7cSF6ibNeE0MeMSQFqKJaxk8l56oD0gKPD+daeuVJrwQxsdUkYf6pjdpdAk8E0vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081335; c=relaxed/simple;
	bh=2cLxqEAvRqom84cHGhANqcvNaUpLmJhJ3KJ0g3oP1Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HZrEsDhkq4H+OsfLe9/ROs8XSktwwPMjbQGZjyKyKNahlYxXL6ljEOuZLE3xUQtEaGKBZbtns1B4BFxo/aOEAnHeeizRoWLZmzxjXlIP9RJu4chClOiX+hIutqgD/jz3I8ITcsvp6Lt9CMc9clQ6415FNlrnQdx3SZMq5Sp0ClE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=fvfbRIur; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="fvfbRIur"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=tp5d0ykSWdmQPUsFqE5gw/OJWXQbV3f90/MdS18cnoc=; t=1790081333; x=1791290933; 
	b=fvfbRIure/QWS4NVf/dyi2FLxSaQ7Beu/Lffej6MDnbR2ZhWDLuasNQJ0ddtcimIAvtkoELSjoV
	9AsvfyW5YAsKyosn447wV2lypb2mIOzSaeO5TnJ1tgBLJ6ze/bRXgC+BGGQibvbWQs2RGIqdQ44pe
	lCIe223eUFGs834N3IQIoCcyMRdLnGO0YuPChKvC2gLpXH/00839Mp1Nf0h8L23KkpB1PblNLFZ6S
	tZp74Pkao4FzcIJ0gekD3+xmayhfAtRbZDaA+FhIHXagHbKu8Y8MfCeg+Yw+qqxVFSAO3eLOCmXW3
	vbS1LEqwEHpku3GCB49rosx0o5RFVs1nZ/kA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x8zvU-00000006uqc-1hts;
	Tue, 22 Sep 2026 14:48:48 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+ac648b0525be1feba506@syzkaller.appspotmail.com
Subject: [PATCH] wifi: mac80211: fix potential ack-skb leak on error path
Date: Tue, 22 Sep 2026 14:48:45 +0200
Message-ID: <20260922144845.729cf61a017b.Iabf0248920a1e70c9f6f321fbf163fc10e5f0884@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

In case this warning hits, which shouldn't but could at
least due to an unrelated mesh bug, an ack SKB will not
be freed correctly if present. Fix that.

Reported-by: syzbot+ac648b0525be1feba506@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 83b758724edf..e897116f8b7e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -6552,7 +6552,7 @@ void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
 			rcu_dereference(sdata->vif.bss_conf.chanctx_conf);
 		if (WARN_ON(!chanctx_conf)) {
 			rcu_read_unlock();
-			kfree_skb(skb);
+			ieee80211_free_txskb(&sdata->local->hw, skb);
 			return;
 		}
 		band = chanctx_conf->def.chan->band;
-- 
2.55.0

