Return-Path: <SRS0=f6eh=ZE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7DCC17440
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Nov 2019 21:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE8FE20679
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Nov 2019 21:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfKLVL3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Nov 2019 16:11:29 -0500
Received: from ns.lynxeye.de ([87.118.118.114]:49874 "EHLO lynxeye.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727205AbfKLVL3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Nov 2019 16:11:29 -0500
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Nov 2019 16:11:28 EST
Received: by lynxeye.de (Postfix, from userid 501)
        id 15243E74222; Tue, 12 Nov 2019 22:02:27 +0100 (CET)
Received: from radon.fritz.box (a89-183-40-51.net-htp.de [89.183.40.51])
        by lynxeye.de (Postfix) with ESMTPSA id 3CE9CE74217;
        Tue, 12 Nov 2019 22:02:26 +0100 (CET)
Message-ID: <5de65447f1d115f436f764a7ec811c478afbe2e0.camel@lynxeye.de>
Subject: long delays in rtl8723 drivers in irq disabled sections
From:   Lucas Stach <dev@lynxeye.de>
To:     wlanfae@realtek.com, Ping-Ke Shih <pkshih@realtek.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 12 Nov 2019 22:02:25 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi all,

while investigating some latency issues on my laptop I stumbled across
quite large delays in the rtl8723 PHY code, which are done in IRQ
disabled atomic sections, which is blocking IRQ servicing for all
devices in the system.

Specifically there are 3 consecutive 1ms delays in
rtl8723_phy_rf_serial_read(), which is used in an IRQ disabled call
path. Sadly those delays don't have any comment in the code explaining
why they are needed. I hope that anyone can tell if those delays are
strictly neccessary and if so if they really need to be this long.

Regards,
Lucas

