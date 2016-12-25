Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.parknet.co.jp ([210.171.160.6]:44541 "EHLO
        mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751944AbcLYJ1O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Dec 2016 04:27:14 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        linux-wireless@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] nfc: Send same info for both of NFC_CMD_GET_DEVICE and NFC_EVENT_DEVICE_ADDED
References: <87tw9s9ydi.fsf@mail.parknet.co.jp>
Date: Sun, 25 Dec 2016 18:01:10 +0900
In-Reply-To: <87tw9s9ydi.fsf@mail.parknet.co.jp> (OGAWA Hirofumi's message of
        "Sun, 25 Dec 2016 18:00:41 +0900")
Message-ID: <87pokg9ycp.fsf@mail.parknet.co.jp> (sfid-20161225_102729_540300_6AD450A8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Now, NFC_EVENT_DEVICE_ADDED doesn't send NFC_ATTR_RF_MODE. But
NFC_CMD_GET_DEVICE send.

To get NFC_ATTR_RF_MODE, we have to call NFC_CMD_GET_DEVICE just for
NFC_ATTR_RF_MODE when get NFC_EVENT_DEVICE_ADDED.

This fixes those inconsistent.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 net/nfc/netlink.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN net/nfc/netlink.c~nfc-send-same-info net/nfc/netlink.c
--- linux/net/nfc/netlink.c~nfc-send-same-info	2016-12-18 22:16:55.805686290 +0900
+++ linux-hirofumi/net/nfc/netlink.c	2016-12-18 22:16:55.806686296 +0900
@@ -311,6 +311,17 @@ free_msg:
 	return -EMSGSIZE;
 }
 
+static int nfc_genl_setup_device_added(struct nfc_dev *dev, struct sk_buff *msg)
+{
+	if (nla_put_string(msg, NFC_ATTR_DEVICE_NAME, nfc_device_name(dev)) ||
+	    nla_put_u32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx) ||
+	    nla_put_u32(msg, NFC_ATTR_PROTOCOLS, dev->supported_protocols) ||
+	    nla_put_u8(msg, NFC_ATTR_DEVICE_POWERED, dev->dev_up) ||
+	    nla_put_u8(msg, NFC_ATTR_RF_MODE, dev->rf_mode))
+		return -1;
+	return 0;
+}
+
 int nfc_genl_device_added(struct nfc_dev *dev)
 {
 	struct sk_buff *msg;
@@ -325,10 +336,7 @@ int nfc_genl_device_added(struct nfc_dev
 	if (!hdr)
 		goto free_msg;
 
-	if (nla_put_string(msg, NFC_ATTR_DEVICE_NAME, nfc_device_name(dev)) ||
-	    nla_put_u32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx) ||
-	    nla_put_u32(msg, NFC_ATTR_PROTOCOLS, dev->supported_protocols) ||
-	    nla_put_u8(msg, NFC_ATTR_DEVICE_POWERED, dev->dev_up))
+	if (nfc_genl_setup_device_added(dev, msg))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
@@ -604,11 +612,7 @@ static int nfc_genl_send_device(struct s
 	if (cb)
 		genl_dump_check_consistent(cb, hdr, &nfc_genl_family);
 
-	if (nla_put_string(msg, NFC_ATTR_DEVICE_NAME, nfc_device_name(dev)) ||
-	    nla_put_u32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx) ||
-	    nla_put_u32(msg, NFC_ATTR_PROTOCOLS, dev->supported_protocols) ||
-	    nla_put_u8(msg, NFC_ATTR_DEVICE_POWERED, dev->dev_up) ||
-	    nla_put_u8(msg, NFC_ATTR_RF_MODE, dev->rf_mode))
+	if (nfc_genl_setup_device_added(dev, msg))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
