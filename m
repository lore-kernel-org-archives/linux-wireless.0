Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:47037 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaDOOny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2014 10:43:54 -0400
Received: by mail-ob0-f182.google.com with SMTP id uz6so10962461obc.27
        for <linux-wireless@vger.kernel.org>; Tue, 15 Apr 2014 07:43:54 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/3] mac80211: mesh: use u16 return type for u16 getter
Date: Tue, 15 Apr 2014 10:43:06 -0400
Message-Id: <1397572988-3181-1-git-send-email-me@bobcopeland.com> (sfid-20140415_164358_516420_C1463FC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

u16_field_get() is a simple wrapper around get_unaligned_le16(),
and it is being assigned to a u16, so there's no need to
promote to u32 in the middle.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh_hwmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index f951468..03ff5ea 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -37,7 +37,7 @@ static inline u32 u32_field_get(const u8 *preq_elem, int offset, bool ae)
 	return get_unaligned_le32(preq_elem + offset);
 }
 
-static inline u32 u16_field_get(const u8 *preq_elem, int offset, bool ae)
+static inline u16 u16_field_get(const u8 *preq_elem, int offset, bool ae)
 {
 	if (ae)
 		offset += 6;
-- 
1.9.1

