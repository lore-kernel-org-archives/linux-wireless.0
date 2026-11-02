Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793663771;
	b=LfuQqEfqcEIK7dzvAao2izfdIVGNAG2npdNzOSw1Ptmkg6ra7mBc8yCP6NqW9asqHfcl
	 avvpI3dgFWnezH0ZvHwXi28gCPkCRe6n4vi6VCFFjt+gHMxWLMu3ugfDpP3NIMtZVqalJ
	 JWMBauDlXapxhV2R7etaesKQIC7DgRsRjeUoGcJqzo0XihOcxOL7ZbIi9QJdgnBOVLSue
	 ydqdObxhVjjCl038fJCgyTnzTngLDs1fuixFvaIHBENd8TJvm9wboNCUOC8ybx1NicsmJ
	 /9afe3NEAIgZR/MN/fphDOm/Nlhs7y8vLDLHJoOkiAR3mjrq8rEGfEVR1NDAi6ZIWGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793663771;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=P6AQXRy9sZCFTnTO/Kj0lfnqNrcf8c5+SmLYwHqo45A=;
	b=LJBvsQf8OZ/9q/B6ywMlA/yNce1aYC3dYT7xGiSVEBh77diADwKRrplVMlOTugncSdfl
	 PvVjujGv+dvH5JrM3FD7MrNLByVDF56OjoLmtCcriEFXo1I+uBwVmlrzipbRH2XVF5mVN
	 sWByfEHhrnwYIvDsve4hELmicOpSE3uj5rVv9Lho4PioB+AtpTbdeW9/7zmReQJhJypBf
	 5P1KrUgYAOt2trXmnR2bwEjhqD5AELIAG5Y8SIE+2q68A/gb0N0uE4B8lU6vbgDEvojo9
	 3CsfEsZniyS/pLtKTcgeUPhAtlqwMsagPVAJGvsJcmyr7OibKm8096oyYpOFRAdqyfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=FkSXasK1;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E875D606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 23:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=FkSXasK1
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=P6AQXRy9sZCFTnTO/Kj0lfnqNrcf8c5+SmLYwHqo45A=;
	t=1793663770; x=1794873370; b=FkSXasK1YcCOSWZ6FbwalJ2EidYSZd11FOwAGkHhMQcUd2R
	hXAa//XHe72Fk53+EdHMvyWqdmdkkjFBqoQOrGr/0YZI/4Lu6lRyJ96hWn14DCtMlrHBfx9enxtbO
	K17xIdwIYkBMp4e3k3oFi7W406QSm/XDlM1wB1s3FLvu7Xhn2eExQAr3Y4XmygxqygemvVxedAlQH
	g+EtXljwJBRl24GT33rFRtMBPBjAaVZQSP8zMdynpY5+q1DcXUHpzEiNpymAaRCNX35MmLOXP8niV
	tC2hEdoBemgVASQDZDs1xXzHQq04PBCTBnd8MS2Z3nxQOuGnJDXNoeY6q4mAM3Kw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO1sm-00000002AZf-18mb;
	Tue, 03 Nov 2026 00:56:08 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 3/7] wifi: mac80211: don't synchronize RCU on scan completion
Date: Tue,  3 Nov 2026 00:54:00 +0100
Message-ID: <20261102235603.1181883-12-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102235603.1181883-9-johannes@sipsolutions.net>
References: <20261102235603.1181883-9-johannes@sipsolutions.net>
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

Since cfg80211 now frees scan requests only after an RCU
grace period, avoid the synchronize_rcu() and avoid the
delay (under wiphy mutex) in this path.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 8a66d2e020f9..0ffd1324c786 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -509,8 +509,6 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	local->scanning = 0;
 	local->scan_chandef.chan = NULL;
 
-	synchronize_rcu();
-
 	if (scan_req != local->int_scan_req) {
 		local->scan_info.aborted = aborted;
 		cfg80211_scan_done(scan_req, &local->scan_info);
-- 
2.56.0

