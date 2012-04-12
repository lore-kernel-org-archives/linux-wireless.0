Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40958 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934681Ab2DLVcr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:32:47 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so2840406pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 14:32:47 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Shinichi Hotori <hotorinn@gmail.com>,
	Yu Niiro <yu.niiro@gmail.com>,
	Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>,
	Pavel Zubarev <pavel.zubarev@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org, ashok@cozybit.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] mac80211: Take into account TSF adjustment latency in Toffset setpoint
Date: Thu, 12 Apr 2012 14:32:23 -0700
Message-Id: <1334266343-3970-5-git-send-email-javier@cozybit.com> (sfid-20120412_233251_141720_FD8B214C)
In-Reply-To: <1334266343-3970-1-git-send-email-javier@cozybit.com>
References: <1334266343-3970-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When testing mesh synchronization we observed a global TSF slowdown that
was dependent on the number of synchronized mesh stations.  This seems
to be caused by the TSF adjustment (read/write) latency.

Adding a small margin to the Toffset setpoint solved the problem.

Signed-off-by: Shinichi Hotori <hotorinn@gmail.com>
Signed-off-by: Yu Niiro <yu.niiro@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_sync.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index 22a5f1e..ff60d6b 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -24,11 +24,17 @@
  */
 #define TOFFSET_MINIMUM_ADJUSTMENT 10
 
+/* This is not in the standard. It is a margin added to the
+ * Toffset setpoint to mitigate TSF overcorrection
+ * introduced by TSF adjustment latency.
+ */
+#define TOFFSET_SET_MARGIN 20
+
 /* This is not in the standard.  It represents the maximum Toffset jump above
  * which we'll invalidate the Toffset setpoint and choose a new setpoint.  This
  * could be, for instance, in case a neighbor is restarted and its TSF counter
  * reset.
- * */
+ */
 #define TOFFSET_MAXIMUM_ADJUSTMENT 30000		/* 30 ms */
 
 struct sync_method {
-- 
1.7.5.4

