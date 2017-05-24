Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37469 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763408AbdEXKmb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 06:42:31 -0400
Received: by mail-wm0-f52.google.com with SMTP id d127so63105825wmf.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 03:42:30 -0700 (PDT)
From: Mateusz Jurczyk <mjurczyk@google.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org
Subject: [PATCH] nfc: Ensure presence of required attributes in the activate_target netlink handler
Date: Wed, 24 May 2017 12:42:26 +0200
Message-Id: <20170524104226.14841-1-mjurczyk@google.com> (sfid-20170524_124354_594408_E5ECD255)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check that the NFC_ATTR_TARGET_INDEX and NFC_ATTR_PROTOCOLS attributes (in
addition to NFC_ATTR_DEVICE_INDEX) are provided by the netlink client
prior to accessing them. This prevents potential unhandled NULL pointer
dereference exceptions which can be triggered by malicious user-mode
programs, if they omit one or both of these attributes.

Signed-off-by: Mateusz Jurczyk <mjurczyk@google.com>
---
 net/nfc/netlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 6b0850e63e09..b251fb936a27 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -907,7 +907,9 @@ static int nfc_genl_activate_target(struct sk_buff *skb, struct genl_info *info)
 	u32 device_idx, target_idx, protocol;
 	int rc;
 
-	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
+	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
+	    !info->attrs[NFC_ATTR_TARGET_INDEX] ||
+	    !info->attrs[NFC_ATTR_PROTOCOLS])
 		return -EINVAL;
 
 	device_idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
-- 
2.13.0.219.gdb65acc882-goog
