Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34318 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab2ENP07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 11:26:59 -0400
Received: by dady13 with SMTP id y13so6047529dad.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 08:26:59 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] iw: print out Mesh ID on scan
Date: Mon, 14 May 2012 23:23:48 +0800
Message-Id: <1337009028-24013-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120514_172703_246494_469F4385)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print out the mesh id element which is useful for a mesh node
to scan for an existing mesh network
---
 scan.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scan.c b/scan.c
index 110e1d3..5f8ce93 100644
--- a/scan.c
+++ b/scan.c
@@ -675,6 +675,7 @@ static const struct ie_print ieprinters[] = {
 	[61] = { "HT operation", print_ht_op, 22, 22, BIT(PRINT_SCAN), },
 	[48] = { "RSN", print_rsn, 2, 255, BIT(PRINT_SCAN), },
 	[50] = { "Extended supported rates", print_supprates, 0, 255, BIT(PRINT_SCAN), },
+	[114] = { "MESH ID", print_ssid, 0, 32, BIT(PRINT_SCAN) | BIT(PRINT_LINK), },
 	[127] = { "Extended capabilities", print_capabilities, 0, 255, BIT(PRINT_SCAN), },
 };
 
-- 
1.7.0.4

