Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A59C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 17:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A8D82084B
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 17:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfDCRrq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 13:47:46 -0400
Received: from gateway20.websitewelcome.com ([192.185.60.19]:49067 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726097AbfDCRrq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 13:47:46 -0400
X-Greylist: delayed 1499 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Apr 2019 13:47:45 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 814F2400D8B10
        for <linux-wireless@vger.kernel.org>; Wed,  3 Apr 2019 12:02:39 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id BjHbhao3u2PzOBjHbhCN24; Wed, 03 Apr 2019 12:02:39 -0500
X-Authority-Reason: nr=8
Received: from [189.250.114.183] (port=42380 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hBjHa-001mt9-Am; Wed, 03 Apr 2019 12:02:38 -0500
Date:   Wed, 3 Apr 2019 12:02:36 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] qtnfmac: replace qtnf_cmd_acl_data_size() with
 struct_size()
Message-ID: <20190403170236.GA31637@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.114.183
X-Source-L: No
X-Exim-ID: 1hBjHa-001mt9-Am
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.114.183]:42380
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct foo {
    int stuff;
    struct boo entry[];
};

size = sizeof(struct foo) + count * sizeof(struct boo);
instance = kzalloc(size, GFP_KERNEL)

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

size = struct_size(instance, entry, count);

or

instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL)

Based on the above, replace qtnf_cmd_acl_data_size() with the
new struct_size() helper.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 85a2a58f4c16..534d5a4d06fb 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -177,14 +177,6 @@ static void qtnf_cmd_tlv_ie_set_add(struct sk_buff *cmd_skb, u8 frame_type,
 		memcpy(tlv->ie_data, buf, len);
 }
 
-static inline size_t qtnf_cmd_acl_data_size(const struct cfg80211_acl_data *acl)
-{
-	size_t size = sizeof(struct qlink_acl_data) +
-		      acl->n_acl_entries * sizeof(struct qlink_mac_address);
-
-	return size;
-}
-
 static bool qtnf_cmd_start_ap_can_fit(const struct qtnf_vif *vif,
 				      const struct cfg80211_ap_settings *s)
 {
@@ -203,7 +195,7 @@ static bool qtnf_cmd_start_ap_can_fit(const struct qtnf_vif *vif,
 
 	if (s->acl)
 		len += sizeof(struct qlink_tlv_hdr) +
-		       qtnf_cmd_acl_data_size(s->acl);
+		       struct_size(s->acl, mac_addrs, s->acl->n_acl_entries);
 
 	if (len > (sizeof(struct qlink_cmd) + QTNF_MAX_CMD_BUF_SIZE)) {
 		pr_err("VIF%u.%u: can not fit AP settings: %u\n",
@@ -310,7 +302,8 @@ int qtnf_cmd_send_start_ap(struct qtnf_vif *vif,
 	}
 
 	if (s->acl) {
-		size_t acl_size = qtnf_cmd_acl_data_size(s->acl);
+		size_t acl_size = struct_size(s->acl, mac_addrs,
+					      s->acl->n_acl_entries);
 		struct qlink_tlv_hdr *tlv =
 			skb_put(cmd_skb, sizeof(*tlv) + acl_size);
 
@@ -2592,7 +2585,7 @@ int qtnf_cmd_set_mac_acl(const struct qtnf_vif *vif,
 	struct qtnf_bus *bus = vif->mac->bus;
 	struct sk_buff *cmd_skb;
 	struct qlink_tlv_hdr *tlv;
-	size_t acl_size = qtnf_cmd_acl_data_size(params);
+	size_t acl_size = struct_size(params, mac_addrs, params->n_acl_entries);
 	int ret;
 
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
-- 
2.21.0

