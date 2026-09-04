Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808B34E8DF0
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534084; cv=none; b=WFmc3t/p3vtUAHDS23Zp2qpbTTnuPro31STVulLcnFO0baA3YlebOpA4d9g5PazHVdySGJGUo+554NlnAbZB4Kywv2LGUNIJkTQqaAJ8frEZ2ofTyuADMohawgZsgjxrO7LW+WpdM+HYVJusvFz/hj5JcVFF9B95OT8EfBKUWXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534084; c=relaxed/simple;
	bh=Xyrcs2dI/5u3zjAygaa6NX18qZE3Do2d8m64aD2UWPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1VUTl1To7ukERkK7Ife70+9gaRt5uNfjJB+e40IMDq7ZHT85CDVEuBpene+5FPFh/QGl/9NEZ6J7Y/cboxzBu/JJCcBu5+u2c5ICXpiC6pSsAAIJH7T4AsPQD1Latn9mqGEAzZfB26JFE2D1ZhtUbNBfWmZCqkmXaqGQ+R/TWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=KlE6u/qn; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="KlE6u/qn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=VKEeZrAKiNxkQnY22cdumtd1jglyouYdMI9MwyQDn+0=;
	t=1788534082; x=1789743682; b=KlE6u/qnpMe8aH23SAliFQL/Nw++m0nQIuQ9DiWMICutvz2
	u/9xUIOnDxNIivDYa1qgexVmk3Y5COUl5IyzbmdwijDTpKu3lR8YDk+4eFmGeE4bUzVhs/f3yXJRw
	oRBsbBGeyDDzW1MKIHEN/Pbl1q+fRonkDiG4dqPTTYgLIT5n+X2bpPb/NHR8P2FFb+sGU/5WpU9pd
	u1yT3BE7mQo1KXiGP8Idaxl9oE1aanWWdTFmEEsxt1gkX6xZDCBnqFWB5gsTbG+uAiJKDrVktr2oa
	EjUbBX2r3ZlCSFj0dPRkjkblP1nU4n7gUTuqV8hUG3wQDaWKtS5NzTACB6txmhKQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VPq-00000001SeL-48Xg;
	Fri, 04 Sep 2026 17:01:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+63a84ea9c0f57d6133fa@syzkaller.appspotmail.com
Subject: [PATCH wireless 09/10] wifi: mac80211: mesh: release the channel if start fails
Date: Fri,  4 Sep 2026 16:58:08 +0200
Message-ID: <20260904170057.8c86b0a8a44f.If6d6e31f93aca94e992ae17edc691407b146537c@changeid>
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

