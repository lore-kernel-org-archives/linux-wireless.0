Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:58060 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbZAJBRo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 20:17:44 -0500
Received: by wf-out-1314.google.com with SMTP id 27so10143447wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 17:17:43 -0800 (PST)
From: Colin McCabe <colin@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Colin McCabe <colin@cozybit.com>
Subject: [PATCH] iw: Fix regression in mesh_param input parsing
Date: Fri,  9 Jan 2009 17:13:16 -0800
Message-Id: <1231549996-15919-1-git-send-email-colin@cozybit.com> (sfid-20090110_021749_448311_F1D17CE7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the iw tool, don't crash on bad arguments to "iw dev mesh set mesh_param"

---
 mesh.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mesh.c b/mesh.c
index d6edf3f..f663363 100644
--- a/mesh.c
+++ b/mesh.c
@@ -192,9 +192,10 @@ static const struct mesh_param_descr* find_mesh_param(int argc, char **argv,
 
 	/* Find out what mesh parameter we want to change. */
 	mdescr = NULL;
-	for (i = 0; ARRAY_SIZE(_mesh_param_descrs); i++)
+	for (i = 0; i < ARRAY_SIZE(_mesh_param_descrs); i++) {
 		if (!strcmp(_mesh_param_descrs[i].name, argv[0]))
 			return _mesh_param_descrs + i;
+	}
 
 	if (!mdescr) {
 		printf("Mesh_param must be one of: ");
-- 
1.5.6.3

