Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f65.google.com ([209.85.192.65]:33967 "EHLO
	mail-qg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbcCSCLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 22:11:42 -0400
Received: by mail-qg0-f65.google.com with SMTP id j92so6595932qgj.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2016 19:11:42 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/5] mac80211: mesh: handle failed alloc for rmc cache
Date: Fri, 18 Mar 2016 22:11:28 -0400
Message-Id: <1458353492-8654-2-git-send-email-me@bobcopeland.com> (sfid-20160319_031156_289783_A47F4A41)
In-Reply-To: <1458353492-8654-1-git-send-email-me@bobcopeland.com>
References: <1458353492-8654-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the unlikely case that mesh_rmc_init() fails with -ENOMEM,
the rmc pointer will be left as NULL but the interface is still
operational because ieee80211_mesh_init_sdata() is not allowed
to fail.

If this happens, we would blindly dereference rmc when checking
whether a multicast frame is in the cache.  Instead just drop the
frames in the forwarding path.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a216c439b6f2..d0d8eeaa8129 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -220,6 +220,9 @@ int mesh_rmc_check(struct ieee80211_sub_if_data *sdata,
 	u8 idx;
 	struct rmc_entry *p, *n;
 
+	if (!rmc)
+		return -1;
+
 	/* Don't care about endianness since only match matters */
 	memcpy(&seqnum, &mesh_hdr->seqnum, sizeof(mesh_hdr->seqnum));
 	idx = le32_to_cpu(mesh_hdr->seqnum) & rmc->idx_mask;
-- 
2.6.1

