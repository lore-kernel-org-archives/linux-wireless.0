Return-Path: <SRS0=ovox=EM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E40CC2D0A3
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Nov 2020 22:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA81E206C1
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Nov 2020 22:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604701300;
	bh=t9jSt2j/mn9d/2bFgxLTxkax2Wz43GPQL/9eJHs6bJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nfz/it7BFeEbJR2ceVK3kKphi6SXJFDQSV8S5l/qkDlGz0AXR3DR+1OdUZFTwiyN9
	 Uv77yRtGYHrTKM6vL2rILk82s2wK8+3YN44+8JlBH+SVTuOqLXx3M4R/ibe0bGtLcs
	 y5dNzmKVE1bVRh7OD1+G4QIx9C33+RpGOW1zlllU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgKFWVj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 Nov 2020 17:21:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:41712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728963AbgKFWSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Nov 2020 17:18:24 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5CB12151B;
        Fri,  6 Nov 2020 22:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701103;
        bh=t9jSt2j/mn9d/2bFgxLTxkax2Wz43GPQL/9eJHs6bJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=owEJfBBOcrGQlW714fU4VJ6j6FJ7Hbh4yW9r1cTx17UAATNaC3SLVafvOptINHA7Z
         EaG/MCPttENxaPec502uc9r6GQTDeceh+9E78jLJgr+LFxYFUEJX4+YgyQEcoZwqtF
         KW286aLoA7zhoG0sXbbFmf0dXeolD6iGldx9DmnE=
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-hams@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC net-next 10/28] appletalk: use ndo_siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:25 +0100
Message-Id: <20201106221743.3271965-11-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

appletalk has three SIOCDEVPRIVATE ioctl commands that are
broken in compat mode because the passed structure contains
a pointer.

Change it over to ndo_siocdevprivate for consistency and
make it return an error when called in compat mode. This
could be fixed if there are still users.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/appletalk/ipddp.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/appletalk/ipddp.c b/drivers/net/appletalk/ipddp.c
index 51cf5eca9c7f..812b1c878ae7 100644
--- a/drivers/net/appletalk/ipddp.c
+++ b/drivers/net/appletalk/ipddp.c
@@ -54,11 +54,11 @@ static netdev_tx_t ipddp_xmit(struct sk_buff *skb,
 static int ipddp_create(struct ipddp_route *new_rt);
 static int ipddp_delete(struct ipddp_route *rt);
 static struct ipddp_route* __ipddp_find_route(struct ipddp_route *rt);
-static int ipddp_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
+static int ipddp_siocdevprivate(struct net_device *dev, struct ifreq *ifr, void __user *data, int cmd);
 
 static const struct net_device_ops ipddp_netdev_ops = {
 	.ndo_start_xmit		= ipddp_xmit,
-	.ndo_do_ioctl   	= ipddp_ioctl,
+	.ndo_siocdevprivate   	= ipddp_siocdevprivate,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
@@ -268,15 +268,18 @@ static struct ipddp_route* __ipddp_find_route(struct ipddp_route *rt)
         return NULL;
 }
 
-static int ipddp_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int ipddp_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+				void __user *data, int cmd)
 {
-        struct ipddp_route __user *rt = ifr->ifr_data;
         struct ipddp_route rcp, rcp2, *rp;
 
+	if (in_compat_syscall())
+		return -EOPNOTSUPP;
+
         if(!capable(CAP_NET_ADMIN))
                 return -EPERM;
 
-	if(copy_from_user(&rcp, rt, sizeof(rcp)))
+	if(copy_from_user(&rcp, data, sizeof(rcp)))
 		return -EFAULT;
 
         switch(cmd)
@@ -296,7 +299,7 @@ static int ipddp_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			spin_unlock_bh(&ipddp_route_lock);
 
 			if (rp) {
-				if (copy_to_user(rt, &rcp2,
+				if (copy_to_user(data, &rcp2,
 						 sizeof(struct ipddp_route)))
 					return -EFAULT;
 				return 0;
-- 
2.27.0

