Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa06-10.prod.phx3.secureserver.net ([173.201.192.111]:42785
	"EHLO p3plsmtpa06-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843AbaAOBAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 20:00:24 -0500
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Thierry Escande <thierry.escande@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	"Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 3/3] NFC: iso15693 - Add netlink support for ISO/IEC 15693
Date: Tue, 14 Jan 2014 17:52:11 -0700
Message-Id: <1389747131-2577-4-git-send-email-mgreer@animalcreek.com> (sfid-20140115_020026_442859_54912A1D)
In-Reply-To: <1389747131-2577-1-git-send-email-mgreer@animalcreek.com>
References: <1389747131-2577-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ISO/IEC 15693 support by having netlink push the
1-byte DSFID and 8-byte UID tag information upstream.

Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 net/nfc/netlink.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index ebbf6fb..43cb1c1 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -94,6 +94,14 @@ static int nfc_genl_send_target(struct sk_buff *msg, struct nfc_target *target,
 		    target->sensf_res))
 		goto nla_put_failure;
 
+	if (target->is_iso15693) {
+		if (nla_put_u8(msg, NFC_ATTR_TARGET_ISO15693_DSFID,
+			       target->iso15693_dsfid) ||
+		    nla_put(msg, NFC_ATTR_TARGET_ISO15693_UID,
+			    sizeof(target->iso15693_uid), target->iso15693_uid))
+			goto nla_put_failure;
+	}
+
 	return genlmsg_end(msg, hdr);
 
 nla_put_failure:
-- 
1.8.3.4

