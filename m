Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657902;
	b=FclrkrFM0qN1JhlR2p7rv1x+WXQGUY9hEYnfWRjj+foSKa+aabVHm03i21uXkYbmfm8l
	 P5OVtw1aSRpZNquIJdkY90m+iCyz0W5HhIoFyFy3kJ0QBeHEfNFJFs+jewvqvmr5veCzV
	 ekzEF7a45A1DdTTrvJAUda7dZrASlt/KU+a+JMBSbh2zWEjcn0mxS1eghQ9197G6vrYlZ
	 WsQnQT7vbtHKL7iIB32i+ZerrodCaYJsaImGxP1JjHR2Z8603406LhaLRHMMOJGhgjTiA
	 no717pNSZZJKiS8Cj1iSv3jxzyuLJMY1+xMSAF9bz8GAFL0lZi+Eb8Cwv2lVMgjSUUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657902;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/FZbFTCfpcPj0az3lgu3HByEXIkPhPy6tOoxxvdp+F8=;
	b=OnmmiHhesqDLmMjgAc5oLgx4AzE8vp0rFiyPQyKLJilY7ysgAEOhf75FvUGL9FEFSwuP
	 TaWlmaHBD4VmjlILJqdPqZNI1qy41/wt2luemv3K3XJlI0lld6thltyP3mlwKLZCTiaNo
	 7QQk7UbrHGAWfH4r5uH8Tqs+YpDp/bKI/87xrWfmnX2WZxZliI90d/22Jp901nqqxXNGS
	 W1ve87xxtvCKWe3uDT9w5deUt53F5+7J8ORlS4M64KWxdULaCK1CWT7sirGKdV6n8mI0e
	 /WT4Fqc+lmRP6RXswwIpi1PX0kH1xleBn5QAgUqN5zG8jueG+e50H2oEcBuXj6sShkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=qnIdlmI6;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326D2606A330
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=qnIdlmI6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=/FZbFTCfpcPj0az3lgu3HByEXIkPhPy6tOoxxvdp+F8=;
	t=1793657901; x=1794867501; b=qnIdlmI6/zAYofiqjXQZXnGr/ZexqeeFjcQ59TaikXFcsEB
	n+Jo/OF95xYFhcKFaoR/aHiKH1S5Yn4V77HDagCr3Jq9gjGPPkgurgAP8eXfLefP3bgMPSlkTjPie
	eSZkmpP13zYCra5K2+21cAOh6NIUBQ3GouPkwM8TWAHTfAHK3fLlNcMmJbWxOHGih+8wfv9RIzUF4
	TBTrFCn9PIZJTaG+i/JjGdvDN87SAiW7JT1wTgZ8/dqu4JpRrBMEB1Aeb3d50/yq3E6bAeVD4RKSm
	5Z9G3z/aurekN9acI4D83MXhfdUc8mPJKqW2PRIQfVfNRMCtFsLVfGjaTeCngbqQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0M7-000000023YI-1MrL;
	Mon, 02 Nov 2026 23:18:19 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 2/2] wifi: mac80211: debugfs: allow sending blockack request
Date: Mon,  2 Nov 2026 23:16:54 +0100
Message-ID: <20261102231815.1019090c2799.Ifd1d86c0bfb2f1162a92f7ab601da5428e0d59f9@changeid>
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

In order to test block ack handling, in particular the size
of the blockack bitmap it'll respond with, add a way to send
blockack request. If this is done on a device that assigns
SNs by itself, this might all get mixed up, so it's mostly
useful only in very constrained test scenarios.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 2c81efdf3d89..8d6b4a1bb8d6 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -368,8 +368,8 @@ static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 static ssize_t sta_agg_status_do_write(struct wiphy *wiphy, struct file *file,
 				       char *buf, size_t count, void *data)
 {
+	bool start = false, tx, bar = false;
 	struct sta_info *sta = data;
-	bool start, tx;
 	unsigned long tid;
 	char *pos = buf;
 	int ret, timeout = 5000;
@@ -394,6 +394,10 @@ static ssize_t sta_agg_status_do_write(struct wiphy *wiphy, struct file *file,
 			return -EINVAL;
 	} else if (!strcmp(buf, "stop")) {
 		start = false;
+	} else if (!strcmp(buf, "bar")) {
+		if (!tx)
+			return -EINVAL;
+		bar = true;
 	} else {
 		return -EINVAL;
 	}
@@ -411,6 +415,24 @@ static ssize_t sta_agg_status_do_write(struct wiphy *wiphy, struct file *file,
 	if (ret || tid >= IEEE80211_NUM_TIDS)
 		return -EINVAL;
 
+	if (bar) {
+		unsigned long ssn;
+
+		buf = strsep(&pos, " ");
+		if (buf) {
+			ret = kstrtoul(buf, 0, &ssn);
+			if (ret || ssn > IEEE80211_MAX_SN)
+				return -EINVAL;
+			ssn = IEEE80211_SN_TO_SEQ(ssn);
+		} else {
+			/* only correct if the driver uses mac80211's SNs */
+			ssn = sta->tid_seq[tid];
+		}
+
+		ieee80211_send_bar(&sta->sdata->vif, sta->sta.addr, tid, ssn);
+		return count;
+	}
+
 	if (tx) {
 		if (start)
 			ret = ieee80211_start_tx_ba_session(&sta->sta, tid,
-- 
2.56.0

