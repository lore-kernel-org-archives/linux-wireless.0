Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1BC3B42D7
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 13:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789478528; cv=none; b=RuanWgO3pFvCDjwNtIx0WN4iwJ+OCymJTHIlS4U+O5qGLcV6xQQLSrSW7LDXXfXcpBI0BEit84iDXANtFKL+GTVAG837qh5KXgZRVuP95WhLipAhLG7Pr6yWH7URV993FE4Vz5FnF66FN6VpgHRHYRk1QAL5SJQBmH69YrXWL3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789478528; c=relaxed/simple;
	bh=0rWcs9o+SkOn395dgW4+/LPexUfLhA1D7IxGQTGq7rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTR7jwLQVUmErwYHt5A7FIHecFbzskD43hR8lX6ffWgkbqHeireo371SkYGMxY1oCr7dgyMCn+5n69iT1u/1/RM4K9rBseJnmBjr285DAMoJSAJXZoIW/ds52qbc6Tj9SWu1bHM4wa5XaKAsClcSvq6w/LMBhUGfD8OkLPPbn5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=id/Ey4HP; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="id/Ey4HP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=2bsp/rE6fgk4VuOjtsPw1McqdQ/wNKb8iOjT2cDblJU=;
	t=1789478526; x=1790688126; b=id/Ey4HP9ymkIceVdFKT7XyKsJGsCMaJ9E5Mgco+RsokDIe
	X778M1+oJKh1z2TY6cPyhSclbnRLyEX9gA5y9pdOOopt0HuNnynpJixX1op6wLD7yaM8XJUedeUxv
	ewhVWm85Y3w9P+eJSPH2G2cHigd5TBOFFn4e2LsOnapMDKDNIxJRPqaclzbsvDxvtuddi0QGhl/jh
	a22O1VM5gSdMpyKrgyua/6tDhp5V3Nm/DiNqT/zZpiN7PqlzMFFVniujsZnaJcoY8txcyvf1479oa
	wTYJ/MelYbzSboysb46wderHUIPy6Myw5kSYPUFla4HxwZXMCSbNx+YtdzNrryfw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1x6T6l-0000000H08V-2Ja8;
	Tue, 15 Sep 2026 15:21:59 +0200
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
Subject: [PATCH wireless-next v4 6/8] wifi: mac80211: report to cfg80211 when no STA is known for a frame
Date: Tue, 15 Sep 2026 15:19:32 +0200
Message-ID: <20260915151925.273a1c7a1ab2.I28d8146b9189c5961411ecb26b44588895de1b56@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915131925.1780764-10-benjamin@sipsolutions.net>
References: <20260915131925.1780764-10-benjamin@sipsolutions.net>
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
index 1273c9067aed..6c823678d099 100644
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

