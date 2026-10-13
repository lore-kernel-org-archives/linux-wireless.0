Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ABD4EFFD4
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898739; cv=none; b=RLLoZorLcHhobC60y3zquHCmbYwMWeX7n2+rRtYu+N5Mq8IGBoE+67rXfTyVostT7EjpluPeWE1renmkykvC4FIN0nxRzxRvo4yM+danqnWxZ0rl18AC57MDS+NIHvrFkS+TfktFRmMoL/54x2KGjSV90WYVsS4Kb3mmZ7/gcoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898739; c=relaxed/simple;
	bh=8EC1WChKyctgbPq2BXaTH2rvp+Y8k33baJ7ZvI2fMAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZoxzNnsI9RW+tOaAmZKB1g5b65xeZvCsILTIPrVfCEMM6ybSN0B4cyruCYxhPNhuvTqc/v6GHZxo3FeQg3dptdcWGZWrEEisl3ectYf5UpXEmCxNmwXBoo/JA8ew9bSX8RLfxQf0lwVJzvOJDmqkfghaUNqnEdkvwdhu3Ax6Fag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=snsGhqQ5; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="snsGhqQ5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=s8uKNwnl6A2pQS48C52vupcmygNJQ5cXEw4CZTRS2dY=; t=1791898738; x=1793108338; 
	b=snsGhqQ5s/ObERXyh76n8+IaAJZkBNqsM8w15JhB5MWCKUEMg7yM8oyZm+OgsnvoKlPMRfhvc2G
	8H9INWKKUW6HlJ3/bERngkmfQoNIqcmWzKtfECvGwN6bS7HDTgDiwxhMW7zrPOXp2aNiwmA6GGSI9
	SbG3gm1nqmSQWh70rL9R7FwOrdZTPPDd8ZNWljPKQW5Yb/R493wrhwjp9aokMFinRU0WzrKaldPvh
	Iz9NsBmqv6T6rZLHSZWioLw9Lpk5sdXpy43sEHIyk3mv2v2yMBLi5shh0+KWqIhbe1N1Fll3xotat
	TUbGAHnETzaS8xjN5Mh9887MAEltVpixfpIA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGciV-0000000HRK6-0yZR;
	Tue, 13 Oct 2026 15:38:55 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: avoid using dialog token 0
Date: Tue, 13 Oct 2026 15:38:52 +0200
Message-ID: <20261013153853.ee78f49efc86.I1c422b7dfc068b9c1a000a4213fcd9f7afc5d71d@changeid>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This dialog token will be special at least in UHR,
and since there's no need to have zero just avoid
using zero in general.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6ec45a9f7221..3aedf4032298 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4508,6 +4508,16 @@ static void ieee80211_ml_reconf_reset(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
+static u8 ieee80211_mgd_next_dialog_token(struct ieee80211_sub_if_data *sdata)
+{
+	sdata->u.mgd.dialog_token_alloc++;
+
+	if (!sdata->u.mgd.dialog_token_alloc)
+		sdata->u.mgd.dialog_token_alloc++;
+
+	return sdata->u.mgd.dialog_token_alloc;
+}
+
 static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 				   u16 stype, u16 reason, bool tx,
 				   u8 *frame_buf)
@@ -8637,9 +8647,8 @@ int ieee80211_req_neg_ttlm(struct ieee80211_sub_if_data *sdata,
 		return -EINVAL;
 
 	ieee80211_apply_neg_ttlm(sdata, neg_ttlm);
-	sdata->u.mgd.dialog_token_alloc++;
 	ieee80211_send_neg_ttlm_req(sdata, &sdata->vif.neg_ttlm,
-				    sdata->u.mgd.dialog_token_alloc);
+				    ieee80211_mgd_next_dialog_token(sdata));
 	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
 				  &sdata->u.mgd.neg_ttlm_timeout_work);
 	wiphy_delayed_work_queue(sdata->local->hw.wiphy,
@@ -11320,7 +11329,7 @@ ieee80211_build_ml_reconf_req(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.action_code = WLAN_PROTECTED_EHT_ACTION_LINK_RECONFIG_REQ;
 
 	/* allocate a dialog token and store it */
-	sdata->u.mgd.reconf.dialog_token = ++sdata->u.mgd.dialog_token_alloc;
+	sdata->u.mgd.reconf.dialog_token = ieee80211_mgd_next_dialog_token(sdata);
 	mgmt->u.action.ml_reconf_req.dialog_token =
 		sdata->u.mgd.reconf.dialog_token;
 
@@ -11728,7 +11737,7 @@ int ieee80211_mgd_set_epcs(struct ieee80211_sub_if_data *sdata, bool enable)
 		mgmt->u.action.action_code =
 			WLAN_PROTECTED_EHT_ACTION_EPCS_ENABLE_REQ;
 
-		*pos = ++sdata->u.mgd.dialog_token_alloc;
+		*pos = ieee80211_mgd_next_dialog_token(sdata);
 		sdata->u.mgd.epcs.dialog_token = *pos;
 	} else {
 		mgmt->u.action.action_code =
-- 
2.56.0

