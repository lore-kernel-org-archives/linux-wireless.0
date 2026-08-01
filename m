Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96912343D85
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 07:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785571118; cv=none; b=pjxOHTom3eY8QRd1n1uFmoo5wmSdsR6SGmK0s+am+1kR0BuDjes/+1wvP2Lpg88lbWCsC4w5hI1F5xi7cHiIZlIUrcE9lAmaDpDTI8kdbiK88xjLa0hoJK9LAa9TWheYFVDSUp3VxcnxkkZJIoNgQSuIrpeeehOcoB4WELWFi10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785571118; c=relaxed/simple;
	bh=2fE5xk31Ydc8qHt9cJZsfqPoH+rlpc0G42g8pVm79PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPPtg4Zeksyxwp6DhLld6Fq2GG0oik8qlejIAqWj13xL8XYL2rOFbMCZsRS05a6YnRSsNrNDO4WYvc3d3/N4aH96Gu47HsQOCm1I6bo5ibsIMuUo44MwqUDSZ26VgYVMarBSdlXtoDy37u8YqOxniuBhDvzpmMPmaRHFWnijxsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=TunQxG5g; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="TunQxG5g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=a/JI9n9U4GIKD7hbIC5/PHGmfzI9OO1ueZlZUVUtmJU=;
	t=1785571116; x=1786780716; b=TunQxG5g/5NO3wxK8qnDzD6y9DIWqdgp+Uh/pauGujxLGgc
	QTp06q0t+uDCZkxL0Yb5Fzcs9XdikJc5dCgJTUS3lPoYUr5/Uvk59fANqqP6/c3FV6t3WEeSPdV5K
	CZs6SEhFyg8tN2Ptl6zPzyVfaTFwx/s3q2lDObpkdThgGhx7Lp+ic9CF47HVkeV1q3o+VuYIW78Cm
	pQRuLQtVcnAHSW+Ic1yunW71nNO5l+YmC1bTGJSy8YbGlhKk6PbHP2UfDJu2Njzo1K18HFhdoE2MI
	2briyTUoRYzvBcY+h4J8vWG9P5KJHMnqB/WcCdKzvjoKwrBhz42DEfnW9wvvefrg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wq4c0-0000000ErOv-0Do6;
	Sat, 01 Aug 2026 09:58:28 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 03/12] wifi: mac80211: add key flags to debugfs
Date: Sat,  1 Aug 2026 09:58:19 +0200
Message-ID: <20260801095822.253e12d17dc1.I3a7d6912def9ba2623b41cc672704cbe3beb0bf3@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260801075822.645974-14-johannes@sipsolutions.net>
References: <20260801075822.645974-14-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Since there are two sets of key flags, one for the driver
and one internal to mac80211, add the first set in debugfs
as well. This will be used by hwsim tests to determine if
a key is pairwise or not, since the next changes will make
mac80211 use only per-STA GTKs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_key.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 117f58af5ff9..79ae3552c55b 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2006	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright (C) 2015	Intel Deutschland GmbH
- * Copyright (C) 2021-2023   Intel Corporation
+ * Copyright (C) 2021-2023, 2026 Intel Corporation
  */
 
 #include <linux/kobject.h>
@@ -42,9 +42,10 @@ static const struct debugfs_short_fops key_ ##name## _ops = {		\
 		 KEY_READ_##format(name)				\
 		 KEY_OPS(name)
 
-#define KEY_CONF_READ(name, format_string)				\
-	KEY_READ(conf_##name, conf.name, format_string)
-#define KEY_CONF_READ_D(name) KEY_CONF_READ(name, "%d\n")
+#define KEY_CONF_READ(name, val, format_string)				\
+	KEY_READ(conf_##name, conf.val, format_string)
+#define KEY_CONF_READ_D(name, val) KEY_CONF_READ(name, val, "%d\n")
+#define KEY_CONF_READ_X(name, val) KEY_CONF_READ(name, val, "0x%x\n")
 
 #define KEY_CONF_OPS(name)						\
 static const struct debugfs_short_fops key_ ##name## _ops = {		\
@@ -53,12 +54,16 @@ static const struct debugfs_short_fops key_ ##name## _ops = {		\
 }
 
 #define KEY_CONF_FILE(name, format)					\
-		 KEY_CONF_READ_##format(name)				\
+		 KEY_CONF_READ_##format(name, name)			\
+		 KEY_CONF_OPS(name)
+#define KEY_CONF_FILE_NAMED(name, val, format)				\
+		 KEY_CONF_READ_##format(name, val)			\
 		 KEY_CONF_OPS(name)
 
 KEY_CONF_FILE(keylen, D);
 KEY_CONF_FILE(keyidx, D);
 KEY_CONF_FILE(hw_key_idx, D);
+KEY_CONF_FILE_NAMED(conf_flags, flags, X);
 KEY_FILE(flags, X);
 KEY_READ(ifindex, sdata->name, "%s\n");
 KEY_OPS(ifindex);
@@ -356,6 +361,7 @@ void ieee80211_debugfs_key_add(struct ieee80211_key *key)
 	DEBUGFS_ADD(mic_failures);
 	DEBUGFS_ADD(key);
 	DEBUGFS_ADD(ifindex);
+	DEBUGFS_ADD(conf_flags);
 };
 
 void ieee80211_debugfs_key_remove(struct ieee80211_key *key)
-- 
2.55.0

