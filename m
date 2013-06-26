Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41138 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab3FZPPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 11:15:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iw: reorder some code in iw_connect to avoid a potential memory leak
Date: Wed, 26 Jun 2013 11:07:16 -0400
Message-Id: <1372259236-6968-1-git-send-email-linville@tuxdriver.com> (sfid-20130626_171519_724165_C3A7D8F6)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

>From Coverity run on version 3.10:

iw-3.10/connect.c:104:leaked_storage –
	Variable "conn_argv" going out of scope leaks the storage it points to.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 connect.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/connect.c b/connect.c
index 74e4578..fb3b2fe 100644
--- a/connect.c
+++ b/connect.c
@@ -94,15 +94,15 @@ static int iw_connect(struct nl80211_state *state, struct nl_cb *cb,
 		argv++;
 	}
 
+	err = __prepare_listen_events(state);
+	if (err)
+		return err;
+
 	conn_argc = 3 + argc;
 	conn_argv = calloc(conn_argc, sizeof(*conn_argv));
 	if (!conn_argv)
 		return -ENOMEM;
 
-	err = __prepare_listen_events(state);
-	if (err)
-		return err;
-
 	conn_argv[0] = dev;
 	conn_argv[1] = "connect";
 	conn_argv[2] = "establish";
-- 
1.8.1.4

