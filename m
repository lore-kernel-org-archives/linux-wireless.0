Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46915 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2I1E7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 00:59:44 -0400
Received: by mail-qc0-f174.google.com with SMTP id d3so1651805qch.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2012 21:59:43 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 28 Sep 2012 12:59:43 +0800
Message-ID: <CAPgLHd-8KQjVnouB15F5Yc0LPrZQwnHUCa9gwjpZXEGAMzjk=g@mail.gmail.com> (sfid-20120928_065946_931643_4678DC6C)
Subject: [PATCH] mwifiex: convert to use le16_add_cpu()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: bzhao@marvell.com, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_add_cpu().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/mwifiex/scan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 04dc7ca..8272562 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -614,9 +614,8 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 
 			/* Increment the TLV header length by the size
 			   appended */
-			chan_tlv_out->header.len =
-			cpu_to_le16(le16_to_cpu(chan_tlv_out->header.len) +
-			(sizeof(chan_tlv_out->chan_scan_param)));
+			le16_add_cpu(&chan_tlv_out->header.len,
+				     sizeof(chan_tlv_out->chan_scan_param));
 
 			/*
 			 * The tlv buffer length is set to the number of bytes


