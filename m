Return-Path: <SRS0=gH9T=3L=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EEB0C32771
	for <linux-wireless@archiver.kernel.org>; Wed, 22 Jan 2020 04:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C08C2070C
	for <linux-wireless@archiver.kernel.org>; Wed, 22 Jan 2020 04:07:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="iva23+yX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgAVEHd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 21 Jan 2020 23:07:33 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:54233 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgAVEHc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Jan 2020 23:07:32 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 482X1G3C2cz9sRR; Wed, 22 Jan 2020 15:07:30 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1579666050;
        bh=G7bbOYoKRp6jrs8GgGQz2ON95U4owgnlnz579hK3u2o=;
        h=From:To:Cc:Subject:Date:From;
        b=iva23+yXgpPhxd556QpzNZZ+YheLIZT1526j5B6Xr00lqX1DY/UcF1y5QwLPPn1Nq
         /bM0KMZARUT6MVYuFgJL7fN9GvAbN/S4x5yFX24I2MT0+mVb9JOGIbs+x8szKg6d11
         XF+S07HUyPH6JC+lQaSM8MQzZzyEmMmeWXvoXbhkG/0zngeCeNnzyV3KfTFjZYrwJj
         fCn8kGzeCWPu/Rr6TCLRnJ53944/tlpZkTDFyZ3uEqKCBIHxH/PiFOFlvqFgjRXmOA
         Pf2dRKCaV9rmzMs9JY/pUhHRTpWkr258ul1XfEtFLMkcN6zm4gTHCw1JYWMlgt6yDU
         HnIIBz0I+A6Zg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        security@kernel.org, ivansprundel@ioactive.com
Subject: [PATCH 1/2] airo: Fix possible info leak in AIROOLDIOCTL/SIOCDEVPRIVATE
Date:   Wed, 22 Jan 2020 15:07:27 +1100
Message-Id: <20200122040728.8437-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The driver for Cisco Aironet 4500 and 4800 series cards (airo.c),
implements AIROOLDIOCTL/SIOCDEVPRIVATE in airo_ioctl().

The ioctl handler copies an aironet_ioctl struct from userspace, which
includes a command and a length. Some of the commands are handled in
readrids(), which kmalloc()'s a buffer of RIDSIZE (2048) bytes.

That buffer is then passed to PC4500_readrid(), which has two cases.
The else case does some setup and then reads up to RIDSIZE bytes from
the hardware into the kmalloc()'ed buffer.

Here len == RIDSIZE, pBuf is the kmalloc()'ed buffer:

	// read the rid length field
	bap_read(ai, pBuf, 2, BAP1);
	// length for remaining part of rid
	len = min(len, (int)le16_to_cpu(*(__le16*)pBuf)) - 2;
	...
	// read remainder of the rid
	rc = bap_read(ai, ((__le16*)pBuf)+1, len, BAP1);

PC4500_readrid() then returns to readrids() which does:

	len = comp->len;
	if (copy_to_user(comp->data, iobuf, min(len, (int)RIDSIZE))) {

Where comp->len is the user controlled length field.

So if the "rid length field" returned by the hardware is < 2048, and
the user requests 2048 bytes in comp->len, we will leak the previous
contents of the kmalloc()'ed buffer to userspace.

Fix it by kzalloc()'ing the buffer.

Found by Ilja by code inspection, not tested as I don't have the
required hardware.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 drivers/net/wireless/cisco/airo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index f43c06569ea1..d69c2ee7e206 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -7813,7 +7813,7 @@ static int readrids(struct net_device *dev, aironet_ioctl *comp) {
 		return -EINVAL;
 	}
 
-	if ((iobuf = kmalloc(RIDSIZE, GFP_KERNEL)) == NULL)
+	if ((iobuf = kzalloc(RIDSIZE, GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 
 	PC4500_readrid(ai,ridcode,iobuf,RIDSIZE, 1);
-- 
2.21.1

