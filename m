Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44010 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab2FFKIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:08:10 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 25/29] NFC: Switch to Initiator mode when getting NFC_ATTR_PROTOCOLS
Date: Wed,  6 Jun 2012 12:16:42 +0200
Message-Id: <1338977806-30279-26-git-send-email-sameo@linux.intel.com> (sfid-20120606_120816_702831_D46985EF)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That is needed for keeping backward compatibility with apps using the old
netlink polling API (NFC_ATTR_PROTOCOLS instead of NFC_ATTR_IM_PROTOCOLS).

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/netlink.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 21eaa9b..03c31db 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -597,11 +597,11 @@ static int nfc_genl_start_poll(struct sk_buff *skb, struct genl_info *info)
 
 	if (info->attrs[NFC_ATTR_TM_PROTOCOLS])
 		tm_protocols = nla_get_u32(info->attrs[NFC_ATTR_TM_PROTOCOLS]);
-	else if (info->attrs[NFC_ATTR_PROTOCOLS])
-		tm_protocols = nla_get_u32(info->attrs[NFC_ATTR_PROTOCOLS]);
 
 	if (info->attrs[NFC_ATTR_IM_PROTOCOLS])
 		im_protocols = nla_get_u32(info->attrs[NFC_ATTR_IM_PROTOCOLS]);
+	else if (info->attrs[NFC_ATTR_PROTOCOLS])
+		im_protocols = nla_get_u32(info->attrs[NFC_ATTR_PROTOCOLS]);
 
 	dev = nfc_get_device(idx);
 	if (!dev)
-- 
1.7.9.1

