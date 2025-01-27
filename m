Received: from ns2.wdyn.eu (ns2.wdyn.eu [5.252.227.236])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ADC915CD74
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jan 2025 16:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.252.227.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737995872; cv=none; b=kFSHdzUMdHnGZvsRg2mrT8+VJwTLCOEjf4Ew62l2qcfSusmmuWQ75pZmd3ApJpZTLpRv/keSRy0NRg/aJcud5mpcLWX28qHR1XhmS/LbQtVW+jO3z+qp+U8AoDM5YGPYP+RPP4Edo0cfPlClTwc6FuFVLLrcyRYqv5CWIh2TK1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737995872; c=relaxed/simple;
	bh=Sq+njo8vH8dl0o1OvSJ7npHjqJoVsATGAu6h6Fh8u/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mA2rx7ysJi+hGarwmJzaXw3V4jl6TjhItPLPR4y1kAuoiyCeNZMR4Of/ZZsd7awPiAozD1zbTvnasery5rR3L2f0DhIkmW1bPGtAnEs04vyUNFVMtyNTkBiLjkDVbfEU12WLDM96gF9OtUpLx6kur2Sq4jBq4jlubwOZGYst0MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wetzel-home.de; spf=pass smtp.mailfrom=wetzel-home.de; dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b=TqrsVJRe; arc=none smtp.client-ip=5.252.227.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wetzel-home.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="TqrsVJRe"
From: Alexander Wetzel <Alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
	s=wetzel-home; t=1737995297;
	bh=Sq+njo8vH8dl0o1OvSJ7npHjqJoVsATGAu6h6Fh8u/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TqrsVJReE4favL+P2/lZP6WTD6F9KtkwXwwqAWucgrtFP3dY+h6hqxjmFjYsZ4hAn
	 lFnPmudMS0DvAC4ueOnVfBCU4c37U4Xd5JACE7grkhXyoTTB+QJkWCyQ0bIExUW/j8
	 WN1zcH169S1Ihtwl4AGyRb0p0UD2TYkXsEYbonyQ=
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Alexander Wetzel <Alexander@wetzel-home.de>
Subject: [RFC PATCH 03/13] wifi: mac80211: Cleanup sta TXQs on flush
Date: Mon, 27 Jan 2025 17:26:15 +0100
Message-ID: <20250127162625.20747-4-Alexander@wetzel-home.de>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250127162625.20747-1-Alexander@wetzel-home.de>
References: <20250127162625.20747-1-Alexander@wetzel-home.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop the sta TXQs on flush when the drivers is not supporting
flush.

ieee80211_set_disassoc() tries to clean up everything for the sta.
But it ignored queued frames in the sta TX queues when the driver
isn't supporting the flush driver ops.

Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
---
I tripped over while working on something else.. It looks like this
could cause issues with this patch series for drivers not supporting
flush. (But all drivers I tested this series with support flush.)
---
 net/mac80211/util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 86320ecf306c..4fdac50cda67 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -685,7 +685,7 @@ void __ieee80211_flush_queues(struct ieee80211_local *local,
 			      struct ieee80211_sub_if_data *sdata,
 			      unsigned int queues, bool drop)
 {
-	if (!local->ops->flush)
+	if (!local->ops->flush && !drop)
 		return;
 
 	/*
@@ -712,7 +712,8 @@ void __ieee80211_flush_queues(struct ieee80211_local *local,
 		}
 	}
 
-	drv_flush(local, sdata, queues, drop);
+	if (local->ops->flush)
+		drv_flush(local, sdata, queues, drop);
 
 	ieee80211_wake_queues_by_reason(&local->hw, queues,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH,
-- 
2.48.1

