Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A954CB8BB
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533788; cv=none; b=Jkxt5pta7JXgNlaMNRo3nHxAxiqJ0upfpybFXya0RCBgCEpYlf0JlMJmArJWwCYw69bfLQfRxAYMXBBf1hKyxA8rH3iBDS7MmhBM6egcJuteHZ0rSjEFIp9TeF5pfSdWzwNTPt3QASh9yesUt0ThYt6semvRWDoSdLAhVM5uu4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533788; c=relaxed/simple;
	bh=IkSyEEc44oVhhZCFf7G7fU+WxohhFExddRwq+DQ+pMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAiaIDn6cSGcsu5lEqUH5U9kyAZsDVTQ8jljok/MdNrBTewutRehm09aL5oYjiQIDjovrxDHunujCQiEKSP9eYcZSz75JeCOF5+fhz4uKSEDdqDjgdQS7qq/C+YIexVOucU0jAfckBtq5XZ95dM640wNuCtII5/hN4rh90O1KH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Zzt2gzQ7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Zzt2gzQ7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=iNRFT6oy1CpDfvM10gouVsk9kYBx0WDx3LOTvBi5IAk=;
	t=1788533787; x=1789743387; b=Zzt2gzQ7b9ZGNwZ0NebhHx6kLeeESC/+nQbW+Nvm6ufh2DD
	w5IGw0Inmo5okhSXykMlCBDfBCYvdcqsZb4rqtde6wsKt3fc1aqyjzW/XCenJgJ0XmpFjwWUxDPDq
	XcXpsOMscGdxLB66rk1lXGvSlxieZIT/dNt9aOMytoPipxqAQZkgneW/yBfGNyV3zuzE6KRxDnWe/
	jeh4EF/N0LbCbfw31uxaJmvKt1D0nbWkE0YJMmQUA+O7w7r6rGLvbMS1Jdhs9MnxPLgfudzynKk2V
	sVBEYQaPmUIa7OSggMepflkdhJnFCCpshc9G1+Z1F8+5A+7q5SK7MW7WRl5SxRpw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VL6-00000001SUL-3xwz;
	Fri, 04 Sep 2026 16:56:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+1a797e1c81be78a2ace7@syzkaller.appspotmail.com
Subject: [PATCH wireless 4/8] wifi: cfg80211: only group hidden BSSes with beacon entries
Date: Fri,  4 Sep 2026 16:55:04 +0200
Message-ID: <20260904165614.bcfa64715745.Iad740347c86de56d4ff4f96a95f3c3afc47c42de@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145614.423902-10-johannes@sipsolutions.net>
References: <20260904145614.423902-10-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

When a probe response for an unknown BSS comes in, __cfg80211_bss_update()
looks for an existing entry with the same BSSID and a hidden (zero-length
or NUL-filled) SSID, and if it finds one it groups them, using the beacon
IEs from the existing entry.

But that could find another entry without a beacon, if it was also from a
probe response (with SSID), so there's a group without beacon elements.

If a beacon with a hidden SSID for that BSSID arrives later,
cfg80211_combine_bsses() goes looking for the probe response entries that
belong to it - i.e. entries with the same BSSID and channel that have no
beacon IEs - and finds those two. They are already grouped with each
other, so it hits its

  WARN_ON_ONCE(bss->pub.hidden_beacon_bss)
  WARN_ON_ONCE(!list_empty(&bss->hidden_list))

which are there because an entry without beacon elements is not supposed
to be part of a group yet.

Only combine entries when a beacon was already received, ones that are
kept separate will be combined when a beacon arrives.

Assisted-by: LLM
Fixes: 4593c4cbe1c9 ("cfg80211: fix BSS list hidden SSID lookup")
Reported-by: syzbot+1a797e1c81be78a2ace7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1a797e1c81be78a2ace7
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 4fe114f6aee3..604b10ef0f94 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2077,6 +2077,13 @@ __cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 			if (!hidden)
 				hidden = rb_find_bss(rdev, tmp,
 						     BSS_CMP_HIDE_NUL);
+			/*
+			 * Only group with an entry with beacon data, otherwise
+			 * beacon data can never be filled/updated.
+			 */
+			if (hidden &&
+			    !rcu_access_pointer(hidden->pub.beacon_ies))
+				hidden = NULL;
 			if (hidden) {
 				new->pub.hidden_beacon_bss = &hidden->pub;
 				list_add(&new->hidden_list,
-- 
2.55.0

