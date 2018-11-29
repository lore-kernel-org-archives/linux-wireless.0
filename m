Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF54C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 10:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 736552081C
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 10:25:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="V0Y52Xg8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 736552081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=163.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbeK2Vab (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 16:30:31 -0500
Received: from m12-14.163.com ([220.181.12.14]:41858 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727350AbeK2Vaa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 16:30:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=Qxcqrqsa/n0G8F5lup
        3XFWtfw13Qr0HW/r9aTXJFtZI=; b=V0Y52Xg8h6eI5uEKmPA39j/LNCOjbydF2r
        BIlWAgEzeyJTAiWsemx/abnfjpKFlnqNKvUltEpb1d++d+q7i8mM+gfmmUXsvUFs
        jeZz0oNzdwK2zL7GVwTARd+OLY7VDMjNjJDKKplwoXH08VVoYcHstA6g46p8sT9s
        pXTd1eW5M=
Received: from bp.localdomain (unknown [106.120.213.96])
        by smtp10 (Coremail) with SMTP id DsCowABHow2Rvv9bWQ8JCg--.30339S3;
        Thu, 29 Nov 2018 18:25:23 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH] mwifiex: fix potential NULL dereference and use after free
Date:   Thu, 29 Nov 2018 18:25:19 +0800
Message-Id: <1543487119-92033-1-git-send-email-bianpan2016@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: DsCowABHow2Rvv9bWQ8JCg--.30339S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF4kJw4xWr4UKFWDJw18Xwb_yoW8XF1fp3
        95WrWvvr4kArn8Can3Gr1Iv3W5Ka18Wa4fuFWqkwn5uws7t3s5Xw1rKa409r15tan7ZFyY
        kr10qr17WFn8GrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jkTmDUUUUU=
X-Originating-IP: [106.120.213.96]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/1tbiQBMOclSIYWFlPQAAsr
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There are two defects: (1) passing a NULL bss to
mwifiex_save_hidden_ssid_channels will result in NULL dereference,
(2) using bss after dropping the reference to it via cfg80211_put_bss.
To fix them, the patch moves the buggy code to the branch that bss is
not NULL and puts it before cfg80211_put_bss.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 8e483b0..dfe2cf0 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1882,15 +1882,17 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 					    ETH_ALEN))
 					mwifiex_update_curr_bss_params(priv,
 								       bss);
-				cfg80211_put_bss(priv->wdev.wiphy, bss);
-			}
 
-			if ((chan->flags & IEEE80211_CHAN_RADAR) ||
-			    (chan->flags & IEEE80211_CHAN_NO_IR)) {
-				mwifiex_dbg(adapter, INFO,
-					    "radar or passive channel %d\n",
-					    channel);
-				mwifiex_save_hidden_ssid_channels(priv, bss);
+				if ((chan->flags & IEEE80211_CHAN_RADAR) ||
+				    (chan->flags & IEEE80211_CHAN_NO_IR)) {
+					mwifiex_dbg(adapter, INFO,
+						    "radar or passive channel %d\n",
+						    channel);
+					mwifiex_save_hidden_ssid_channels(priv,
+									  bss);
+				}
+
+				cfg80211_put_bss(priv->wdev.wiphy, bss);
 			}
 		}
 	} else {
-- 
2.7.4


