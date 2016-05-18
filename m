Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45285 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbcERLWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2016 07:22:16 -0400
From: "Tribush, Gil" <gil.tribush@intel.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] iw: Change socket configuration to avoid buffer allocation
 error
Date: Wed, 18 May 2016 11:22:10 +0000
Message-ID: <9500D1AF62AEC945997ED710048926644CF4360C@HASMSX106.ger.corp.intel.com> (sfid-20160518_132221_431126_4FD2CD37)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move  nl_socket_set_buffer_size() to be called after genl_connect(),
otherwise nl_socket_set_buffer_size() always returns an NLE_BAD_SOCK
error because sk->s_fd is equal to -1 at that stage.

Signed-off-by: Gil Treibush <gil.tribush@intel.com>
---
iw.c | 4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/iw.c b/iw.c
index 0f511d9..e3742cd 100644
--- a/iw.c
+++ b/iw.c
@@ -54,14 +54,14 @@ static int nl80211_init(struct nl80211_state *state)
 		return -ENOMEM;
 	}
 
-	nl_socket_set_buffer_size(state->nl_sock, 8192, 8192);
-
 	if (genl_connect(state->nl_sock)) {
 		fprintf(stderr, "Failed to connect to generic netlink.\n");
 		err = -ENOLINK;
 		goto out_handle_destroy;
 	}
 
+	nl_socket_set_buffer_size(state->nl_sock, 8192, 8192);
+
 	state->nl80211_id = genl_ctrl_resolve(state->nl_sock, "nl80211");
 	if (state->nl80211_id < 0) {
 		fprintf(stderr, "nl80211 not found.\n");
--
1.9.1
---------------------------------------------------------------------
A member of the Intel Corporation group of companies

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

