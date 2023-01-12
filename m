Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86D1C54EBC
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Jan 2023 12:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbjALMGT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 12 Jan 2023 07:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbjALMFV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2023 07:05:21 -0500
X-Greylist: delayed 66 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 Jan 2023 04:00:08 PST
Received: from exchange.fintech.ru (exchange.fintech.ru [195.54.195.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C68E3739B
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2023 04:00:08 -0800 (PST)
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.159) with Microsoft SMTP Server (TLS) id 14.3.498.0; Thu, 12 Jan
 2023 14:58:59 +0300
Received: from localhost (10.0.253.157) by Ex16-01.fintech.ru (10.0.10.18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Thu, 12 Jan
 2023 14:58:58 +0300
From:   Nikita Zhandarovich <n.zhandarovich@fintech.ru>
To:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Alexey Khoroshilov" <khoroshilov@ispras.ru>,
        <lvc-project@linuxtesting.org>
Subject: [PATCH 5.10 0/1] mt76: move mt76_init_tx_queue in common code
Date:   Thu, 12 Jan 2023 03:58:49 -0800
Message-ID: <20230112115850.9208-1-n.zhandarovich@fintech.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.0.253.157]
X-ClientProxiedBy: Ex16-01.fintech.ru (10.0.10.18) To Ex16-01.fintech.ru
 (10.0.10.18)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Svace has identified unchecked return value of mt7615_init_tx_queue
function in 5.10 branch, even though it makes sense to track it
instead. This issue is fixed in upstream version by Lorenzo's patch.

The same patch can be cleanly applied to the 5.10 branch.

Found by Linux Verification Center (linuxtesting.org) with SVACE.
