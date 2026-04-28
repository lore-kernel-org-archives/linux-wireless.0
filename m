Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DD738F954
	for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2026 09:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777368440; cv=none; b=Yg/968AEZs9Mpjw3H9cgYmTDq4u0DOuDAHQgDI1sHpQj9bbh+4/qN6Fgh1ajwNXWv6uwT8mPmtSZ7h9VRe3t7MjoOZlYXzpYPMVE4a0mQaVLwGanhc6u+PNteqlGMe7orD9DSrv5uGHx1ALxcPvkzV0MiXMeKop0GmUlj822ESI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777368440; c=relaxed/simple;
	bh=0nirCK2IjkBhYxPYZ92NAifXacNqeUYtMVbPf2AuOno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/HoyadWw89SHz8gDuyFN8amdTNcsRh/ZP36ses+21rV4EziF9TV4Bw0PUCGX5LWsVReVcS8+mSBU/ix9LC2a11s1ZBhMyQJpIjGZArMkK4vFWsM7+J0LfqU0qP7WBmoiaszUnqOv9tXKZQr89ahB/hqmk0e4vzrsNRMyxL+MkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=xIGii8K4; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="xIGii8K4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=2RmGvn+gwKMJNUfvx8Sdq5PpMuVGlOZEboX2zEYJoBo=;
	t=1777368437; x=1778578037; b=xIGii8K4tnaExQJEBldJJIiAZs9onPpwxvZXCQYITofElxz
	UtlakN0MD28MVJ8tU7abiQ+wPthx+FlWN1ATG1oYa7mv+hNaQ4kDNpx4Dzj/PzMXlXNZZCbguiylM
	gkJI7duDrA9ctIZxueRAQNw6qXjJ5aD/KjGE6+AncVUfN9oxcJISpHd+c1bx2cjYGB4kU1J+YBdfv
	/pWWQhCMU/RCFa6wIROUPw4FbuMP6lDXf4zCvfUcQlubJO5HAHqSNY+L6A2YwuU7C4IGZ/Zi+2xlr
	zY+zHaUqXlC0Rp1ozfODJ5dg4Avx2CqnNlW7kVKq3xxVxA3K9soCdkxFlfmFt5ag==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wHeio-0000000HLwg-0dHA;
	Tue, 28 Apr 2026 11:27:14 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 03/14] wifi: mac80211: carry element parsing frame type/from_ap
Date: Tue, 28 Apr 2026 11:25:31 +0200
Message-ID: <20260428112708.e8e6479f6765.I4a56ad20d40bdbbaa72531208e092eb4fbf6b4d6@changeid>
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

Carry the frame type and from_ap indication in the parse
result, the caller should have it, but we often pass the
resulting data structure around, so this saves passing
more parameters.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 2 ++
 net/mac80211/parse.c       | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e23e347f870d..10bad5369e9d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1790,6 +1790,8 @@ struct ieee802_11_elems {
 	const u8 *ie_start;
 	size_t total_len;
 	u32 crc;
+	u8 frame_type;
+	bool from_ap;
 
 	/* pointers to IEs */
 	const struct ieee80211_tdls_lnkie *lnk_id;
diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index 2b3632c6008a..5e61457be0f3 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -1053,6 +1053,9 @@ ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params)
 	if (!elems_parse)
 		return NULL;
 
+	elems_parse->elems.frame_type = params->type;
+	elems_parse->elems.from_ap = params->from_ap;
+
 	elems_parse->scratch_len = scratch_len;
 	elems_parse->scratch_pos = elems_parse->scratch;
 
-- 
2.53.0

