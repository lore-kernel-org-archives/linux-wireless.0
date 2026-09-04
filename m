Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880534CB8BB
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533850; cv=none; b=A85HuZ0jhKHW5DbyAsm5I3R26PxI1Q3r0jRZmzy7cTCLKu/LjjRybLE3fgbYMzN6DAeXgILGyfWrfnuiqdzIulZfFDMUePWOQK5lo4FFKrw/0aOwDEcVOmiyFqoCxC3E4rH7fgfG0fQmWCDEehBzg1308Z79CYFIZ6cv4obkXe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533850; c=relaxed/simple;
	bh=YK1stIQVq4Oy4i4x8+kn1gQQBqF0If0pjKRs8DcS8+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsJDXaHpnJCpXCZ0/Q0Sq2lExItu2cveyfCCdwlVLACZ3NYbDH+6qAotfbtlEGu3grpt0A0E/W3Mo0kmVxCAKjkCNEl2otOSBvofLxQj0i22+9/z1zEa/8+ZkImUtAhRky8mYN+SfzMaIUOG4fHcixp25176Q8B1QKEbByIwXJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=lY4imkt/; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="lY4imkt/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=u6N2eq54KKX7IBxxOemsi5XufAhSrd323GXwY+DaxTo=;
	t=1788533848; x=1789743448; b=lY4imkt/tHwV5mETdwY/eONcc2yd1y4vneflVbIAa6xw3K0
	1oDc2K+GShkHEijUO/p4+LDNhKIjety+eAWlVOx7ZJ+eEdNzGZKc8blK2EBfEQQgYiz54JOud/M36
	2dxK8sTJw/S64R/xsOFaHf1PFZDnEWWa0KEAb7a/YXMBA0LZEw47wflEQu0nKKhPoi4SzgjziVMjX
	BoHFQV5OyJu+78jFlTpzUeU0qGnHFZi4/v4KMGI+bMQ6bUAIqVhXHaAjyGZWRu6Sp826wChBJkaQ/
	qsegmWS846hafC8IeEdh807uVSU0nLwrkcurxDQV5kxAgDOks6gGkl9YAalw/YFQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VM5-00000001SWk-48YU;
	Fri, 04 Sep 2026 16:57:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+34463a129786910405dd@syzkaller.appspotmail.com
Subject: [PATCH wireless 01/10] wifi: mac80211: don't apply peer rates to off-channel frames
Date: Fri,  4 Sep 2026 16:57:05 +0200
Message-ID: <20260904165722.ade6b07421b8.I59b7ea810eb021a7a68b3090828a757b6dd85e57@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145722.424159-12-johannes@sipsolutions.net>
References: <20260904145722.424159-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

All the off-channel frames (including scan) aren't really part of
the connection, so don't apply the station rates even if they're
being sent to the station in question (e.g. by accident). They
don't use the rate mask via IEEE80211_TX_CTRL_DONT_USE_RATE_MASK,
but the station might not have rates of them either, hitting the
warning found by syzbot.

Assisted-by: LLM
Reported-by: syzbot+34463a129786910405dd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=34463a129786910405dd
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rate.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 64768abb0a5f..e910f03af777 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -372,6 +372,14 @@ static void __rate_control_send_low(struct ieee80211_hw *hw,
 	u32 rate_flags = 0;
 	int i;
 
+	/*
+	 * Frames that shouldn't use the rate mask could be anything,
+	 * even on a different band, so don't take the sta into account
+	 * to avoid ending up without rates.
+	 */
+	if (info->control.flags & IEEE80211_TX_CTRL_DONT_USE_RATE_MASK)
+		sta = NULL;
+
 	if (sband->band == NL80211_BAND_S1GHZ) {
 		info->control.rates[0].flags |= IEEE80211_TX_RC_S1G_MCS;
 		info->control.rates[0].idx = 0;
-- 
2.55.0

