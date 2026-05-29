Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C353ACA5C
	for <linux-wireless@vger.kernel.org>; Fri, 29 May 2026 08:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780043220; cv=none; b=ioTMqdWtvokBuKH1y2DTYak7/UHnH+uB/yAaKuDtF7bTQrJRLnVyX7nFv8LepcIw2rSnPqo6PlGKleyLhYCRcF59HupOPRe0yVf9V/4tW+hpMuLh3FW4D3SuPCFJROdN6jSKxBIM7+NSrc+C0kCgzqYkYWV7OpdMHGd2D1KZ0T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780043220; c=relaxed/simple;
	bh=InKeQc8AkqEg2507Igm8cfHLS2gYp4yaJzGDiDrK5e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1IQ9M/JOvs07DPfAEg0w0IcbxLr38NXMkai5ra0AN/WfWEujOhNnWK8qO44r14WYQrMxr+Rx/6yRWYBX0Yq8YVr4d7xsLTyKrppsQyAb5Y8vc1R1NS/+vj1MbceiNdvsB0jlZufWmRX+lVBH4ofGpwXPnB22SKvon4PMdRqW70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=jjsXl49O; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="jjsXl49O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=LU8R9PcTZ7OkKfQR+CQ7T6W591W4+9AfFx4E2Rt7QVI=;
	t=1780043219; x=1781252819; b=jjsXl49OQ43mWY/TygNXCSr23E/cCK2J8f8wDkblpGgqql3
	ydAAhQZaL8E1OMxyeztH43qm2YflDylKGM7epITyL+0/Rw6co3PWPjioNUQrKcpepe9V8d+lVxfng
	58+DIYewhqCAsOa5UzDRR9UhbnS6UAVfJiPowSO2sw5XHkrT/CwAcdCG6VX5SDFJkxZgTqelOlewx
	PyRe8O1i1uHXXLOUeBgJqaC463YdNyeeTqnoI1I/XGqA1ryW8qYiKiQXThCwDoCq10BEtirAIexpU
	Ys95zMGCuK5tGtUAWtz8+rqCb0AqzWkkF+1A7cCZvD3Hqa/SRN2UHFcIBvMF4QuQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wSsYR-00000009bVp-40y9;
	Fri, 29 May 2026 10:26:56 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 10/16] wifi: mac80211: explain ieee80211_determine_chan_mode() parsing
Date: Fri, 29 May 2026 10:25:03 +0200
Message-ID: <20260529102644.25f75c4df338.I1f1f17cc0ae8e413659654d4bbaa34260ef68e2c@changeid>
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

Looking through element parsing behaviour for multi-BSSID
and multi-link, this one seemed odd. Add a comment that
explains why it's written this way.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 949ea018079a..2b0be473c82c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1077,6 +1077,14 @@ ieee80211_determine_chan_mode(struct ieee80211_sub_if_data *sdata,
 	const struct cfg80211_bss_ies *ies = rcu_dereference(cbss->ies);
 	struct ieee80211_bss *bss = (void *)cbss->priv;
 	struct ieee80211_channel *channel = cbss->channel;
+	/*
+	 * This is for parsing a beacon or probe response here, but it's
+	 * using the *BSS* elements which are synthetic for multi-BSSID,
+	 * created by cfg80211 based on multi-BSSID inheritance etc. As
+	 * a result, this sets neither .bss (since multi-BSSID is parsed
+	 * already) nor a valid .link_id (since it doesn't want to see
+	 * the data from another link.)
+	 */
 	struct ieee80211_elems_parse_params parse_params = {
 		.link_id = -1,
 		.from_ap = true,
-- 
2.53.0

