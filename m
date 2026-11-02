Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655835;
	b=ZKRCK6zUi4s8ICRp8hXKJ6RLOuaqO4DNU7KDYRDgaQsGGuLUvSmmk4SWg1m9ORhlyJXA
	 EKK5qNbYWASLgN8SR/+QId7OOr+sU73n8aJ8G6B+U4e00Q5L15vMzz/C802Q9Q/zBInrt
	 moXbtzUiGNttK6dASpWHlGRltv/tsxW+fbTMxdaJYUDvc57QyVlPaVFP2XQTLvnWKuLEo
	 pm9aXzMYd2miGmVlpmYh7gOkSPsUfc5kEUeX1RlLvpztxqZA7FMu45V32eOqTSHiqQkDW
	 wdPTxUFWSkhHLlsMax7m95ie8crVjCmQt1iwLBbKUHcnBNRvsN3I2af6GyCDjfuVcvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655835;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=VOWBqTMU0mc9eF+sYYp2J3A6+qvPhDsvfALzj/iNZnU=;
	b=l0XwWCcwe79hvdCOLohOYODcJsdvZ/3dnxYroJmDeMdJ+lziSB1bWY/IS3010t1Z0ksA
	 lmDOlzz2djU9iCOqSb+eAb/+Id9gHKZpKt9jHUb8+AK8ieA/iBarbWkH11e3HowEAaHzy
	 Z/+mBUNcRzCNAt/7MVKyN5inAL5Fz9uLX/YomCpy28VhodetlkxJBUjU8zsWB//qbYZAD
	 0NUntjY4jG6brN5mGWenijEnA+TWEdMRCydWEt4X59lkRkJUnAeLqWspoi5A2Wg2MLTVA
	 jHiJ1nV1pA4byF9sGr1hSau3n103qIIprwLYD5yrKCVi4ot9RY41OUSebFIN2blEMtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Grlt8Ad0;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D06606A337
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 21:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Grlt8Ad0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=VOWBqTMU0mc9eF+sYYp2J3A6+qvPhDsvfALzj/iNZnU=;
	t=1793655835; x=1794865435; b=Grlt8Ad05vKKpwWx1hpnzclQcULlFWgDZcInoBd/f+QbfVT
	/Tu5i3O1bCnwPlwjDVsr1QuppI32QE1GPPQS4uegrup1ZbR0LNbp+woYNOPnJsRyzl9g8MnsgEpPb
	crogdIe/YniM0R4q0DMPJFHEmaV3PhC5EM3I1jY4YpF2cWRetCur5jWP4Do85yEMF8jMgFb+X4GQn
	SxfnqUjzF+8NNNVuexHUt5xtZFo9LThcTOTD1DZcNAYMw9wwVtr3kSVBWC3eYYKEfRBOQoFESchfL
	zSh7/c4GGPmNF0bjrh0C8SofWGzqr+Vg2sKcbcCSBnG3Fw1YItmAJnEqH9jSVCkg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNzom-000000020tw-3hXr;
	Mon, 02 Nov 2026 22:43:53 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 2/7] wifi: mac80211: clarify station link handling
Date: Mon,  2 Nov 2026 22:42:38 +0100
Message-ID: <20261102224348.e080c851cf7e.I00f86a6ab4ea32ebf1d9254125fb19db11a88f13@changeid>
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

Just like for interfaces, the change_sta_links() method
really changes the active links of a station, not (just)
valid ones. It's possible that both change, of course,
but in many cases (such as link switching) only the
active ones really change.

Clarify the documentation and add a note in the mac80211
code about why ieee80211_sta_set_link_valid() can call
the driver wrapper directly without any check.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h  | 10 ++++++----
 net/mac80211/sta_info.c |  4 ++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 76ff86ff9974..f07a4d262314 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4741,11 +4741,13 @@ struct ieee80211_prep_tx_info {
  *	Note that removal of link should always succeed, so the return value
  *	will be ignored in a removal only case.
  *	This callback can sleep.
- * @change_sta_links: Change the valid links of a station, similar to
+ * @change_sta_links: Change the active links of a station, similar to
  *	@change_vif_links. This callback can sleep.
- *	Note that a sta can also be inserted or removed with valid links,
- *	i.e. passed to @sta_add/@sta_state with sta->valid_links not zero.
- *	In fact, cannot change from having valid_links and not having them.
+ *	Note that a sta can also be inserted or removed with active links,
+ *	i.e. passed to @sta_add/@sta_state with sta->valid_links not zero
+ *	(note vif->active_links needs to be considered with sta->valid_links).
+ *	It cannot, in fact, change between having valid_links and not having
+ *	any, since it either represents an MLD or not.
  * @set_hw_timestamp: Enable/disable HW timestamping of TM/FTM frames. This is
  *	not restored at HW reset by mac80211 so drivers need to take care of
  *	that.
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 572455549c63..61aadc3c695d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -3507,6 +3507,10 @@ int ieee80211_sta_set_link_valid(struct sta_info *sta, unsigned int link_id)
 	 */
 	ieee80211_sta_recalc_aggregates(&sta->sta);
 
+	/*
+	 * Note: this is a no-op when new links are added that
+	 * aren't actually active in the vif.
+	 */
 	ret = drv_change_sta_links(sdata->local, sdata, &sta->sta,
 				   old_links, new_links);
 	if (ret) {
-- 
2.56.0

