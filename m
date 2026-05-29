Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318DC3A8723
	for <linux-wireless@vger.kernel.org>; Fri, 29 May 2026 08:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780043213; cv=none; b=PVa1Ohpt+LClZxypiouaip6AmbyV/NXKTpX1bD2bIpeE2KCqUAb9C+8vaJHN585LFm7jSCUR+jR9637yPJWAkUB0Am8igcdiugkIK9BrEbiF7sW7CeJ1DSH9oeNs7lpNYzZX7LvIByqy5HMjIKoFL4W3LLvIARAYFmtBkDCBiMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780043213; c=relaxed/simple;
	bh=6ReVxq/J6FIy1ygGDlCKc9llwtb+RVnyMvGHYtWBa3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oxc/MrMP44t53voQ3jPbY61qZlCAGa3q+GJG8qYum09yXFDGrqhGlTvzhizPO+6uHd5YOH+1Xwh/kNZm9GUDNXSU5RsWNbIBWc2jvGVUKKrRpcEUAsAI2yxdVrWaYaWCCGEbOkX5WQt1ztxDRUBiT5/p4vZ3LuwxTAEEnTvbmYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=EXeDRssx; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="EXeDRssx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=uxWzorhgTEi/7mW65GtVZMQemWBCCoo5Qt5MYhFzp4Q=;
	t=1780043212; x=1781252812; b=EXeDRssxVMEl/GM0o/tk1ZdW4nBg/qtCfvBXiwscNEjKFUn
	DsvrFSY6c2NvjA6QxEP+u6/x3wNo570i9ERYJUTxLCiCcYxppmuIKA4VS5Peg6yRgA+wvmTaK9SlM
	UvhUDysfmNO7ua3XdEqRSsldn2FE1sDd9zKO+jkuk+XlzOOw27Az808VImhFils8p3WZZsxgBJX9D
	xWirGDqtrgM5syElHNE+brNKsfUqfQ5zUgkliVJsyx5+JPCKduXgGLOqYNn2x8aSk92ZKMl5Jq/rX
	gL8KojOpNBAg5CER65tkBPLUu2kRPgldE80eVGZN7l2GlDYoSdjUSs+MnUEYneng==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wSsYL-00000009bVp-46b3;
	Fri, 29 May 2026 10:26:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 03/16] wifi: mac80211: clean up return in ieee802_11_find_bssid_profile()
Date: Fri, 29 May 2026 10:24:56 +0200
Message-ID: <20260529102644.46f25609ddef.I9e651a0018e66953f4fb508f784188e00351c07f@changeid>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529082644.106145-18-johannes@sipsolutions.net>
References: <20260529082644.106145-18-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

There's no need to define 'profile_len' at the outer scope
and initialize it, move it where needed and just return 0
if nothing can be found.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index 8b30e361b622..22365c507b99 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -813,10 +813,9 @@ static size_t ieee802_11_find_bssid_profile(const u8 *start, size_t len,
 					    u8 *nontransmitted_profile)
 {
 	const struct element *elem, *sub;
-	size_t profile_len = 0;
 
 	if (!bss || !bss->transmitted_bss)
-		return profile_len;
+		return 0;
 
 	for_each_element_id(elem, WLAN_EID_MULTIPLE_BSSID, start, len) {
 		if (elem->datalen < 2)
@@ -826,6 +825,7 @@ static size_t ieee802_11_find_bssid_profile(const u8 *start, size_t len,
 
 		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
 			u8 new_bssid[ETH_ALEN];
+			size_t profile_len;
 			const u8 *index;
 
 			if (sub->id != 0 || sub->datalen < 4) {
-- 
2.53.0

