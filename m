Return-Path: <SRS0=wyJf=7R=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74727C433DF
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Jun 2020 07:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F2602074B
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Jun 2020 07:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgFDHY4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Jun 2020 03:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbgFDHY4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jun 2020 03:24:56 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00593C05BD1E
        for <linux-wireless@vger.kernel.org>; Thu,  4 Jun 2020 00:24:55 -0700 (PDT)
Received: from [46.59.202.224] (helo=localhost.localdomain)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1jgkFB-0002C6-NE; Thu, 04 Jun 2020 09:24:53 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, John Crispin <john@phrozen.org>
Subject: [PATCH] iw: add support for setting the multiple bssid transmitting flag
Date:   Thu,  4 Jun 2020 09:24:51 +0200
Message-Id: <20200604072451.25427-1-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When we want to use multiple bssid, we need to indicate that the primary
AP is transmitting at time of creation. This patch adds a new parameter
to achieve this.

Signed-off-by: John Crispin <john@phrozen.org>
---
Hi Johannes,
the patch requires the new nl80211.h from after applying the multiple bssid
kernel series.
        John

 interface.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/interface.c b/interface.c
index 6a44304..ac86259 100644
--- a/interface.c
+++ b/interface.c
@@ -237,6 +237,7 @@ static int handle_interface_add(struct nl80211_state *state,
 	int tpset;
 	unsigned char mac_addr[ETH_ALEN];
 	int found_mac = 0;
+	int multiple_bssid = 0;
 
 	if (argc < 1)
 		return 1;
@@ -287,6 +288,10 @@ try_another:
 				fprintf(stderr, "flags error\n");
 				return 2;
 			}
+		} else if (strcmp(argv[0], "multiple_bssid") == 0) {
+			argc--;
+			argv++;
+			multiple_bssid = 1;
 		} else {
 			return 1;
 		}
@@ -301,18 +306,23 @@ try_another:
 		NLA_PUT(msg, NL80211_ATTR_MESH_ID, strlen(mesh_id), mesh_id);
 	if (found_mac)
 		NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
+	if (multiple_bssid)
+		NLA_PUT_U8(msg, NL80211_ATTR_MULTI_BSSID_MODE,
+			   NL80211_MULTIPLE_BSSID_TRANSMITTED);
 
 	return 0;
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(interface, add, "<name> type <type> [mesh_id <meshid>] [4addr on|off] [flags <flag>*] [addr <mac-addr>]",
+COMMAND(interface, add, "<name> type <type> [mesh_id <meshid>] [4addr on|off] [flags <flag>*] [addr <mac-addr>] "
+	"[multiple_bssid]",
 	NL80211_CMD_NEW_INTERFACE, 0, CIB_PHY, handle_interface_add,
 	"Add a new virtual interface with the given configuration.\n"
 	IFACE_TYPES "\n\n"
 	"The flags are only used for monitor interfaces, valid flags are:\n"
 	VALID_FLAGS "\n\n"
-	"The mesh_id is used only for mesh mode.");
+	"The mesh_id is used only for mesh mode.\n"
+	"The multiple_bssid is used only for AP mode.");
 COMMAND(interface, add, "<name> type <type> [mesh_id <meshid>] [4addr on|off] [flags <flag>*] [addr <mac-addr>]",
 	NL80211_CMD_NEW_INTERFACE, 0, CIB_NETDEV, handle_interface_add, NULL);
 
-- 
2.20.1

