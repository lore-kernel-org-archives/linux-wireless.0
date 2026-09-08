Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5871C538D9A
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 12:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870528; cv=none; b=Lm/yz4iWGVS2mDGjLzvjUhBR3nBZVM0SYOzDN5IM4LyIe6FL6AzITkSK/A9vTqcSlMNOl9wwo0tLrk5LuHBuz9k4shHJwRf1zk5HM/R3djU11OSuLTDAoGc5xAjTQOSp63qVWru5ceAa6ih08Lf63q5kaNKGkHGHuR+1hdgJANU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870528; c=relaxed/simple;
	bh=1kYj3chelv9RZjRrh3kUb3WGPyo+nwjf1onB/etWUNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uc9/Sgyr1blKsN6S9rtmfkwqxLD1QUhen0NYI+RjtVzfp3m7lor361wTily7GKOyEFXF9HZVdADEUb3tjfJq4RNhZG9pDUJgzKpgA8QRmAfnMktK7Jb8VzF8fjoJFMzJesS75O2OGFspRLpYrA7Uo25PWEhiuIC0Zs4XKyFtN5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=UhHlViWm; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="UhHlViWm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=kxbRsuMHLSLvy9H4RFYKgh8LN3fEE19KWevxK4mylWk=;
	t=1788870527; x=1790080127; b=UhHlViWm3mqCH86rPCkRJD+pL76l3df4ecOWTNl3B7F6N4a
	eU8Tn0MzkdKdZ8qlsmEcmKnxW0ywxu8oStxAuccmktjecr25XVQ57dOjBBKequsJGvzZSGbqnihLb
	EWAR7n9P+X4I+Y6aV0eoOjm695mMQqe2vLDcI2aCRd3mvwksbCemaPFvguYlw9fRXRHz/sbRvfcZ3
	GWIISBEKu7ezzXbX7bRybxwVt/q9Fqs5cjfr4xWQ7GBCrNy1d9c21E1A1EKHtEHkA1dsLsA1YGi7g
	ySbsWw4yjE3VOO5GZdgGsVwLwQvLqcQcg/xJjoFvpGlcAJ0WNey87ReGN5iea3FA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3uwO-0000000670J-2E9T;
	Tue, 08 Sep 2026 14:28:44 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+582469b3a9ef5f13606b@syzkaller.appspotmail.com
Subject: [PATCH RESEND wireless 04/10] wifi: mac80211: don't allow link changes when iface is down
Date: Tue,  8 Sep 2026 14:28:15 +0200
Message-ID: <20260908122838.201719-16-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908122838.201719-12-johannes@sipsolutions.net>
References: <20260908122838.201719-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_set_active_links() only checks that the interface is running in
the inner __ieee80211_set_active_links(), after drv_can_activate_links()
was already called, so using active_links on an interface that's down
triggers the check-sdata-in-driver warning.

Add the missing check in the debugfs file.

Assisted-by: LLM
Fixes: 3d9011029227 ("wifi: mac80211: implement link switching")
Reported-by: syzbot+582469b3a9ef5f13606b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=582469b3a9ef5f13606b
Link: https://patch.msgid.link/20260904170057.56ab694fe989.I6d85e530bc2db6e48bfd13ccee0b71155e32b85b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_netdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index f3c6a41e4911..8346d3eb1143 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -729,6 +729,9 @@ static ssize_t ieee80211_if_parse_active_links(struct ieee80211_sub_if_data *sda
 	if (kstrtou16(buf, 0, &active_links) || !active_links)
 		return -EINVAL;
 
+	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
+
 	return ieee80211_set_active_links(&sdata->vif, active_links) ?: buflen;
 }
 IEEE80211_IF_FILE_RW(active_links);
-- 
2.55.0

