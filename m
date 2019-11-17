Return-Path: <SRS0=ku3N=ZJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC9EC432C0
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Nov 2019 12:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E31E2075E
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Nov 2019 12:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573993593;
	bh=wU4NNXylLiAFQY3d/pff/htGiKi/vDmFE6oSXf8ZP8s=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=2Oq72YpcPx9q+VFsiJIIXg9ZlHeJE4Rj5/VbfEGtQF0FfuXk+nVLV/zxC96TVh3xV
	 MBELJAygVzmnO7N4H6iskRIeTfWashaihNcVHy84rrKM0mifH/BfhlCvX56z4JSWqv
	 vmtMgvwjeA3XHfOvXJRXJj9V/36U8/YfzGHFKMKI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfKQM0c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Nov 2019 07:26:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:48906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfKQM0c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Nov 2019 07:26:32 -0500
Received: from localhost.localdomain.com (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8A06206D6;
        Sun, 17 Nov 2019 12:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573993592;
        bh=wU4NNXylLiAFQY3d/pff/htGiKi/vDmFE6oSXf8ZP8s=;
        h=From:To:Cc:Subject:Date:From;
        b=FTnHYmCaKAYko8JR/sryqB6WojA4mFRFYE4KHnEXCjUk6nx8T8WZ+igVzzD83brap
         EhYZ7+YYc485iKF6+bXP31nFIAFaLiU4qzrdV2lNJAsJpuJYchFbnowiTvE1q4WxJy
         yWgdUaZXWBBWkREj0Il0VTbMPj/bq+RngSjCilcA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH] mt76: mt76u: fix endpoint definition order
Date:   Sun, 17 Nov 2019 14:26:14 +0200
Message-Id: <8bc30967ac5a2803aec35d0a2e872d909d5914f5.1573993319.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Even if they are not currently used fix BK/BE endpoint definition order.

Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 07a1b808a142..c8c4134bb216 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -369,8 +369,8 @@ enum mt76u_in_ep {
 
 enum mt76u_out_ep {
 	MT_EP_OUT_INBAND_CMD,
-	MT_EP_OUT_AC_BK,
 	MT_EP_OUT_AC_BE,
+	MT_EP_OUT_AC_BK,
 	MT_EP_OUT_AC_VI,
 	MT_EP_OUT_AC_VO,
 	MT_EP_OUT_HCCA,
-- 
2.21.0

