Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60190 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2JIU3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2012 16:29:37 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so5630701pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2012 13:29:36 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 1/2] iw: remove unnecessary variable in find_mesh_param
Date: Tue,  9 Oct 2012 13:29:26 -0700
Message-Id: <1349814567-29556-1-git-send-email-ashok@cozybit.com> (sfid-20121009_222940_098773_BE4D97F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also stick to coding style. use "strcmp ( , ) == 0" instead of (!strcmp( , ))

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 mesh.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/mesh.c b/mesh.c
index 3077abf..4fdad6a 100644
--- a/mesh.c
+++ b/mesh.c
@@ -232,19 +232,15 @@ static void print_all_mesh_param_descr(void)
 static const struct mesh_param_descr *find_mesh_param(const char *name)
 {
 	int i;
-	const struct mesh_param_descr *mdescr = NULL;
 
 	/* Find out what mesh parameter we want to change. */
 	for (i = 0; i < ARRAY_SIZE(_mesh_param_descrs); i++) {
-		if (!strcmp(_mesh_param_descrs[i].name, name))
+		if (strcmp(_mesh_param_descrs[i].name, name) == 0)
 			return _mesh_param_descrs + i;
 	}
 
-	if (!mdescr) {
-		print_all_mesh_param_descr();
-		return NULL;
-	}
-	return mdescr;
+	print_all_mesh_param_descr();
+	return NULL;
 }
 
 /* Setter */
-- 
1.7.5.4

