Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6054FC320
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897122; cv=none; b=sLTYopChB3rxyvaiGogk9cqtRgzY/jvhuqABCjsaiJPq1yBkLEf/pMu+1xB2Ft3JL6x/vaww4aYGvmNoKI0U24URidGXpJPOypqETFZFqo/IN3AW1pJw1Mg8TUA21qRnLTlhcBmwLb/xiEFzEwilZ9n5UVQQcQmIel6VQ7stQ94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897122; c=relaxed/simple;
	bh=hlOuNR5YuVRtssNZJGcWXxjUCL/3vEAC8aZY10Fl0Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r6C5MRi87l2oYOS4MEMzJ3OBIghhes62HXL57y9jVPxKY185djKe+jXHbqHABzcD4aKPBLM24kj3ozX9JPr0XYi75FNn186XgIQGodmQq/7WhABmMn0YAF2JPH+/rpevp+C7MXKC4M5a7yBmFoDxiB39Bmavr6thNNQHGYBvSVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=pbcN94SG; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="pbcN94SG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=B5kSuNUuA4RNnY4u5LikqMBE6W1QL85xVWQmiMEWq4s=; t=1791897120; x=1793106720; 
	b=pbcN94SG84shGDk/GUmR4qdmLjmVehFP4T0JeJQPlQF9cOGvqsWw5rrk67MzNB2BPrRgnyVanW2
	Z14aT43sb0kJQXwvPbRmbaslPX725w6Naxa5aRJW+aKa0bHWXkDgrn+AkO6SIdknqGliugryaeI9l
	YBB/hGhqslGrgWdy8g2XkzUfIauUbclW9kvLBsN30epM7Rca4OizqPZMorKWdtpJZh5E6H1Fb781n
	x4kpif7SbaTJ5ff2rmAk7GwfC9sOwUxu8L86UQ7HCMyLf4vEwrTeAdiF/GP6au+yhzaUNQYJZLzhm
	G/Pn5AFG8uDQiQajH2KcUiUzRa5KCW4TXq/w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcIP-0000000HPms-164o;
	Tue, 13 Oct 2026 15:11:57 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wifi: mac80211: expose link STA TX bandwidth in debugfs
Date: Tue, 13 Oct 2026 15:11:54 +0200
Message-ID: <20261013151154.62793c5224e5.I3b999eb6282d036bf2797fe1ef5898ee3a8f1241@changeid>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This will be useful to test the correct sequencing of
RX (channel context) vs. TX (STA bandwidth) changes,
e.g. during DBE enable/disable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index ef75255d47d5..690c186e3bb9 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -5,7 +5,7 @@
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright(c) 2016 Intel Deutschland GmbH
- * Copyright (C) 2018 - 2023 Intel Corporation
+ * Copyright (C) 2018 - 2023, 2026 Intel Corporation
  */
 
 #include <linux/debugfs.h>
@@ -1221,6 +1221,21 @@ static ssize_t link_sta_eht_capa_read(struct file *file, char __user *userbuf,
 }
 LINK_STA_OPS(eht_capa);
 
+static ssize_t link_sta_tx_bandwidth_read(struct file *file,
+					  char __user *userbuf,
+					  size_t count, loff_t *ppos)
+{
+	struct link_sta_info *link_sta = file->private_data;
+	char buf[4];
+	int len;
+
+	len = scnprintf(buf, sizeof(buf), "%d\n",
+			link_sta->pub->bandwidth);
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, len);
+}
+LINK_STA_OPS(tx_bandwidth);
+
 #define DEBUGFS_ADD(name) \
 	debugfs_create_file(#name, 0400, \
 		sta->debugfs_dir, sta, &sta_ ##name## _ops)
@@ -1315,6 +1330,7 @@ void ieee80211_link_sta_debugfs_add(struct link_sta_info *link_sta)
 	DEBUGFS_ADD(vht_capa);
 	DEBUGFS_ADD(he_capa);
 	DEBUGFS_ADD(eht_capa);
+	DEBUGFS_ADD(tx_bandwidth);
 
 	DEBUGFS_ADD_COUNTER(rx_duplicates, rx_stats.num_duplicates);
 	DEBUGFS_ADD_COUNTER(rx_fragments, rx_stats.fragments);
-- 
2.56.0

