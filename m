Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655835;
	b=uY8KSuqK/GWplJ4H18ntmfmcwyDDTxkQV8nSUPETTMO5JrnG5uojj/RQ6gJF30B81EXa
	 uzVlCCNmT0U1WCb8xZBR6gppuvPLpwM5/Flb2GEYAS7X6culHKt8+c+rBNwt4yWZP3rZW
	 JmpagNsSXXWVIoVFWvuSbAeEpm7K3N6BLls6yz3Lf6L0a5L9Z7tvUtzmIttYiIAENl90x
	 cHmq4qerOqf20d9U2RDuYyMoNIhqr44SVThyjpetJ7kL2PQ7pNyV5/Jk5BaOwOuvKNNdn
	 Z4CSLLmc/E7Vcwff2lFGIi+81QmQbWEQ1gS9m9xEk2awWpd4ImCSdAWs+s2DwNus2nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655835;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=9h9Us4ck53Fw0hSiK6IJUNtwPu552Z8w8Ewkh7O1aUw=;
	b=uKABmBuZzl8vlrcRdEQbaVAPZ5xPWnyeiqzx2X1KWmq7ITBB/MoIPag07pFDkgNZkzvr
	 PbCGGzatf+1egam9EUpqSli3Nl8JmsC2jts3dZbJPbkr4+PsNUuOdRPnO4SRRKdCLZMVC
	 RdYwUWJMWFAjKq6M1Psdw/vdkHjDOu005JaZmw1U3LY5LFYLsHhdmfRXfN+DOoZW0sT79
	 ljAawVNLAaIQ8aWuL/o4QVN5lNHKRoI3Z8BpeiWLuF2BwEiluVefgI1GJp/Eu78e7g8TQ
	 +2pYkjMgoQ4oB2smCxIy7kt9RtI7bAXGRz6L5OHGVPocZ1hJAxgfK3y2Ixyr/mcXCmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=FJMBm0yr;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569DD606A327
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 21:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=FJMBm0yr
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=9h9Us4ck53Fw0hSiK6IJUNtwPu552Z8w8Ewkh7O1aUw=;
	t=1793655835; x=1794865435; b=FJMBm0yr43pLHvawI3xyd60YB9bhnswynWqs6K7SwcOYSUK
	U21mU+5O/RpbdWZSbemECzxpaVgbpt4o024pQKCZjG8vg36VRwlLj8UXK+h5UKwYMVmFcbcYWNeFI
	qhBxlpZxaaCzZrV7ftCziHoEuRo7OqG5+/wjk7kOhl1MmteK757x14yRVfkXB3Qb3jAIzlLDi4igs
	A+aRwBbdkg7ItpE1GGA1+K+azE4E4YNZks3zkEoZnmhZONNPjnUVWyoyPvebZuLG2nFylv2K9YmyY
	9mqBBNOm07m20NfkYR90vNYfC9VQg9ExXhX7YYaMa/+FLqnx7FfSYdNvThoFNunQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNzom-000000020tw-0qkZ;
	Mon, 02 Nov 2026 22:43:52 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 1/7] wifi: mac80211: rename ieee80211_sta_activate_link()
Date: Mon,  2 Nov 2026 22:42:37 +0100
Message-ID: <20261102224348.0f11c70af07f.I4fb0b8c40a1f6c9bbdb7522e09ee69b2de3bb277@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102214348.1104849-9-johannes@sipsolutions.net>
References: <20261102214348.1104849-9-johannes@sipsolutions.net>
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

This isn't activate() in the sense of setting the link
to actually be active, since active links of a station
the intersection of valid links of the station and the
interface's active links.

For SMD Transition, we're going to have to track those
of a station separately, and activate() becomes more
confusing.

Rename this to ieee80211_sta_set_link_valid().

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c      | 4 ++--
 net/mac80211/mlme.c     | 4 ++--
 net/mac80211/sta_info.c | 2 +-
 net/mac80211/sta_info.h | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6e466f8e1653..a4f242a23957 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -6122,8 +6122,8 @@ ieee80211_add_link_station(struct wiphy *wiphy, struct net_device *dev,
 		rate_control_rate_init(link_sta);
 	}
 
-	/* ieee80211_sta_activate_link frees the link upon failure */
-	return ieee80211_sta_activate_link(sta, params->link_id);
+	/* ieee80211_sta_set_link_valid frees the link upon failure */
+	return ieee80211_sta_set_link_valid(sta, params->link_id);
 }
 
 static int
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8eda8154ba3d..2625103f6307 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7223,7 +7223,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		}
 
 		if (link_id != assoc_data->assoc_link_id) {
-			err = ieee80211_sta_activate_link(sta, link_id);
+			err = ieee80211_sta_set_link_valid(sta, link_id);
 			if (err)
 				goto out_err;
 		}
@@ -11218,7 +11218,7 @@ ieee80211_process_ml_reconf_resp(struct ieee80211_sub_if_data *sdata,
 		if (add_links_data->link[link_id].status != WLAN_STATUS_SUCCESS)
 			goto disconnect;
 
-		if (ieee80211_sta_activate_link(sta, link_id))
+		if (ieee80211_sta_set_link_valid(sta, link_id))
 			goto disconnect;
 
 		changed |= ieee80211_link_set_associated(link, cbss);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 23166fc39729..572455549c63 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -3473,7 +3473,7 @@ void ieee80211_sta_free_link(struct sta_info *sta, unsigned int link_id)
 	sta_remove_link(sta, link_id, false);
 }
 
-int ieee80211_sta_activate_link(struct sta_info *sta, unsigned int link_id)
+int ieee80211_sta_set_link_valid(struct sta_info *sta, unsigned int link_id)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct link_sta_info *link_sta;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 8c6a9fee6b29..0a286185125d 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -1008,7 +1008,7 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 
 int ieee80211_sta_allocate_link(struct sta_info *sta, unsigned int link_id);
 void ieee80211_sta_free_link(struct sta_info *sta, unsigned int link_id);
-int ieee80211_sta_activate_link(struct sta_info *sta, unsigned int link_id);
+int ieee80211_sta_set_link_valid(struct sta_info *sta, unsigned int link_id);
 void ieee80211_sta_remove_link(struct sta_info *sta, unsigned int link_id);
 
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
-- 
2.56.0

