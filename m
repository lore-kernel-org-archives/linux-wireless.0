Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FEB47729B
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 14:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787148209; cv=none; b=Mv3Wh6CkY+FfQzjxzRylmjsxS2/MRDCs1St/GH5+t7oYoG/y9OSVWlLmpzjsKvDerzADrsdfUL+oKZ4OHhD0EQTDeavehtYFkWOtRkefumIdDeFtUQjj49tdEV0t2pGi+i16msq17Fwwm8wkXyxIJVaytkcXAEotCv2AbhbR+04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787148209; c=relaxed/simple;
	bh=GJIGBaWo2noFGbmavamS09v7whnfR6LCjxjLjq0ZXb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLUeQIdB/B8NRaH0JJG2aYq1jnIQJb1ht6W2h51eCfyHO+o/hO3aLoMVFk76Zbz2lWl8htNx0oMhzkuByxPdsougDy8DgThsqsIs64yHimGkPp6dQlLdiy9jvgpyLzGG1ico0ljBL5d+pqo2zqwMKAtwcO+0GG/25QtWi09v/mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=f/1d5y2C; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="f/1d5y2C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=OwcmO0PYJh8VS3C7ePNgN6yZgGinLrRXHul6toqwmw0=;
	t=1787148208; x=1788357808; b=f/1d5y2Ca5TwVR0lPkzM8rfk8vaDSY0vgaf/EbrBFJRsQoU
	SxfyJrq8dzdKZB429+228UebrEY3Jj3qvhM+01anCxO6Ocu4mTJ8QwNn0U5P/i6IvSwOeQHPzHA5d
	C1tB5j7qeJPWkQZL1I6IgL4HytTuFMKBiG8iCKVJb8CQpZljBbA2Pydt4Nduzdp8yT/eIuLVC0qEo
	sHAkLzWDiAuuor3FH9Z9gF7rJapF4WvVgkXjUaUkarbkzAhkXHkfnafWzcTXcO1hOgI5/Xy/O+tj4
	sM4KYtFRjAlRLYT7FjwLb/80XCivFg0S9xpRgD6SYbrMEmNI4WjumYA5etMrktMA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wwgsy-0000000B7qc-2oxZ;
	Wed, 19 Aug 2026 16:03:21 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v3 6/8] wifi: mac80211: report to cfg80211 when no STA is known for a frame
Date: Wed, 19 Aug 2026 15:57:10 +0200
Message-ID: <20260819155703.7f0ac21fab9e.I28d8146b9189c5961411ecb26b44588895de1b56@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819135703.4072215-10-benjamin@sipsolutions.net>
References: <20260819135703.4072215-10-benjamin@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

This is relevant for hostapd to know whether address translation was
done on a received management frame.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
---
 net/mac80211/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f9e8c5ec7e1e..9a0d2f5a2c59 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3983,6 +3983,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 		.len = rx->skb->len,
 		.link_id = rx->link_id,
 		.have_link_id = rx->link_id >= 0,
+		.no_sta = !rx->sta,
 	};
 
 	/* skip known-bad action frames and return them in the next handler */
-- 
2.55.0

