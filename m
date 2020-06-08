Return-Path: <SRS0=eW0r=7W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B42C433E0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Jun 2020 01:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4412D2076C
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Jun 2020 01:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591665060;
	bh=JrvphMfoqQIUMDepOvQOrRqazbu+04kxc3ja68COgyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sxAHzlD5fF/69oZrTUJxK6Auk43yyzisB8iGslFg01nr1ra8BUpaGPfahKvCMY6eV
	 HSTfh89fqZDoh1xcQAZUxX0FXKl9beXILgh9OnQOFWhuIDw7MjztKq2WXazIPgJeFS
	 yxcxHJI4ET/5GH7n6WCf/zzPES9FuE5JqbvNHeKs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729721AbgFIBKv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Jun 2020 21:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbgFHXGN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jun 2020 19:06:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5112A20801;
        Mon,  8 Jun 2020 23:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657572;
        bh=JrvphMfoqQIUMDepOvQOrRqazbu+04kxc3ja68COgyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yXakXsZ10iXu622Mg1bWNHDxKQ0gCvF7WpcpB1zyyWHfUi2uSjeHgFO+W67/ouvgj
         E/GLA8RE4L6vVgenuXDj4C9mtKCWl12uW6iKiDaEj1AZktPjA9zZW1U3+UFEz5OcNg
         iQktpl1T1T76zwYfMceBsSJXpbPdgJGX6fQ+3P5w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiujun Huang <hqjagain@gmail.com>,
        syzbot+d403396d4df67ad0bd5f@syzkaller.appspotmail.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 003/274] ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
Date:   Mon,  8 Jun 2020 19:01:36 -0400
Message-Id: <20200608230607.3361041-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

[ Upstream commit 19d6c375d671ce9949a864fb9a03e19f5487b4d3 ]

Add barrier to accessing the stack array skb_pool.

The case reported by syzbot:
https://lore.kernel.org/linux-usb/0000000000003d7c1505a2168418@google.com
BUG: KASAN: stack-out-of-bounds in ath9k_hif_usb_rx_stream
drivers/net/wireless/ath/ath9k/hif_usb.c:626 [inline]
BUG: KASAN: stack-out-of-bounds in ath9k_hif_usb_rx_cb+0xdf6/0xf70
drivers/net/wireless/ath/ath9k/hif_usb.c:666
Write of size 8 at addr ffff8881db309a28 by task swapper/1/0

Call Trace:
ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:626
[inline]
ath9k_hif_usb_rx_cb+0xdf6/0xf70
drivers/net/wireless/ath/ath9k/hif_usb.c:666
__usb_hcd_giveback_urb+0x1f2/0x470 drivers/usb/core/hcd.c:1648
usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1713
dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
expire_timers kernel/time/timer.c:1449 [inline]
__run_timers kernel/time/timer.c:1773 [inline]
__run_timers kernel/time/timer.c:1740 [inline]
run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786

Reported-and-tested-by: syzbot+d403396d4df67ad0bd5f@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200404041838.10426-5-hqjagain@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index dd0c32379375..c4a2b7201ce3 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -612,6 +612,11 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 			hif_dev->remain_skb = nskb;
 			spin_unlock(&hif_dev->rx_lock);
 		} else {
+			if (pool_index == MAX_PKT_NUM_IN_TRANSFER) {
+				dev_err(&hif_dev->udev->dev,
+					"ath9k_htc: over RX MAX_PKT_NUM\n");
+				goto err;
+			}
 			nskb = __dev_alloc_skb(pkt_len + 32, GFP_ATOMIC);
 			if (!nskb) {
 				dev_err(&hif_dev->udev->dev,
-- 
2.25.1

