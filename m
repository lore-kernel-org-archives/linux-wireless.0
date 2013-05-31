Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:42925 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3EaCK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:10:29 -0400
Received: by mail-pd0-f181.google.com with SMTP id bv13so1385361pdb.12
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:10:29 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 10/40] crda: annotate intersection worst case scenerio
Date: Thu, 30 May 2013 19:08:59 -0700
Message-Id: <1369966169-23640-11-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_041032_117601_D0228C91)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

In the worst case scenerio of regulatory domain intersections
between a different set of regulatory rules you will end up
without being able to initiate radiation on any frequency
range. Provide a hint as to what needs to be done next in
order to actually build a useful regulatory domain. Currently
we do this manually but building the mathematics would be
even more useful as we grow usage of the spectrum.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/intersect.c b/intersect.c
index dea9145..169fe1a 100644
--- a/intersect.c
+++ b/intersect.c
@@ -83,7 +83,14 @@ int main(int argc, char **argv)
 		printf("%d regulatory domains intersected\n", intersected);
 	else {
 		world = prev_world;
-		printf("Only one intersection completed\n");
+		printf("No intersections completed\n");
+		if (idx > 1) {
+			printf("Since more than one regulatory domain is "
+			       "present and no intersections were possible "
+			       "no globally allowed spectrum is possible so "
+			       "consider enabling passive scan flags\n");
+			return r;
+		}
 	}
 
 	/* Tada! */
-- 
1.7.10.4

