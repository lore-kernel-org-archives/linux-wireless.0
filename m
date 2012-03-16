Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43607 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492Ab2CPKG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 06:06:28 -0400
Received: by dajr28 with SMTP id r28so5934974daj.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Mar 2012 03:06:27 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: fix the endianness problem of HWMP sequence number in RANN propagation
Date: Sat, 17 Mar 2012 02:43:50 +0800
Message-Id: <1331923430-23861-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120316_110631_993892_BC6C19C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The HWMP sequence number of received RANN element is compared to decide whether to be
propagated. The sequence number is required to covert from 32bit little endian data into
CPUs endianness for comparison.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh_hwmp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 1c6f3d0..2ccb3c9 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -748,7 +748,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	flags = rann->rann_flags;
 	root_is_gate = !!(flags & RANN_FLAG_IS_GATE);
 	orig_addr = rann->rann_addr;
-	orig_sn = rann->rann_seq;
+	orig_sn = le32_to_cpu(rann->rann_seq);
 	hopcount = rann->rann_hopcount;
 	hopcount++;
 	metric = rann->rann_metric;
-- 
1.7.0.4

