Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 505B3C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 23:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14BC221855
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 23:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549928773;
	bh=0UuwXlt/bXioGK5ReTI5f0+/p/SGhrNUOnDyZHGm7hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=o2+E0kMLLqb1wEbCyQCS2xH6KZd8Kx0NKOs+0rlLAhNknhq+nZTpLJkca9zKKGRwT
	 7YBcordySfD81l6/aVWWJF+aH+XCHCxUZ9tVwR1hqO4G+V8ivbx6JGOQm6YKqpLUJk
	 AuVqs9kBRYGCQ23l0D20CpqKI+NDdrwidA16/XzE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfBKXqM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 18:46:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:42310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727535AbfBKXqM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 18:46:12 -0500
Received: from lore-desk.lan (unknown [151.66.10.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC3CE20873;
        Mon, 11 Feb 2019 23:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549928771;
        bh=0UuwXlt/bXioGK5ReTI5f0+/p/SGhrNUOnDyZHGm7hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVv4FWwmvapqOF/fN87s1mV2IezGdkIyCtKfwAYQK1c0homXpaP9qgOd2Yo+tvJSK
         T8Ey1GCMZl8IddotZ/SQdjhlhcPPqnjz7fLR6vPgEUjTvBUeN0AdPBJklyu0gCzcOQ
         CEJJqQHDF9tFmJtaolUWvfWt2KaVl6XCASuiNx9A=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo@kernel.org
Subject: [PATCH] mt76: usb: use dev_err_ratelimited instead of dev_err in mt76u_complete_rx
Date:   Tue, 12 Feb 2019 00:45:55 +0100
Message-Id: <25bdd32592a9e0e64d202b1a53c4680f0d958423.1549928358.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1549928358.git.lorenzo@kernel.org>
References: <cover.1549928358.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

During device removal the driver can report multiple error messages.
Use dev_err_ratelimited instead of dev_err to display urb errors

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 018a8cf0941e..10cd98d11fc2 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -446,7 +446,8 @@ static void mt76u_complete_rx(struct urb *urb)
 	case -ENOENT:
 		return;
 	default:
-		dev_err(dev->dev, "rx urb failed: %d\n", urb->status);
+		dev_err_ratelimited(dev->dev, "rx urb failed: %d\n",
+				    urb->status);
 		/* fall through */
 	case 0:
 		break;
-- 
2.20.1

