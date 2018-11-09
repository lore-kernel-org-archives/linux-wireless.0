Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9285C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 16:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8DED20818
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 16:08:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8DED20818
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hale.at
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbeKJBt4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 20:49:56 -0500
Received: from gw.hale.at ([89.26.116.210]:51722 "EHLO gw.hale.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728008AbeKJBt4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 20:49:56 -0500
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Nov 2018 20:49:54 EST
X-HALE-Mailborder-Watermark: 1542384098.42688@F2Nco1YLxCKxPERdX17yaA
X-HALE-Mailborder-From: michael.thalmeier@hale.at
X-HALE-Mailborder-SpamCheck: not spam,
        SpamAssassin (nicht zwischen gespeichert, Wertung=-2.899,
        benoetigt 3, autolearn=not spam, ALL_TRUSTED -1.00, BAYES_00 -1.90,
        SURBL_BLOCKED 0.00)
X-HALE-Mailborder-IP-Protocol: IPv4
X-HALE-Mailborder: Found to be clean
X-HALE-Mailborder-ID: 63E6F2C1BE8.AABDB
X-HALE-Mailborder-Information: Please contact your admin for more information
Received: from mail.hale (mail.hale [192.168.100.5])
        by gw.hale.at (Postfix) with ESMTP id 63E6F2C1BE8;
        Fri,  9 Nov 2018 17:01:35 +0100 (CET)
Received: from mail.hale (localhost.localdomain [127.0.0.1])
        by mail.hale (Postfix) with ESMTP id 5E04F660D0B;
        Fri,  9 Nov 2018 17:01:35 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.hale (Postfix) with ESMTP id 5193F660CC2;
        Fri,  9 Nov 2018 17:01:35 +0100 (CET)
Received: from mail.hale ([127.0.0.1])
        by localhost (mail.hale [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rAkxE8y98vVO; Fri,  9 Nov 2018 17:01:35 +0100 (CET)
Received: from entw49.HALE (entw49.hale [192.168.100.117])
        by mail.hale (Postfix) with ESMTP id 360286605E0;
        Fri,  9 Nov 2018 17:01:35 +0100 (CET)
From:   Michael Thalmeier <michael.thalmeier@hale.at>
To:     Samuel Ortiz <sameo@linux.intel.com>
Cc:     Michael Thalmeier <michael@thalmeier.at>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-nfc@lists.01.org
Subject: [PATCH] NFC: nci: clear NCI_DATA_EXCHANGE before calling the NFC stack callback
Date:   Fri,  9 Nov 2018 17:01:18 +0100
Message-Id: <20181109160118.32737-1-michael.thalmeier@hale.at>
X-Mailer: git-send-email 2.9.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Michael Thalmeier <michael@thalmeier.at>

By calling the nfc core callback (cb) in nci_data_exchange_complete the
userspace task will get notified that response data is available for the
current request.
When the userspace task then reads the return data and immediately
issues another request, it was possible that this will be done before
the NCI_DATA_EXCHANGE is cleared.
The result is that nci_transceive will return -EBUSY and the NFC stack
(rawsock.c:rawsock_tx_work) will report an error and shut down the
socket. Not only is this quite a harsh behaviour for this situation,
but additionally any following attempt to poll for NFC tags will result
in an error "there is an active target" since the previous active tag is
not cleanly deactivated.

With this change NCI_DATA_EXCHANGE will get cleard before calling into
the NFC stack, which fixes this situation.

Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
---
 net/nfc/nci/data.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 908f25e..57d5980 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -56,6 +56,7 @@ void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
 	/* data exchange is complete, stop the data timer */
 	del_timer_sync(&ndev->data_timer);
 	clear_bit(NCI_DATA_EXCHANGE_TO, &ndev->flags);
+	clear_bit(NCI_DATA_EXCHANGE, &ndev->flags);
 
 	if (cb) {
 		/* forward skb to nfc core */
@@ -66,6 +67,7 @@ void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
 		/* no waiting callback, free skb */
 		kfree_skb(skb);
 	}
+	return;
 
 exit:
 	clear_bit(NCI_DATA_EXCHANGE, &ndev->flags);
-- 
2.9.2

