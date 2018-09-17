Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54392 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbeIQWBO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 18:01:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id c14-v6so10396355wmb.4
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2018 09:33:07 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id c3-v6sm17807307wrm.56.2018.09.17.09.33.05
        for <linux-wireless@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 17 Sep 2018 09:33:06 -0700 (PDT)
From: =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] rt2x00: update TX_SW_CFG2 value
Date: Mon, 17 Sep 2018 18:32:55 +0200
Message-Id: <1537201975-3032-5-git-send-email-pozega.tomislav@gmail.com> (sfid-20180917_183319_468266_3FC705E1)
In-Reply-To: <1537201975-3032-1-git-send-email-pozega.tomislav@gmail.com>
References: <1537201975-3032-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use default value of TX_SW_CFG2 register that is in charge
of LNA timings. Works for somewhat higher RX throughput.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index a5eb17a..c5d0fb1 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5324,7 +5324,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	} else if (rt2x00_rt(rt2x00dev, RT6352)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000401);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x000C0000);
-		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x000C0408);
 		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
 		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
 		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x06060606);
-- 
1.7.0.4
