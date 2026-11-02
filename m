Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657901;
	b=a+10WeomZrSKZi5JmSntiB19asdJD3U9LFUeQKGmq3FK7uhqJrhuDS0qucINF7QEly6Q
	 nRlMVsuFeOTzY7RoQD2Jd1FhZqjZkiu1gddRS1KZvuwxNurE1+J5DEAVNYH25EdVPnTfw
	 gbLU2FiUeZ9tIamBDF+5Ejdh+pBQXA1JjegLEjyK6JBSgbY21V1/FAQY8ngjth8guVJg3
	 xOp7V6sXiaf4F9+gAPjO8iHT7BlOlVP0w+sGLjpTULNpnYWZaDxpB0XbNmyRqqDAkBAVT
	 b5zIXr5k+2dy6+sU7gTiCrZh4gkW2tEqZFIiaoqKDr0e1uNExABEYvit6XHU82mZHag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657901;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Gtdps9qBgO2+zUed6GPyVpGa3sG2vhz0ptd7SAiiQDs=;
	b=mzbc5JxiONxaf5BCja6bkBVQgYZe8dVlKHXHHWqGOqAt4TrIpNsI/iojEOh5jiFxJOcc
	 Biv48+82cFdfeowo0o9Tmg/NBrgj7jsFgTgjuc262/pwrCW0yiNzApw2DBUYuwyQ5SiE6
	 8BVYaIasPOCgm7Uv0EggN//imUp7ZCcPWuLsbxuRqZwkr2GlURq/ZZnrG66U7gvJYELrN
	 b3CCWGufgRNFd8y4GMb07pd5pUfNdL8FhFff3peDOUCUl6gU0ANDEucpaOCluwluRp5Se
	 UeF70kzEuQ2p2lSANw7TpQ42NFOdx/sKRDy9W5oP60mNP95bMXvuMWl09wiyh/DajGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=yZgkYPJu;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AA0606A32C
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=yZgkYPJu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Gtdps9qBgO2+zUed6GPyVpGa3sG2vhz0ptd7SAiiQDs=;
	t=1793657900; x=1794867500; b=yZgkYPJux0MlkTWPNLMJ11xNXRv9KDVxYbCp7ovl0PNRvAp
	BljB8NCIYmo9L9QTn9OCZfkhHrah23/atrjUC2eXRVNrAI9FtZfA+np16xU0qtRlJJ6FPHwB/8gH2
	CohUHb4VOeE4GdFYYRSuqUaf6a3rrUsgKFO6hCv19+u7KeBGPMSSrAMa2GkRfug7PVMelFVBw2pdn
	C5zYOsASjQAzceNt6w29HSYN9BTxB8gSBZcj2W6MuYxwimIIHBYTuFhnYAbg5jIe8HXAtRYiyudqH
	UJlfZJGC6AJEQsklmq9eUdTKTmGP9COoI2+mbyAdA6qtThe7U6TlEFQdPF9yCzMQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0M6-000000023YI-2o0u;
	Mon, 02 Nov 2026 23:18:18 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 1/2] wifi: mac80211: debugfs: show TX BA size in agg_status
Date: Mon,  2 Nov 2026 23:16:53 +0100
Message-ID: <20261102231815.b97f642d3164.Ie25a6d9f4799493ba6a83f563b85888353a58f66@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102221815.1131181-4-johannes@sipsolutions.net>
References: <20261102221815.1131181-4-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

For testing that a TX BA session has the expected buffer
size (specifically for SMD Transition), show it in debugfs.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 690c186e3bb9..2c81efdf3d89 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -314,7 +314,7 @@ static ssize_t sta_agg_status_do_read(struct wiphy *wiphy, struct file *file,
 	p += scnprintf(p, bufsz + buf - p, "next dialog_token: %#02x\n",
 			sta->ampdu_mlme.dialog_token_allocator + 1);
 	p += scnprintf(p, bufsz + buf - p,
-		       "TID\t\tRX\tDTKN\tSSN\t\tTX\tDTKN\tpending\n");
+		       "TID\t\tRX\tDTKN\tSSN\t\tTX\tDTKN\tpending\tbuf_size\n");
 
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
 		bool tid_rx_valid;
@@ -337,6 +337,8 @@ static ssize_t sta_agg_status_do_read(struct wiphy *wiphy, struct file *file,
 				tid_tx ? tid_tx->dialog_token : 0);
 		p += scnprintf(p, bufsz + buf - p, "\t%03d",
 				tid_tx ? skb_queue_len(&tid_tx->pending) : 0);
+		p += scnprintf(p, bufsz + buf - p, "\t%d",
+				tid_tx ? tid_tx->buf_size : 0);
 		p += scnprintf(p, bufsz + buf - p, "\n");
 	}
 
@@ -348,7 +350,7 @@ static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 {
 	struct sta_info *sta = file->private_data;
 	struct wiphy *wiphy = sta->local->hw.wiphy;
-	size_t bufsz = 71 + IEEE80211_NUM_TIDS * 40;
+	size_t bufsz = 80 + IEEE80211_NUM_TIDS * 45;
 	char *buf = kmalloc(bufsz, GFP_KERNEL);
 	ssize_t ret;
 
-- 
2.56.0

