Return-Path: <SRS0=HTPg=VH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EC7C74A21
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Jul 2019 13:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92C1A20651
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Jul 2019 13:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfGJNib (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Jul 2019 09:38:31 -0400
Received: from aws.guarana.org ([13.237.110.252]:53788 "EHLO aws.guarana.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727184AbfGJNia (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jul 2019 09:38:30 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2019 09:38:29 EDT
Received: by aws.guarana.org (Postfix, from userid 1006)
        id E1A60BBE22; Wed, 10 Jul 2019 13:31:38 +0000 (UTC)
Date:   Wed, 10 Jul 2019 13:31:38 +0000
From:   Kevin Easton <kevin@guarana.org>
To:     linux-wireless@vger.kernel.org
Cc:     andreyknvl@google.com, davem@davemloft.net, kvalo@codeaurora.org,
        libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org,
        syzbot <syzbot+98156c174c5a2cad9f8f@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: [PATCH] libertas: Add missing sentinel at end of if_usb.c fw_table
Message-ID: <20190710133138.GA31901@ip-172-31-14-16>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This sentinel tells the firmware loading process when to stop.

Reported-and-tested-by: syzbot+98156c174c5a2cad9f8f@syzkaller.appspotmail.com
Signed-off-by: Kevin Easton <kevin@guarana.org>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index f1622f0ff8c9..fe3142d85d1e 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -50,7 +50,8 @@ static const struct lbs_fw_table fw_table[] = {
 	{ MODEL_8388, "libertas/usb8388_v5.bin", NULL },
 	{ MODEL_8388, "libertas/usb8388.bin", NULL },
 	{ MODEL_8388, "usb8388.bin", NULL },
-	{ MODEL_8682, "libertas/usb8682.bin", NULL }
+	{ MODEL_8682, "libertas/usb8682.bin", NULL },
+	{ 0, NULL, NULL }
 };
 
 static const struct usb_device_id if_usb_table[] = {
-- 
2.11.0
 
