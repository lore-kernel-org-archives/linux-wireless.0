Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A91FC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 22:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDD2F20827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 22:32:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDD2F20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbeKJIO5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 10 Nov 2018 03:14:57 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36319 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbeKJIO5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Nov 2018 03:14:57 -0500
Received: by mail-wm1-f66.google.com with SMTP id v70-v6so2816494wmd.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 14:32:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vgcdRvYlbs+uyz3iaj7ldSvzNoh3SVgGSe/Hz+bJd6o=;
        b=Sy+U99B0+rp3LpfUTUlh/IX/Rl3lL7XH6+YpsIAP9AQuC5xztUeLcdq5C46Jj92a0P
         YzvuU75/li27I49kpxQGm2nk8d/ORJNi3Gj0RvM/AQHKVLn/kKgBQohlZyq52/hbj7bI
         FCYAZlghSzw+ryMdwLAh9WH/WwqyTFn5h6L68t6FHNPrsm2IrSDUL1LwsHHfnATsstVK
         Iv04yNEQ3UUWGGmAC4DLb9bsYqS4bsqqU9m/7jw7TpMzzayUnk6j+QtPehY66l7IwRS5
         rA3igNFUebHz1GtPMQED0JCzWlCDhO4hZJv9dWeO4V1gDtUhbQyh1dLz3fW//Z/eSKsz
         R7gQ==
X-Gm-Message-State: AGRZ1gK5EEZhXO7HJPt3pqeuXxvIXew48UYwfbGh5OCEmrM/0TltjMRr
        QzXabKo5aPMOXnIRBgW+fEUjxA==
X-Google-Smtp-Source: AJdET5cvEzsy4I+0/RQniPgXTrmle4tw63NCj+qs6wZZo4UEwZEnw5A8Yh1R29jP7yvM0HTtMfNWQA==
X-Received: by 2002:a1c:c2d4:: with SMTP id s203-v6mr840942wmf.97.1541802737818;
        Fri, 09 Nov 2018 14:32:17 -0800 (PST)
Received: from localhost.localdomain ([151.66.8.224])
        by smtp.gmail.com with ESMTPSA id s5-v6sm8187402wrq.16.2018.11.09.14.32.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Nov 2018 14:32:16 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, luca.bisti@fluidmesh.com,
        lorenzo.trisolini@fluidmesh.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: fix uninitialized mutex access setting rts threshold
Date:   Fri,  9 Nov 2018 23:32:07 +0100
Message-Id: <bfcac7be8f989b99b1efb11c3e541d1d1167d524.1541802405.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1541802405.git.lorenzo.bianconi@redhat.com>
References: <cover.1541802405.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix following crash due to a leftover uninitialized mutex access
in mt76x02_set_rts_threshold routine.

[   55.655884] CPU: 0 PID: 412 Comm: iw Not tainted 4.19.0-rc7+ #2493
[   55.661739] Call Trace:
[   55.662523]  register_lock_class+0x528/0x530
[   55.663806]  __lock_acquire+0x89/0x15d0
[   55.664841]  lock_acquire+0x9f/0x140
[   55.665794]  ? mt76x02_set_rts_threshold+0x28/0x50
[   55.667056]  ? noop_count+0x10/0x10
[   55.667981]  ? mt76x02_set_rts_threshold+0x28/0x50
[   55.669251]  __mutex_lock+0x4a/0x4f0
[   55.670199]  ? mt76x02_set_rts_threshold+0x28/0x50
[   55.671454]  ? find_held_lock+0x2d/0x90
[   55.672450]  ? nl80211_pre_doit+0xf9/0x1a0
[   55.673467]  ? mt76x02_set_rts_threshold+0x28/0x50
[   55.674637]  mt76x02_set_rts_threshold+0x28/0x50
[   55.675773]  ieee80211_set_wiphy_params+0x16d/0x4e0
[   55.676910]  nl80211_set_wiphy+0x72b/0xbc0
[   55.677927]  genl_family_rcv_msg+0x192/0x3a0
[   55.678919]  genl_rcv_msg+0x42/0x89
[   55.679742]  ? genl_family_rcv_msg+0x3a0/0x3a0
[   55.680600]  netlink_rcv_skb+0x38/0x100
[   55.681313]  genl_rcv+0x1f/0x30
[   55.681899]  netlink_unicast+0x16b/0x210
[   55.682628]  netlink_sendmsg+0x1ed/0x390
[   55.683373]  sock_sendmsg+0x31/0x40
[   55.684020]  ___sys_sendmsg+0x23c/0x280
[   55.684736]  ? __handle_mm_fault+0xce8/0x1000
[   55.685445]  ? _raw_spin_unlock+0x1f/0x30
[   55.686059]  ? find_held_lock+0x2d/0x90
[   55.686648]  ? __do_page_fault+0x207/0x440
[   55.687274]  __sys_sendmsg+0x42/0x80
[   55.687825]  do_syscall_64+0x50/0x190
[   55.688410]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   55.689174] RIP: 0033:0x7fdeea227ba7
[   55.692157] RSP: 002b:00007ffec2395b58 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[   55.693138] RAX: ffffffffffffffda RBX: 000000000066c350 RCX: 00007fdeea227ba7
[   55.694059] RDX: 0000000000000000 RSI: 00007ffec2395b90 RDI: 0000000000000003
[   55.694966] RBP: 0000000000671740 R08: 0000000000000002 R09: 0000000000000000
[   55.695773] R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000671880
[   55.696572] R13: 00007ffec2395b90 R14: 00007ffec2395e60 R15: 0000000000671880

Fixes: 108a4861ef19 (" mt76: create new mt76x02-lib module for common
mt76x{0,2} code")

Reported-by: lorenzo.trisolini@fluidmesh.com
Reported-by: luca.bisti@fluidmesh.com
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
I will post a fix based on wireless-drivers repo
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h      | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 65daa3d3c289..1d8bb426e772 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -69,7 +69,6 @@ struct mt76x02_dev {
 	struct mac_address macaddr_list[8];
 
 	struct mutex phy_mutex;
-	struct mutex mutex;
 
 	u8 txdone_seq;
 	DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76x02_tx_status);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 48f2f5382b57..bd0a879f7e7a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -481,9 +481,9 @@ int mt76x02_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
 	if (val != ~0 && val > 0xffff)
 		return -EINVAL;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 	mt76x02_mac_set_tx_protection(dev, val);
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
-- 
2.19.1

