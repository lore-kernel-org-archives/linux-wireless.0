Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36523 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbbJUMN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 08:13:27 -0400
Received: by pacfv9 with SMTP id fv9so55822168pac.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2015 05:13:26 -0700 (PDT)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] mesh: show mesh parameters when no args are given
Date: Wed, 21 Oct 2015 14:13:19 +0200
Message-Id: <1445429599-22148-1-git-send-email-ola1olsson@gmail.com> (sfid-20151021_141329_733713_FFDA515D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The help text in "<get|set> mesh_param" says that
available parameters will be shown if no args are given
but that is not the case - fix that.

Also, add help text if a parameter is given but not found.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 mesh.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/mesh.c b/mesh.c
index 460d0c9..f2415f3 100644
--- a/mesh.c
+++ b/mesh.c
@@ -286,7 +286,6 @@ static const struct mesh_param_descr *find_mesh_param(const char *name)
 			return _mesh_param_descrs + i;
 	}
 
-	print_all_mesh_param_descr();
 	return NULL;
 }
 
@@ -305,8 +304,10 @@ static int set_interface_meshparam(struct nl80211_state *state,
 	if (!container)
 		return -ENOBUFS;
 
-	if (!argc)
+	if (!argc) {
+		print_all_mesh_param_descr();
 		return 1;
+	}
 
 	while (argc) {
 		const char *name;
@@ -334,8 +335,11 @@ static int set_interface_meshparam(struct nl80211_state *state,
 		}
 
 		mdescr = find_mesh_param(name);
-		if (!mdescr)
+		if (!mdescr) {
+			printf("Could not find the parameter %s.\n", name);
+			print_all_mesh_param_descr();
 			return 2;
+		}
 
 		/* Parse the new value */
 		ret = mdescr->parse_fn(value, &any);
@@ -411,13 +415,18 @@ static int get_interface_meshparam(struct nl80211_state *state,
 {
 	const struct mesh_param_descr *mdescr = NULL;
 
-	if (argc > 1)
+	if (argc == 0) {
+		print_all_mesh_param_descr();
 		return 1;
-
-	if (argc == 1) {
+	} else if (argc == 1) {
 		mdescr = find_mesh_param(argv[0]);
-		if (!mdescr)
+		if (!mdescr) {
+			printf("Could not find the parameter %s.\n", argv[0]);
+			print_all_mesh_param_descr();
 			return 2;
+		}
+	} else {
+		return 1;
 	}
 
 	register_handler(print_mesh_param_handler, (void *)mdescr);
-- 
1.7.9.5

