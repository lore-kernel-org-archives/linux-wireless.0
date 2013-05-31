Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54289 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3EaCKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:10:20 -0400
Received: by mail-pd0-f176.google.com with SMTP id r11so1371660pdi.21
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:10:20 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 08/40] crda: move intersection if first attempt failed
Date: Thu, 30 May 2013 19:08:57 -0700
Message-Id: <1369966169-23640-9-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_041023_824678_2A69644F)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

The intersection should be able to continue on even if
the first two countries could not be intersected.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/intersect.c b/intersect.c
index 8f826a0..5cb7d7c 100644
--- a/intersect.c
+++ b/intersect.c
@@ -50,7 +50,7 @@ int main(int argc, char **argv)
 					"with country (%.2s)\n",
 					prev_world->alpha2,
 					rd->alpha2);
-			goto out;
+			continue;
 		}
 
 		if (intersected)
@@ -94,7 +94,6 @@ int main(int argc, char **argv)
 	printf("== World regulatory domain: ==\n");
 	print_regdom(world);
 
-out:
 	if (!intersected) {
 		free(world);
 		return r;
-- 
1.7.10.4

