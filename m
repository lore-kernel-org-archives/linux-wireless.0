Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2827347D933
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2026 12:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780490191; cv=none; b=hJVhucHLbVsngVJK7CklLVcUi0AWh1RG1gBacd9gcxQR+J1pIGd5hEBXfFnMAsJFKNlmJPycsynVYJ6f925VcxAfUaDxE7uhUmdiVekL2KEZF+vrDUqpnzzQL9cs0DB8lMkOoDRfiAl6nStKR8qqNViAMZE2lDw7RFSi+fu8CeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780490191; c=relaxed/simple;
	bh=QBtH6fUIReqErdu7wV6vyMYB40y6HKLBr0zbOxU+/fM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eTIc+vdh0xtBh0DlagxWMKjZKMCBD4l9KXaJkDZfLd2z3tR1kDiWclZRKZtGV0SgpYSf3z5MJUSST9NW+lfO1/Yg8u3xuaP3oB+SnUIYaqJHKT5xu+vx3SWe/XVX7xPGqvyh6JD9M/rBj495Si+q0FwYDSqDsZF54gA92y1SkwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=I2p2SLEm; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="I2p2SLEm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=VXNq8mYiLQZSLVxY+Ulawwo72Mxm9lg2zd9mT4enDkI=; t=1780490189; x=1781699789; 
	b=I2p2SLEmj+R69qg6s3M8zL0YLKAn21tSvvt0rXKrF6eCVi3guy1gKpwZYUXcT0rF1VVjpOuRpdM
	gfoVfBsGxVv3SV1SiCtWsj6zKUQ/ktODlajGkcFHplk88yeOhHYvEJRcWyTqDG1JR8405IGkGY9MH
	U4yfK+WKF1Bmgg48q6rpJq7ylbVvZLPMoL/ao+M5AN5ws7sJ+lVdCUStnen7tjGDZaBvSyQCxZvvL
	wuX3t6tP3lo+k1uTjvl7riAVgIlFlmfxPmrVzkmpoAu3F69KD57ZFdrzrFzFyOxtMwStOTJpS4ZwV
	fyVc7qv/JrAC8f4nw9sINnCa096F+O7DZnHg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wUkpe-0000000H7UU-1BzC;
	Wed, 03 Jun 2026 14:36:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: Free keys associated with NAN Device
Date: Wed,  3 Jun 2026 14:36:24 +0200
Message-ID: <20260603143624.c6c771885383.I929410cb8efec4fab2d42ead396bfefaf9f803f1@changeid>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

A NAN Device interface can have keys associated with it, e.g.,
IGTK and BIGTK used for Tx. When a NAN Device interface is stopped,
we need to clear these keys.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 56400c22d8bc..086272c3ec08 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -648,6 +648,12 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 
 			spin_unlock_bh(&sdata->u.nan.de.func_lock);
 		}
+
+		/*
+		 * Free the remaining keys that might be associated with the
+		 * NAN interface, e.g., IGTK and BIGTK used for Tx.
+		 */
+		ieee80211_free_keys(sdata, true);
 		break;
 	case NL80211_IFTYPE_NAN_DATA:
 		RCU_INIT_POINTER(sdata->u.nan_data.nmi, NULL);
-- 
2.53.0

