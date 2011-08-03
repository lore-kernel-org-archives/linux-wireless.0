Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:26840 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab1HCFDm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 01:03:42 -0400
Subject: [PATCH 2/3] compat: fix iteration over destination multicast
 addresses
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 03 Aug 2011 01:03:39 -0400
Message-ID: <20110803050339.10364.48100.stgit@mj.roinet.com> (sfid-20110803_070345_117634_7DAF2A34)
In-Reply-To: <20110803050333.10364.78012.stgit@mj.roinet.com>
References: <20110803050333.10364.78012.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix dev_mc_sync() and dev_mc_unsync() in compat-2.6.23.c.  When looking
for synchronized addresses, put "break" inside the above "if" to break
the loop only if there is a match.  Otherwise, advance da_to to the next
address.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 compat/compat-2.6.23.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/compat/compat-2.6.23.c b/compat/compat-2.6.23.c
index d31cfb4..365f941 100644
--- a/compat/compat-2.6.23.c
+++ b/compat/compat-2.6.23.c
@@ -104,9 +104,11 @@ int dev_mc_sync(struct net_device *to, struct net_device *from)
 		/* 2.6.22 does not have da->da_synced so lets take the long route */
 		while (da_to != NULL) {
 			if (memcmp(da_to->da_addr, da->da_addr, da_to->da_addrlen) == 0 &&
-				da->da_addrlen == da_to->da_addrlen)
+			    da->da_addrlen == da_to->da_addrlen) {
 				synced = 1;
 				break;
+			}
+			da_to = da_to->next;
 		}
 		if (!synced) {
 			err = __dev_addr_add(&to->mc_list, &to->mc_count,
@@ -160,9 +162,11 @@ void dev_mc_unsync(struct net_device *to, struct net_device *from)
 		/* 2.6.22 does not have da->da_synced so lets take the long route */
 		while (da_to != NULL) {
 			if (memcmp(da_to->da_addr, da->da_addr, da_to->da_addrlen) == 0 &&
-				da->da_addrlen == da_to->da_addrlen)
+			    da->da_addrlen == da_to->da_addrlen) {
 				synced = true;
 				break;
+			}
+			da_to = da_to->next;
 		}
 		if (!synced) {
 			da = next;
