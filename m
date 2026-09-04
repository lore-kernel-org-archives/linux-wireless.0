Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998134CB8BB
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533853; cv=none; b=iiB4JYA+zr6KLr2pi9lAgumCi5uGqDUtkb2lZrB+yGyriyUqEJzj4EpoAQIVJaS/JrmRE3SSoGM4v6Z09f/2lu2g+IKPgJLc/yIJiXzxDfoVxgU5GfWSDwS/OPtqP3DZGgu+TXTarLWF3uGZeiETSitQKapSZxHA4McPxCPfIL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533853; c=relaxed/simple;
	bh=Rc1rWj7Say4Fl08RAwL23bs4wH96QKpjFHTUm9fSr8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mfx8TQ+c5n8+UxA2X685aCEFJYLtHt6JNONwWP6QqiCsBwGszDTVtVY1z6jCtgrZBSqpasMpRjvBQRuKXcWpePCo5f9hADIRtJ4WpNlLbdEz3rd6uMxdyg3XYUg60vQ7slF+d+sBpO8bJVCxEEWxEJnYQp1cC/6Whn5ANEsKkXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=v4TyvEI4; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="v4TyvEI4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=w/uLkV8neSxYWGxvwnP/1YmIF64Jp2mykcCySxyZ8Yg=;
	t=1788533851; x=1789743451; b=v4TyvEI4fgH9P4+fQw0wtN110tweQGIrpqhCWgZkpN34cel
	nZwUL5N+OBSM5/s188ScwlwsMqishb+/QpxwBh4tC8cienvzj/7mgg50O4aXRsze0Eha37PxZHkFC
	mvcGVBImElw0Tu4FtkaUZX/72QjgtllmnsCWG8cbvOCtHw8xE1fK4bSEjIbg2cFhS5G8JOMZvvaQL
	IBVEeR2+uCPOzEuDv+NDuOiXJ7XwnBEtpMJqiKOX/yDsmtPEVYJuUJ547D5wtmiNHG3/pzKepaIFp
	ZcBY62YXThkXFq3B1wQR8srskumIpB3adg2+fxHMgtVy1p7ALqBf3l4RBIMyq3zg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VM7-00000001SWk-3HET;
	Fri, 04 Sep 2026 16:57:28 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+c3a167b5615df4ccd7fb@syzkaller.appspotmail.com
Subject: [PATCH wireless 03/10] wifi: mac80211: don't start a ROC while scanning
Date: Fri,  4 Sep 2026 16:57:07 +0200
Message-ID: <20260904165722.f9d5b150edd8.I61bc9de8c8d089096ad695213b9c85c7df38c3bd@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145722.424159-12-johannes@sipsolutions.net>
References: <20260904145722.424159-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The ROC work can be pending when a scan starts (which requires
ROC list to be empty, but that's possible), and then a new ROC
can be added to the list and the work will pick it up.

Avoid starting that ROC if a scan made it between things, as
otherwise we'll hit a warning later:

  WARNING: net/mac80211/offchannel.c:404 at ieee80211_start_next_roc+0x256/0x2d0
  Workqueue: events_unbound cfg80211_wiphy_work
  Call Trace:
   __ieee80211_scan_completed+0x4fd/0xe40 net/mac80211/scan.c:537
   ieee80211_scan_work+0x472/0x1ff0 net/mac80211/scan.c:1193
   cfg80211_wiphy_work+0x410/0x570 net/wireless/core.c:513

Assisted-by: LLM
Fixes: aaa016ccd5df ("mac80211: rewrite remain-on-channel logic")
Reported-by: syzbot+c3a167b5615df4ccd7fb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c3a167b5615df4ccd7fb
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/offchannel.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 7acef80d5f1f..e30767853c36 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -460,6 +460,13 @@ static void __ieee80211_roc_work(struct ieee80211_local *local)
 		return;
 
 	if (!roc->started) {
+		/*
+		 * The work can be started by a previous ROC work, but a scan
+		 * can get between things; scan finish will retrigger us.
+		 */
+		if (local->scanning)
+			return;
+
 		WARN_ON(!local->emulate_chanctx);
 		_ieee80211_start_next_roc(local);
 	} else {
-- 
2.55.0

