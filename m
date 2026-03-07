Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60CC17BED0
	for <linux-wireless@vger.kernel.org>; Sat,  7 Mar 2026 18:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772909117; cv=none; b=Pv/zE9XuosFWxomutV3H+4liQ3tFOXidBaDi0J2E9KvI2AWKMdLsiNhiL/2sud+rgqFQ70NL+xuDGLi3IugyV69eOVz7E2utk0AhRM52Sk2zVrY4KxcjHmPEj3b6cp+bfCe5d37JHRz1FrrbTU2utRx/ZffwQjpZI0kw0+YiOjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772909117; c=relaxed/simple;
	bh=E1Vyus7xy4s9asVdKWro1aM94MuSkTiErJPn4gvx5hg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=NN22nV9/+WiIUhvVxsFMZlO9gTLDh70jWRjbvmv9F6G7l6a8LvjEIrRaNaaY11YrkUrvLrdzd2mIheFiJJ7iVMlZAt712GflbD4kLOhi90EEnCYMshxH6b1driLcOZGNfSkiMQvw9JiDZ17duf6GgU5L92az/L7YayOExu7t0SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sY3SJsyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sY3SJsyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A62C19422;
	Sat,  7 Mar 2026 18:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772909117;
	bh=E1Vyus7xy4s9asVdKWro1aM94MuSkTiErJPn4gvx5hg=;
	h=From:Date:Subject:To:Cc:From;
	b=sY3SJsyxYRmNW1k6W4AcNoCgBq8lkPz5mRj6c9Tz8WAVi/UCDbe1axu0uDCZ8811c
	 bFFXLm1Tmugihk12kGFm8rQCvOdAze2SV/zwTYOFkf+NpRkZZxks3cAEsWBOFLeP3P
	 7B72GHfKpmtofQHA/Y9NaFYdYLingdPAn65YfJv/hL79mwweTlX1nRraaFm48y9gZe
	 uAnu6bH0ULlCtjSVGdgB4jgcozmMaSHgrqQh/ctIi5AixZC3rCh+DdbIci6FnK2hhG
	 EY0UAUghWbSCcMmrfcxH5MM69Cpz2uQG+77C16BuGTfIwsh4RgS/it7AdGuQCPvS9X
	 KMTRUkpDnekBw==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sat, 07 Mar 2026 19:45:06 +0100
Subject: [PATCH wireless-next] wifi: mac80211: Remove deleted sta links in
 ieee80211_ml_reconf_work()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260307-mac80211-reconf-remove-sta-link-v1-1-efe58070cd36@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2NQQqDMBAAvyJ7diFJtWn7FelhiRu7qElJRATJ3
 w2ehrnMnJA5CWf4NCck3iVLDFV024D7UZgYZawORpmneiiLK7mXMlpjYheDr1jjzpg3wkXCjNR
 ZT++eyZKFWvkn9nLch+FbygUIJhxocQAAAA==
X-Change-ID: 20260307-mac80211-reconf-remove-sta-link-a47fa95ea7a7
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>
X-Mailer: b4 0.14.2

Delete stale station links announced in the reconfiguration IE
transmitted by the AP in the beacon frames.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/mac80211/mlme.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5ecd3d1b172df70c6e447351c89f956b6d873c20..00ffc6b355b8d9b4cc078a887199c637c8224992 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7058,6 +7058,7 @@ static void ieee80211_ml_reconf_work(struct wiphy *wiphy,
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.ml_reconf_work.work);
 	u16 new_valid_links, new_active_links, new_dormant_links;
+	struct sta_info *sta;
 	int ret;
 
 	if (!sdata->u.mgd.removed_links)
@@ -7093,6 +7094,18 @@ static void ieee80211_ml_reconf_work(struct wiphy *wiphy,
 		}
 	}
 
+	rcu_read_lock();
+	sta = sta_info_get(sdata, sdata->vif.cfg.ap_addr);
+	if (sta) {
+		unsigned long removed_links = sdata->u.mgd.removed_links;
+		unsigned int link_id;
+
+		for_each_set_bit(link_id, &removed_links,
+				 IEEE80211_MLD_MAX_NUM_LINKS)
+			ieee80211_sta_free_link(sta, link_id);
+	}
+	rcu_read_unlock();
+
 	new_dormant_links = sdata->vif.dormant_links & ~sdata->u.mgd.removed_links;
 
 	ret = ieee80211_vif_set_links(sdata, new_valid_links,

---
base-commit: 97492c019da4b62df83255e968b23b81c0315530
change-id: 20260307-mac80211-reconf-remove-sta-link-a47fa95ea7a7

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

