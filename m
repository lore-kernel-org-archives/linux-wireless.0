Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11637 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbbG0MC5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 08:02:57 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t6RC05OT013330
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2015 05:02:56 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 1vv9ynvqy6-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2015 05:02:56 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwifiex: add missing skb_push() in mwifiex_check_uap_capabilties
Date: Mon, 27 Jul 2015 05:02:27 -0700
Message-ID: <1437998547-3592-1-git-send-email-akarwar@marvell.com> (sfid-20150727_140300_469362_5DF358ED)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For PCIe/USB chipsets, preallocated skb buffers are reused for
event handling. mwifiex_check_uap_capabilties() performs
skb_pull(). This patch adds missing skb_push() to restore skb's
data pointer/length.

This bug was introduced by commit debfc6008169 ("mwifiex: update
AP WMM settings from BSS_START event")

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_event.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 7bc1f85..4a07476 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -41,6 +41,8 @@ static int mwifiex_check_uap_capabilties(struct mwifiex_private *priv,
 	mwifiex_dbg_dump(priv->adapter, EVT_D, "uap capabilties:",
 			 event->data, event->len);
 
+	skb_push(event, MWIFIEX_BSS_START_EVT_FIX_SIZE);
+
 	while ((evt_len >= sizeof(tlv_hdr->header))) {
 		tlv_hdr = (struct mwifiex_ie_types_data *)curr;
 		tlv_len = le16_to_cpu(tlv_hdr->header.len);
-- 
1.8.1.4

