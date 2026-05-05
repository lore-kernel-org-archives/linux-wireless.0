Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9ABD2F3622
	for <linux-wireless@vger.kernel.org>; Tue,  5 May 2026 13:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777987058; cv=none; b=b3at/MwCKhiq1KODmcgwKlSxtv+JxI6wPj5s/LCuip+QBZF8n2H9qmc1bSaF1Qii4+/eaTKJb/sNrDtOBN7iQqqYhqTLENly1DZ10919s2GsF70Wyxhl/IsgSA5o3yuwlYK9NKtlDs3I5Qvbmo/Xl5ZQ9q8B/3dUxtnrRbTNL4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777987058; c=relaxed/simple;
	bh=MFxw8AW9b17paMshIq7X3boHAsXZwBjfrPUOQlhQe2I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cz7PcAtZLsXnCDdfGC5ezILjil4o479cArfVJkKAyvp/z5bd1ZcegkQ4oxC5jAkSOY3d7IViO4134qzwZ27qG8hOyLKutnqPLiTsc91TgIGDzyqyJUrqueHcm/MUoLDExsarcjY8p39Isqk4OB0+sVU5II8zxslgBWvMyzbNQ3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=TE/F8sHU; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="TE/F8sHU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=931upzR5hOuk0hDgQ+KFk8oILzGD40A6S9pusc+EHiw=; t=1777987056; x=1779196656; 
	b=TE/F8sHURXtmKRGe2byBQEdf7wPS3gBBzL/qN9JAo8t5Niv0QJFIN6jWpbbOOBSBwnWKkfvcb4h
	qlsTCB70SbD5NrbWoBSK4z57nOe5nuVrjIAxjJCrI4iteBehl987lDlkxnRgjnGjIO/KmoaQUuFH1
	CU3OvEHtsH5YYrLydDjpH5JsD6oORb0Rjj6mDJw38vMREoxT8hcXApuT87PPingwBb0qa7xBIxMUG
	CCHCH9YE6cY3hQvZ97PYgDuPcdjNMRFaaxlxg+FbBzk25bafB7pKi7683ezhbY/ZALn3U9cFslpWD
	K01Xj2gaFaQ54Pewwpgzmq1cxVXsUZXPwRaA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wKFeX-0000000GEqk-3byy;
	Tue, 05 May 2026 15:17:34 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: check stations are removed before MLD change
Date: Tue,  5 May 2026 15:17:31 +0200
Message-ID: <20260505151731.3d7cbb8b952c.I4ce7b536e8af26d7b115e82fd733734446cc56a4@changeid>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

If an interface changes to/from MLD, then all stations related
to it must have been removed first. This is just natural since
we go from having links to not (or vice versa), but not doing
so also causes crashes in debugfs since vif changing to/from
MLD removes the entire debugfs for the vif, including stations.

Delete all stations but warn in this case, other code should
be handling it, in effect fail fast rather than doing a double
free or use-after-free in debugfs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
This basically makes sure that the bug I fixed in
https://lore.kernel.org/linux-wireless/20260505151533.c4e52deb06ad.Iafe56cec7de8512626169496b134bce3a6c17010@changeid/
is noticed quickly. I'll probably merge this only
after the fix lands in wireless-next via net/net-next.
---
 net/mac80211/link.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index 93e290dd783f..e81dd02de12e 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -2,7 +2,7 @@
 /*
  * MLO link handling
  *
- * Copyright (C) 2022-2025 Intel Corporation
+ * Copyright (C) 2022-2026 Intel Corporation
  */
 #include <linux/slab.h>
 #include <linux/kernel.h>
@@ -307,6 +307,9 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 	if (old_links == new_links && dormant_links == sdata->vif.dormant_links)
 		return 0;
 
+	if (!old_links || !new_links)
+		WARN_ON(sta_info_flush(sdata, -1) > 0);
+
 	/* if there were no old links, need to clear the pointers to deflink */
 	if (!old_links)
 		rem |= BIT(0);
-- 
2.53.0

