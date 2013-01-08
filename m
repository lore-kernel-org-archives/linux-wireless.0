Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4239 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab3AHJRw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 04:17:52 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH] iw: additional mac parameter for add interface
 primitive
Date: Tue, 8 Jan 2013 10:17:28 +0100
Message-ID: <1357636648-4012-2-git-send-email-arend@broadcom.com> (sfid-20130108_101759_290314_5B87EF6D)
In-Reply-To: <1357636648-4012-1-git-send-email-arend@broadcom.com>
References: <1357636648-4012-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When adding a P2P Device interface user-space may provide the
address for it. This should allow user-space to exchange P2P
messages over multiple radios using the same address.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 interface.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/interface.c b/interface.c
index 26e72dc..f03c079 100644
--- a/interface.c
+++ b/interface.c
@@ -168,6 +168,7 @@ static int handle_interface_add(struct nl80211_state *state,
 	char *name;
 	char *mesh_id = NULL;
 	enum nl80211_iftype type;
+	unsigned char mac_addr[ETH_ALEN];
 	int tpset;
 
 	if (argc < 1)
@@ -207,6 +208,14 @@ static int handle_interface_add(struct nl80211_state *state,
 				fprintf(stderr, "flags error\n");
 				return 2;
 			}
+		} else if (strcmp(argv[0], "mac") == 0) {
+			argc--;
+			argv++;
+			if (mac_addr_a2n(mac_addr, argv[0])) {
+				fprintf(stderr, "invalid mac address\n");
+				return 2;
+			}
+			NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
 		} else {
 			return 1;
 		}
@@ -224,14 +233,14 @@ static int handle_interface_add(struct nl80211_state *state,
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(interface, add, "<name> type <type> [mesh_id <meshid>] [4addr on|off] [flags <flag>*]",
+COMMAND(interface, add, "<name> type <type> [mesh_id <meshid>] [4addr on|off] [flags <flag>*] [mac <MAC address>]",
 	NL80211_CMD_NEW_INTERFACE, 0, CIB_PHY, handle_interface_add,
 	"Add a new virtual interface with the given configuration.\n"
 	IFACE_TYPES "\n\n"
 	"The flags are only used for monitor interfaces, valid flags are:\n"
 	VALID_FLAGS "\n\n"
 	"The mesh_id is used only for mesh mode.");
-COMMAND(interface, add, "<name> type <type> [mesh_id <meshid>] [4addr on|off] [flags <flag>*]",
+COMMAND(interface, add, "<name> type <type> [mesh_id <meshid>] [4addr on|off] [flags <flag>*] [mac <MAC address>]",
 	NL80211_CMD_NEW_INTERFACE, 0, CIB_NETDEV, handle_interface_add, NULL);
 
 static int handle_interface_del(struct nl80211_state *state,
-- 
1.7.10.4


