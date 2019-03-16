Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE88C4360F
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 17:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DF9C218D0
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 17:06:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="uiX3Fp14"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfCPRGk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 13:06:40 -0400
Received: from nbd.name ([46.4.11.11]:55516 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726910AbfCPRGi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 13:06:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Sy0bG6Gu0sDtUJtkur5LcttwyHWVorvUoFA5JCbaAyI=; b=uiX3Fp145GcNIWyGKju3zf2eoT
        mZa1Ev3cZ9zgcKQMVM/2bS0Nh3nnpXH9KeHZU7GTQPKkrl6Ox1D5UiAwjNVSO74/NwtROU5qs3HbU
        klWpwFPdmqpYACnZyLZ0L2WUMh00Xud/lWLJcKevK2fBqMxixREicMLLaDfF8kS2O7Fo=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5ClX-00071n-PM; Sat, 16 Mar 2019 18:06:36 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id CBBEE52C90E3; Sat, 16 Mar 2019 18:06:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate tx queues
Date:   Sat, 16 Mar 2019 18:06:34 +0100
Message-Id: <20190316170634.13125-5-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190316170634.13125-1-nbd@nbd.name>
References: <20190316170634.13125-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When using iTXQ, tx sequence number allocation and statistics are run at
dequeue time. Because of that, it is safe to enable NETIF_F_LLTX, which
allows tx handlers to run on multiple CPUs in parallel.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/iface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8ab23bbfba3e..7a4ea97d15af 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1227,6 +1227,7 @@ static void ieee80211_if_setup(struct net_device *dev)
 static void ieee80211_if_setup_no_queue(struct net_device *dev)
 {
 	ieee80211_if_setup(dev);
+	dev->features |= NETIF_F_LLTX;
 	dev->priv_flags |= IFF_NO_QUEUE;
 }
 
-- 
2.17.0

