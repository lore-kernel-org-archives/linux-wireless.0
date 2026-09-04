Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E474D2ED0
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533856; cv=none; b=KpU8KV5mmR2lGbH6GaIfCFJObx5/+3XIst2SKmqlBnKSSsTncctiUH/O/DxPpawYWhYhpoBv+rl57bieCrEPkvT+3CCvR96xJlcEOXBA8RU1qXs3uNKwnB4mqmIFKBM9PLyO6NXZsyQskwWfN6/JHmHVYmxGFRSrt0u4f3BS/EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533856; c=relaxed/simple;
	bh=6+UqvepD42Zb8JNGL4hPZ0lDy7UFvR4SHJNteLYj2DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiaQxmNnv+9TiA5pFgp2RqsaquO0dfl7fnfJzsiYtOYAR2yR8ELliC4rdeS0Ak9Y97YoWLFKLmn1e1jlnErDlNxUnsWOM11RwRv/uYi9+kBNvUJFw8XWGtGgaVoZtW7e2pYCtp+kf4XnYOcE+txC25M7zyU3IUxlowK9L+AvSNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=E3odojiU; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="E3odojiU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=o9cEsSR5FPB4gcgAaaNlCjs//FUHHMsJ/CQTcX+Gv9I=;
	t=1788533855; x=1789743455; b=E3odojiULGKCfJifyC3iJpXzB1orX6HI7KMaHIv2K+8Xy8W
	YFjXrMTyOXGF5Z5JlSIXjC4vASt9leeOs8C69+F2F9M8a9VpEfCeK7N10MjvoQ8ztQyx6dRMC7446
	2XnbPwqdZP4sUh21b+1ecNDCuwEZczJuy9J7OhN2fzYa2O7Riy8XaRu2ErRcoCF9YBEkcgOWuPXcN
	F4wl9+hBIKdNxXBSaoAgaT3HOr6j6I2Cw3LkTQeYpuGHKCB1F+/tkU5SgqYF2Ja4cC8QJLdFCBrM1
	0M8KsssPnlMxEGPWXEFeDaGfi0P5OswYJnalACGl0yRJGfvcKP88HvcBsDFCT+lA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VMB-00000001SWk-47BT;
	Fri, 04 Sep 2026 16:57:32 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+56a1a45a9a2c04d425ff@syzkaller.appspotmail.com
Subject: [PATCH wireless 06/10] wifi: mac80211: suppress chanctx warning for debugfs reset
Date: Fri,  4 Sep 2026 16:57:10 +0200
Message-ID: <20260904165722.fe46395e310b.Ic4aaa95bd9d0ceb6a3cd7d84c425afee7d7d3dd7@changeid>
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

Before suspend all the channel contexts should removed, so the
warning makes sense and should be there, but during reset the
same code is called without first removing. Limit the check to
the real suspend case.

Assisted-by: LLM
Fixes: 12e7f517029d ("mac80211: cleanup generic suspend/resume procedures")
Reported-by: syzbot+56a1a45a9a2c04d425ff@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=56a1a45a9a2c04d425ff
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         | 2 +-
 net/mac80211/debugfs.c     | 2 +-
 net/mac80211/ieee80211_i.h | 2 +-
 net/mac80211/pm.c          | 8 +++++---
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1f074799f85f..2b13c057312e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3475,7 +3475,7 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 static int ieee80211_suspend(struct wiphy *wiphy,
 			     struct cfg80211_wowlan *wowlan)
 {
-	return __ieee80211_suspend(wiphy_priv(wiphy), wowlan);
+	return __ieee80211_suspend(wiphy_priv(wiphy), wowlan, false);
 }
 
 static int ieee80211_resume(struct wiphy *wiphy)
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 105653a16b68..e38631d7cfb4 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -384,7 +384,7 @@ static ssize_t reset_write(struct file *file, const char __user *user_buf,
 
 	rtnl_lock();
 	wiphy_lock(local->hw.wiphy);
-	__ieee80211_suspend(&local->hw, NULL);
+	__ieee80211_suspend(&local->hw, NULL, true);
 	ret = __ieee80211_resume(&local->hw);
 	wiphy_unlock(local->hw.wiphy);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5761e9621491..d05f59467399 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2432,7 +2432,7 @@ int ieee80211_reconfig(struct ieee80211_local *local);
 void ieee80211_stop_device(struct ieee80211_local *local, bool suspend);
 
 int __ieee80211_suspend(struct ieee80211_hw *hw,
-			struct cfg80211_wowlan *wowlan);
+			struct cfg80211_wowlan *wowlan, bool reset);
 
 static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 {
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 5a508d99e84f..f63676c44853 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -18,7 +18,8 @@ static void ieee80211_sched_scan_cancel(struct ieee80211_local *local)
 	cfg80211_sched_scan_stopped_locked(local->hw.wiphy, 0);
 }
 
-int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
+int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan,
+			bool reset)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
@@ -166,9 +167,10 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	/*
 	 * We disconnected on all interfaces before suspend, all channel
-	 * contexts should be released.
+	 * contexts should be released, but on 'reset' debugfs that's
+	 * not true so don't check there.
 	 */
-	WARN_ON(!list_empty(&local->chanctx_list));
+	WARN_ON(!reset && !list_empty(&local->chanctx_list));
 
 	/* stop hardware - this must stop RX */
 	ieee80211_stop_device(local, true);
-- 
2.55.0

