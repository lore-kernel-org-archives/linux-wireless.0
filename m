Return-Path: <SRS0=mdyG=NV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC705C43441
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Nov 2018 11:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7229020883
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Nov 2018 11:03:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7229020883
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbeKJUr6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 10 Nov 2018 15:47:58 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35055 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728888AbeKJUr6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Nov 2018 15:47:58 -0500
Received: by mail-wm1-f66.google.com with SMTP id t15-v6so4074965wmt.0
        for <linux-wireless@vger.kernel.org>; Sat, 10 Nov 2018 03:03:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lEoRejWiWB8Bhlv3bxF3xw1S7lqy9gl+UMepnvrDs/8=;
        b=HfAVYhmIv1s3gIYAWE/iWOM+wdNWzN4o+wgdKvyXaO/3zCpY/iC+548zwyVl1MCnUk
         82y3R1Tg2sWEQbS/Wxb2PYJDDz4F0EM/Ho+Jn2UhtPpygmi9E1cCutvyHYroEzPjNH1Z
         nbJ/6MxFt5skFw8Fggdozn3Y7o8NrJq+6QnE6fVFslOupF2jon/WOuvJY8b8l+m09jP1
         xVIXScdqbFquPTM6SjavCXzmQe4RaYdLw6BNXckWA/xZpE2fHdy/y5jBwkUqqkBWkqmf
         4fubJTAytcIJ6h67uL2ste7O2aImE2rwXxtTsnGHX++vscn1yu2aZDmkVXDRpFU5xSO2
         ZSmQ==
X-Gm-Message-State: AGRZ1gKUAUyHSsje+9gFAKmqa9swinriSckrET/yuB57GwUYlEIg5Dem
        AfHsYCRYOMgoPxVRcLBjBYjShQ==
X-Google-Smtp-Source: AJdET5ej+I+oOH3ugm3pMNlR0/MxdnDl5lOjs+rRVxjspizwBQ6P8whPX5+hpxOeRQmewmEqenGfgQ==
X-Received: by 2002:a1c:e714:: with SMTP id e20-v6mr2163612wmh.83.1541847802317;
        Sat, 10 Nov 2018 03:03:22 -0800 (PST)
Received: from localhost.localdomain ([151.66.8.224])
        by smtp.gmail.com with ESMTPSA id g5-v6sm11740790wrw.97.2018.11.10.03.03.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Nov 2018 03:03:21 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     kvalo@codeaurora.org
Cc:     nbd@nbd.name, sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] mt76: fix uninitialized mutex access setting rts threshold
Date:   Sat, 10 Nov 2018 12:03:09 +0100
Message-Id: <1cfa6dca73f1d81595f061ded6275293c6e96b75.1541847014.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1541847014.git.lorenzo.bianconi@redhat.com>
References: <cover.1541847014.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix following crash due to a leftover uninitialized mutex access
in mt76x2_set_rts_threshold routine.

[   31.018059] Call Trace:
[   31.018341]  register_lock_class+0x51f/0x530
[   31.018828]  __lock_acquire+0x6c/0x1580
[   31.019247]  lock_acquire+0x88/0x120
[   31.021089]  __mutex_lock+0x4a/0x4f0
[   31.023343]  mt76x2_set_rts_threshold+0x28/0x50
[   31.023831]  ieee80211_set_wiphy_params+0x16d/0x4e0
[   31.024344]  nl80211_set_wiphy+0x72b/0xbc0
[   31.024781]  genl_family_rcv_msg+0x192/0x3a0
[   31.025233]  genl_rcv_msg+0x42/0x89
[   31.026079]  netlink_rcv_skb+0x38/0x100
[   31.026475]  genl_rcv+0x1f/0x30
[   31.026804]  netlink_unicast+0x19c/0x250
[   31.027212]  netlink_sendmsg+0x1ed/0x390
[   31.027615]  sock_sendmsg+0x31/0x40
[   31.027973]  ___sys_sendmsg+0x23c/0x280
[   31.030414]  __sys_sendmsg+0x42/0x80
[   31.030783]  do_syscall_64+0x4a/0x170
[   31.031160]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   31.031677] RIP: 0033:0x7f3498b39ba7
[   31.033953] RSP: 002b:00007fffe19675b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[   31.034883] RAX: ffffffffffffffda RBX: 00000000012d5350 RCX: 00007f3498b39ba7
[   31.035756] RDX: 0000000000000000 RSI: 00007fffe19675f0 RDI: 0000000000000003
[   31.036587] RBP: 00000000012da740 R08: 0000000000000002 R09: 0000000000000000
[   31.037422] R10: 0000000000000006 R11: 0000000000000246 R12: 00000000012da880
[   31.038252] R13: 00007fffe19675f0 R14: 00007fffe19678c0 R15: 00000000012da880

Fixes: 108a4861ef19 ("mt76: create new mt76x02-lib module for common
mt76x{0,2} code")
Reported-by: lorenzo.trisolini@fluidmesh.com
Reported-by: luca.bisti@fluidmesh.com
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
This patch is for 4.20
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h         | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 47c42c607964..7806963b1905 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -71,7 +71,6 @@ struct mt76x02_dev {
 	struct mac_address macaddr_list[8];
 
 	struct mutex phy_mutex;
-	struct mutex mutex;
 
 	u8 txdone_seq;
 	DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76x02_tx_status);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 034a06295668..3f001bd6806c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -272,9 +272,9 @@ mt76x2_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
 	if (val != ~0 && val > 0xffff)
 		return -EINVAL;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 	mt76x2_mac_set_tx_protection(dev, val);
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
-- 
2.19.1

