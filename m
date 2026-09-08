Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC45F53446E
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 12:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870535; cv=none; b=VICa6uPv0PcA1Zs2yLPzMK/QlhLndgYLkuj1A63mzqNpcf34PfSloRDl7yx1R5xT2pwEo/N1Kisrhhk6AWStLH81sDgOt0rqtI+A3LpVvD+HQcJlk3ON1udNqHW1AFfCvdYj7UoRmD5tr5BBpjhL0vus4UT/O6gl/nW41ZnJ0wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870535; c=relaxed/simple;
	bh=ibHmlgyDM4dgejuaEKako1mst1B2WB7Y7Y77e/xr5qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIoqcTZRbAjHHtJx/cBUQTdRS0Wint/9xbqV8pj/dRr6J+/zjabVW8RsQM/y6AIjxi6zl9xFiDCat5Mqr/s0/Qd3417lZlx8MVB4F0iuDtJhtWq1y36EJNF9oDDSeLLcZ7raqj2SHQDmyUzGWmUir00rR5MBdbE9TEXXvqjaVLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=FOFjDg6M; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="FOFjDg6M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=OfwHXqdOnqNxYq4sElHrn+qgoIgzpX0VyELoE5yH+UA=;
	t=1788870533; x=1790080133; b=FOFjDg6MLkHnAz9fKvFg6X9TO9UdsQRhkgsfiqp1vgyCnyG
	sLoJIDwFQfvoisX5wPPE8magt783rywHa3NTrKTZDEo9ZHrKld3Gf/TfBj/xIKT6ppQejxN9JSmX5
	gKorSfYUGCntzst7kc4JVQ6968CwziIwK3IAdNoBz26PnoaizfRMK39eTWlG0bfsSyt14o7ie8KUH
	NBFQAWAswbTu6JttLL+W2wsft4UiK8J5nYyYxFN/Ukw2+3zHNm8DgkCca9TVY433kXvCE8w55eP0e
	LytC2XJMx9FaSfpfaSflw6TmVwVvebQ+2ysyUyabHQ+hunSrX3aRCGYPHUeWAySA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3uwV-0000000670J-0ARN;
	Tue, 08 Sep 2026 14:28:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+63a84ea9c0f57d6133fa@syzkaller.appspotmail.com
Subject: [PATCH RESEND wireless 09/10] wifi: mac80211: mesh: release the channel if start fails
Date: Tue,  8 Sep 2026 14:28:20 +0200
Message-ID: <20260908122838.201719-21-johannes@sipsolutions.net>
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

ieee80211_join_mesh() acquires a channel context and then calls
ieee80211_start_mesh(), which can fail. In that case, the chanctx
isn't released then interface removal will attempt to unassign it
after it's removed from the driver, hitting:

  wlan0: Failed check-sdata-in-driver check, flags: 0x0
  WARNING: net/mac80211/driver-ops.c:366 at drv_unassign_vif_chanctx
   ieee80211_assign_link_chanctx
   __ieee80211_link_release_channel
   ieee80211_link_release_channel
   ieee80211_teardown_sdata
   unregister_netdevice_many_notify
   _cfg80211_unregister_wdev
   ieee80211_remove_interfaces
   ieee80211_unregister_hw
   mac80211_hwsim_del_radio
   hwsim_exit_net

Correctly release the channel on start failures.

Assisted-by: LLM
Reported-by: syzbot+63a84ea9c0f57d6133fa@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=63a84ea9c0f57d6133fa
Fixes: 2b5e19677592 ("mac80211: cache mesh beacon")
Link: https://patch.msgid.link/20260904170057.8c86b0a8a44f.If6d6e31f93aca94e992ae17edc691407b146537c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2d5a0abe35db..d3558f0c7550 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3323,7 +3323,11 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 	if (err)
 		return err;
 
-	return ieee80211_start_mesh(sdata);
+	err = ieee80211_start_mesh(sdata);
+	if (err)
+		ieee80211_link_release_channel(&sdata->deflink);
+
+	return err;
 }
 
 static int ieee80211_leave_mesh(struct wiphy *wiphy, struct net_device *dev)
-- 
2.55.0

