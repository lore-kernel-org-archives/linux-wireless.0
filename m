Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806054EA374
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534083; cv=none; b=cEex7V0ZKXkvm5hPj0KsE+aovajDc3U6UWoeWE9IY8KR0csQsZtrVW4mzFI7hgyfoLTP4PmGNJfJWUrvU9rt1Xlq1Hp30Kq76bEwFOUNW0RctZJ2jlC71+Y1/UjPs+jN3KU2238JznhQcfKBcz/WAeFwo6ZPe0zoaZKbebExACo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534083; c=relaxed/simple;
	bh=z5tSQZBh50miN+NuQ8TzlOnbKxJVfjThOpmHqWJ6VjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdFaRuNPVri79g3Djw4oL/pqAZFGxm2diSEpVJ0fmZw08J+8xOwN6IMFD+SiZIZR7pMs+Dp/xsLiN3revpWNoYkGsN1wypJF2mdy0qoUBoODGk7TAonYUSCGSTSRRpDns33BTmRRaQxK0TIGr2fEJ7+9a5GOC4NjXOfzhxIC/+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=lWzevDrw; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="lWzevDrw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=XF9BN5pj1uW09Ggjz5cFKMM2tX66q8fAwdvuimAGMMY=;
	t=1788534079; x=1789743679; b=lWzevDrwyNjTFqiR9r2gPsfE8cn8SJtDfglhv6pnTvQhgmX
	tIx2MZbEHxllfnOOp6/eu3LIZB9kNcp5sy86nEz8Tu2YulWKSf4Wnpouv4sCMgd56hlsccKyTN2FE
	z26wSqu0CgE3JNZpy9sxBaWdfBl5iOgE9RdEXiWiYxipt0DiQuc/DUBXdCfgnsaMfq0hdP9BAALeS
	0nIOhYgie3eUD2ysQyjkpyi+roao7QncumGIPxkoh1oL9+XzYSVTQA2I5NgOb4gtuFr43QKQL1KYi
	CpJuwmwHB+zo3WcDvCIlI5EsvX1nZMmXvg8AsKzPtKlGMDOw121Ph3Bz23vVJcSQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VPn-00000001SeL-2Z1o;
	Fri, 04 Sep 2026 17:01:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+1c8c45017f784e646b47@syzkaller.appspotmail.com
Subject: [PATCH wireless 06/10] wifi: mac80211: don't access the TSF of a down interface
Date: Fri,  4 Sep 2026 16:58:05 +0200
Message-ID: <20260904170057.6de1230f9a7b.I7115b209d73732ac2a9916fe19ffee6b1d9abc2f@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904150057.424369-12-johannes@sipsolutions.net>
References: <20260904150057.424369-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The tsf debugfs files call the driver even if the interface
isn't up, tgriggering check-sdata-in-driver warnings.

Reject the access in that case.

Assisted-by: LLM
Fixes: 37a41b4affa3 ("mac80211: add ieee80211_vif param to tsf functions")
Reported-by: syzbot+1c8c45017f784e646b47@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1c8c45017f784e646b47
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_netdev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 8346d3eb1143..6aba22493670 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -657,6 +657,9 @@ static ssize_t ieee80211_if_fmt_tsf(
 	struct ieee80211_local *local = sdata->local;
 	u64 tsf;
 
+	if (!ieee80211_sdata_running((struct ieee80211_sub_if_data *)sdata))
+		return -ENETDOWN;
+
 	tsf = drv_get_tsf(local, (struct ieee80211_sub_if_data *)sdata);
 
 	return scnprintf(buf, buflen, "0x%016llx\n", (unsigned long long) tsf);
@@ -670,6 +673,9 @@ static ssize_t ieee80211_if_parse_tsf(
 	int ret;
 	int tsf_is_delta = 0;
 
+	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
+
 	if (strncmp(buf, "reset", 5) == 0) {
 		if (local->ops->reset_tsf) {
 			drv_reset_tsf(local, sdata);
-- 
2.55.0

