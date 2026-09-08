Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F31753A8BE
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 12:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870533; cv=none; b=IsiRyJQngvhLbLk3YbvLO/uOxgBjfv7K53fx6vPlZWrpMIsADdcQi3RjlMeqtvH8mu7Roo/Ai1bZyLfZTKVhIRBFRxIr2g4CRGleGrtSWF+rigF4lW5gvXlM+jYBAE5/Eh/9ZeQgoAHW3NIkj5bTNVWUx9/nE9nUEfX89atFw4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870533; c=relaxed/simple;
	bh=pBgs8rvCDzX3sqJ8Aw+WM85CtyaiuCvOB4yM7KY3rQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cO8JZP8xfSApoQf+QIvekTcdEhjyDme6W/rU+08UwUmK5I+N15p+KqS68DdnUes/5n+YPGF47WFQbw+w84wBR9dlu4tvNp6m/YgpP10MloQrJjYWkCWW9AuXyn/LK+S8c5d2zhyscgAfdYzJMQpW6rcMaM4uXvPGaL4K+otI1Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=drRJLrUF; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="drRJLrUF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=5qmtmYbyvBNlDxgFlQw+0PoKg0bH3vBGOJPsj3F7Y1Y=;
	t=1788870531; x=1790080131; b=drRJLrUFmWei9//FRPjdDVaIiN3pdojGvjFMCv5tmc+6kDG
	GdRZTp7ZNepMDcuQNniSh3UHEeX2fqnhSagbG+xAQFaDJxs6H597iPjbOo8uMEOc0Yt3qWujbUNBH
	XONiGw2kh9KjpvG9Fsw28hMkpxu4MLaVj8EAI1/tlbx+lth/dil4JPOV4ZGfk1F9hNY+xJZ8leMXO
	wwjWykPw5clYwjKbZI4rsN3p3Fj+79YmyUWF1sisPbHoypGzMnvabGR7YxwBe/UGiDLXmvDARvlLF
	1/6Kx11QAEVkMy9ZekDFbzbl1CRSyqPvlnYUfyo2wiC20yn5Dx/KUzMasEH7dL/w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3uwS-0000000670J-3YCt;
	Tue, 08 Sep 2026 14:28:49 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+1c8c45017f784e646b47@syzkaller.appspotmail.com
Subject: [PATCH RESEND wireless 06/10] wifi: mac80211: don't access the TSF of a down interface
Date: Tue,  8 Sep 2026 14:28:17 +0200
Message-ID: <20260908122838.201719-18-johannes@sipsolutions.net>
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

The tsf debugfs files call the driver even if the interface
isn't up, tgriggering check-sdata-in-driver warnings.

Reject the access in that case.

Assisted-by: LLM
Fixes: 37a41b4affa3 ("mac80211: add ieee80211_vif param to tsf functions")
Reported-by: syzbot+1c8c45017f784e646b47@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1c8c45017f784e646b47
Link: https://patch.msgid.link/20260904170057.6de1230f9a7b.I7115b209d73732ac2a9916fe19ffee6b1d9abc2f@changeid
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

