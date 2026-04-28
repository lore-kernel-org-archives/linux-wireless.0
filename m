Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983BD389DE8
	for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2026 09:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777368442; cv=none; b=hn0PKQMVeZbV9Cdz/qr4aFBZnEKMtyhALL3oMiPeVt6MdJfDVJGLekAoylt0vUThArdbDnhVHiSb+bNR5jFllDAX2ze7RQdabsQpJU6FdII+h840ok0tSHmMsyzPhZcwmRPwB6KB/goIiP1dTA7BSvPO2R17Zzf9DV9h2TZkpac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777368442; c=relaxed/simple;
	bh=pVt66lFcJNKtyXGXdaKqh3/SlWlQ+vQmIrOi7wqtNYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IedMy8iQDE4LbFiwqvKbOHs48ua6bCQ8ntQNTEntYmlsDcP7epjol9jdo1Fd/wmrz9PYM6H1ur1RgFKhejGzAucFhsLpdTMLBjLnqQkQw5G0OGWsgjKFjuMjLflQkvGF64kOWtrhJYYkNiw6+sEq8I30OXJOPRbxxIwzTqHbIxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=AaCtWOz1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="AaCtWOz1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=KGmbGeR2lKOMR8kUlqYW+dRtlBeLC7uUkx8VlxsCkdw=;
	t=1777368440; x=1778578040; b=AaCtWOz1WQAOgsNWzDgpVUH5sQKrIlr3yX3ELdkKCmfUiXi
	LsM9QQIsHgo1g0inrWUaxIOmQhnmRiXMxFUJqEbqktjjypmkv7nNyZLG8m1QoHCgmqKGy8PLvOEcX
	706/YA9RdiycD592H56/zhXv/d0qkEfaHMBdk3m8/TdsGhTsqJZmKtp36kWt5p7sl+7bayYpnZMEa
	WIb56gpoMGJdOAJa1sLW2AUyCaSQo98cIDNpYOhafxwP5GuI50RMeLDZVYBdRvtNviOcHd4ecTEYJ
	Fb/tEjrMhQW5oZi/MV/tlzcAiinw1bnF90cA5GHYNojWzZuC68UYwlrb5No4DmBg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wHeis-0000000HLwg-0wSz;
	Tue, 28 Apr 2026 11:27:18 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 07/14] wifi: mac80211: remove NPCA during chandef downgrade
Date: Tue, 28 Apr 2026 11:25:35 +0200
Message-ID: <20260428112708.2ab0e6f2e433.Ic39badb6782ef2242942424538f57e4a83391a06@changeid>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428092708.71740-16-johannes@sipsolutions.net>
References: <20260428092708.71740-16-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

We can't use NPCA any more if the chandef was downgraded,
for obvious reasons. Clear NPCA during any downgrade.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 89e82d34ae48..8c816a2a65f2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3831,6 +3831,10 @@ void ieee80211_chandef_downgrade(struct cfg80211_chan_def *c,
 		c->width = new_primary_width;
 	}
 
+	/* whatever we do, downgrading removes NPCA */
+	c->npca_chan = NULL;
+	c->npca_punctured = 0;
+
 	/*
 	 * With an 80 MHz channel, we might have the puncturing in the primary
 	 * 40 Mhz channel, but that's not valid when downgraded to 40 MHz width.
-- 
2.53.0

