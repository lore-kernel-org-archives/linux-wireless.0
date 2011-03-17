Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62320 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab1CQA2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 20:28:51 -0400
Received: by pzk9 with SMTP id 9so358335pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 17:28:50 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 16 Mar 2011 17:28:50 -0700
Message-ID: <AANLkTimQRgAr9aY_zs0L7hjXhECiR9w8V5Y7fbwrJ1DX@mail.gmail.com>
Subject: [PATCH] iw: Add send callback with optional debug handler
From: Sean Robinson <seankrobinson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

libnl supports callbacks for send and recv.  This patch enables callbacks
for sent messages and uses the debug callback for the --debug option, as
the recv callbacks do.

Signed-off-by: Sean Robinson <seankrobinson@gmail.com>
---
 iw.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/iw.c b/iw.c
index 2593481..4c1fcbd 100644
--- a/iw.c
+++ b/iw.c
@@ -259,6 +259,7 @@ static int __handle_cmd(struct nl80211_state
*state, enum id_input idby,
 {
 	const struct cmd *cmd, *match = NULL, *sectcmd;
 	struct nl_cb *cb;
+	struct nl_cb *s_cb;
 	struct nl_msg *msg;
 	int devidx = 0;
 	int err, o_argc;
@@ -380,7 +381,8 @@ static int __handle_cmd(struct nl80211_state
*state, enum id_input idby,
 	}

 	cb = nl_cb_alloc(iw_debug ? NL_CB_DEBUG : NL_CB_DEFAULT);
-	if (!cb) {
+	s_cb = nl_cb_alloc(iw_debug ? NL_CB_DEBUG : NL_CB_DEFAULT);
+	if (!(cb && s_cb)) {
 		fprintf(stderr, "failed to allocate netlink callbacks\n");
 		err = 2;
 		goto out_free_msg;
@@ -404,6 +406,8 @@ static int __handle_cmd(struct nl80211_state
*state, enum id_input idby,
 	if (err)
 		goto out;

+	nl_socket_set_cb(state->nl_sock, s_cb);
+
 	err = nl_send_auto_complete(state->nl_sock, msg);
 	if (err < 0)
 		goto out;
--
1.7.4.1



-- 
Sean Robinson
WiFi Radar - http://wifi-radar.berlios.de
Python WiFi - http://pythonwifi.wikispot.org
pymnl - http://pymnl.wikispot.org
