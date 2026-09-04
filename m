Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D328A4CC272
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533789; cv=none; b=Fe+5SkfUU/AkwCFLouKEA/AjGgyYJbDCgQv7WR2+qXGmPx+fj4EYftcQgoFSDlFRA+fYp6BS+Z+nyiidlB6OuGXpezVpbhKs+7UIf8LynzTylmTqEqw095UMxQ5eLt40YXHLjMptCcaPayyIuDY2D34gv0PRfdUl+a+wufY27DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533789; c=relaxed/simple;
	bh=hOSCXfy/ceoKwaaCVRhdH+bnfLRkWhgIlSMhgTlIpt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHEi59sn+yQ34XpTmPCyZes9G6P+vsQutKnGJJtAdS6FjBLm+eBFR6iK1KtXdp4sZKaTkCcXewWp5hdizXw6DaWSDHVxzfN/WDJLOii4gSqONoXT1qSkel3zHy3LYrV2B/5gDjrxIPrNNDdMujYS9Thh4tP+3W0NIUjkLzzwvC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=x3U/aS7X; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="x3U/aS7X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=BHq3gp6rCyLhM6OOZNiW1NrcrlYG6c6U0vHv1K3zQlM=;
	t=1788533787; x=1789743387; b=x3U/aS7XRDV5ISP8ksq0uz+C2PP/JXokUbm/NOPGkNOIEqK
	gKC1xqQnvR5kewvcFPEfjn1MWQp8Hdk84N+nxBcO+FJNCPUNBtyuiwvK/AbqCIXtlSn1U0TwdGFME
	MWLqWc04Ze4ThY4u5oZUnQV1P2J39KB0Go010hmqXiZOwZp4+cYTv5bSRrQQhbTkgLldQccyyJmRO
	Y40dUMUxIWJNppf3AN8MHu6D9StTam1eHe1ybR0K5bxU1QZRonKBCO+IGPOuF9xCBAWMF2Gri7kpV
	F09JlWgAXWwuMHaUvPq6ZeH9Tyj43l/6QxSdrPa9AXjcAQz5Gi/GLyYGXdKUlCxw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VL7-00000001SUL-2E8E;
	Fri, 04 Sep 2026 16:56:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+dc6f4dce0d707900cdea@syzkaller.appspotmail.com
Subject: [PATCH wireless 5/8] wifi: cfg80211: don't filter by BSS type when removing stale entries
Date: Fri,  4 Sep 2026 16:55:05 +0200
Message-ID: <20260904165614.1f05dae1c546.Ib52d57b57caa912efee020f9d4a033a5160617ce@changeid>
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

When an assoc AP switches to a channel that already has a BSS entry,
cfg80211_update_assoc_bss_entry() removes that entry before rehashing
the real one, since the two would otherwise collide in the BSS rbtree.

The lookup for that entry also required it to match the connection's BSS
type, so an entry advertising e.g. the IBSS capability bit was left in
place, and the following cfg80211_rehash_bss() then ran into it:

  WARN_ON(!cmp)

Changing the type shouldn't really happen, but can be triggered by a
rogue AP/device, so drop the check and remove any entries matching
the comparison.

Assisted-by: LLM
Fixes: 0afd425b1b64 ("cfg80211: fix duplicated scan entries after channel switch")
Reported-by: syzbot+dc6f4dce0d707900cdea@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dc6f4dce0d707900cdea
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 604b10ef0f94..caa9c6495f20 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3502,11 +3502,6 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
 	cbss->pub.channel = chan;
 
 	list_for_each_entry(bss, &rdev->bss_list, list) {
-		if (!cfg80211_bss_type_match(bss->pub.capability,
-					     bss->pub.channel->band,
-					     wdev->conn_bss_type))
-			continue;
-
 		if (bss == cbss)
 			continue;
 
-- 
2.55.0

