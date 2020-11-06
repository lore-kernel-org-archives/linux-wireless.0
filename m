Return-Path: <SRS0=ovox=EM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E29C2D0A3
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Nov 2020 22:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE192206C1
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Nov 2020 22:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604701202;
	bh=MjZ6JfjGRVgBd55ipGAv3Zcz8oLtgmjGkuSG0Rxyjz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=X/YPurq0LDoCY9r/6paCYD7spgKa0zHV7RzZRcxdKKjf6Qpfk+FyjhtfX6yOXvLkC
	 Oxjo8n+iPSU3a0gA1ohKLlYXjE9RNYuj+L6ahHxwso7pfgZqoz9HX77gQFpKTqkhfY
	 Nki4rxiW2C7JaLFnXYcgUSRdodM9mc9GlsYCj3dQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgKFWTJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 Nov 2020 17:19:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:42630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728777AbgKFWTH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Nov 2020 17:19:07 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A418622210;
        Fri,  6 Nov 2020 22:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701146;
        bh=MjZ6JfjGRVgBd55ipGAv3Zcz8oLtgmjGkuSG0Rxyjz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wMqT8C9uy6qGHxU1Qp1fwrtcZ9p6bEcCt4HI7Dfmu5jo86nRThpzE3q95C5D4JpRc
         JI7lD6SC82rg4RcZajbLMi4kpkHV1Alm05o4C6JeGhhc545yyWtnwrYG+H1GC9e2/Q
         nXXm4GwwNhJSzHvX5/6hjmVd1DLfTKpwY+2qUO0o=
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
Subject: [RFC net-next 25/28] hippi: use ndo_siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:40 +0100
Message-Id: <20201106221743.3271965-26-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The rr_ioctl uses private ioctl commands that correctly pass
all data through ifr_data, which works fine in compat mode.

Change it to use ndo_siocdevprivate as a cleanup.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/hippi/rrunner.c | 11 ++++++-----
 drivers/net/hippi/rrunner.h |  3 ++-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/hippi/rrunner.c b/drivers/net/hippi/rrunner.c
index 22010384c4a3..7661dbb31162 100644
--- a/drivers/net/hippi/rrunner.c
+++ b/drivers/net/hippi/rrunner.c
@@ -63,7 +63,7 @@ static const char version[] =
 static const struct net_device_ops rr_netdev_ops = {
 	.ndo_open 		= rr_open,
 	.ndo_stop		= rr_close,
-	.ndo_do_ioctl		= rr_ioctl,
+	.ndo_siocdevprivate	= rr_siocdevprivate,
 	.ndo_start_xmit		= rr_start_xmit,
 	.ndo_set_mac_address	= hippi_mac_addr,
 };
@@ -1568,7 +1568,8 @@ static int rr_load_firmware(struct net_device *dev)
 }
 
 
-static int rr_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+static int rr_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+			     void __user *data, int cmd)
 {
 	struct rr_private *rrpriv;
 	unsigned char *image, *oldimage;
@@ -1603,7 +1604,7 @@ static int rr_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 			error = -EFAULT;
 			goto gf_out;
 		}
-		error = copy_to_user(rq->ifr_data, image, EEPROM_BYTES);
+		error = copy_to_user(data, image, EEPROM_BYTES);
 		if (error)
 			error = -EFAULT;
 	gf_out:
@@ -1615,7 +1616,7 @@ static int rr_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 			return -EPERM;
 		}
 
-		image = memdup_user(rq->ifr_data, EEPROM_BYTES);
+		image = memdup_user(data, EEPROM_BYTES);
 		if (IS_ERR(image))
 			return PTR_ERR(image);
 
@@ -1658,7 +1659,7 @@ static int rr_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		return error;
 
 	case SIOCRRID:
-		return put_user(0x52523032, (int __user *)rq->ifr_data);
+		return put_user(0x52523032, (int __user *)data);
 	default:
 		return error;
 	}
diff --git a/drivers/net/hippi/rrunner.h b/drivers/net/hippi/rrunner.h
index 87533784604f..55377614e752 100644
--- a/drivers/net/hippi/rrunner.h
+++ b/drivers/net/hippi/rrunner.h
@@ -835,7 +835,8 @@ static int rr_open(struct net_device *dev);
 static netdev_tx_t rr_start_xmit(struct sk_buff *skb,
 				 struct net_device *dev);
 static int rr_close(struct net_device *dev);
-static int rr_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+static int rr_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+			     void __user *data, int cmd);
 static unsigned int rr_read_eeprom(struct rr_private *rrpriv,
 				   unsigned long offset,
 				   unsigned char *buf,
-- 
2.27.0

