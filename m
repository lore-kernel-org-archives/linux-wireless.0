Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65070 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab1DAOtq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 10:49:46 -0400
Received: by qwk3 with SMTP id 3so2185461qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 07:49:45 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 1 Apr 2011 16:49:45 +0200
Message-ID: <AANLkTikGp+ZFhTtsaW7E4SO_5trte1_eF4KLWbkwVty5@mail.gmail.com>
Subject: ChipCommon as independent driver?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I wanted to make ChipCommon independed, to make it usable with any
bus. The problem is:
void ssb_chipco_set_clockmode(struct ssb_chipcommon *cc, enum ssb_clkmode mode)

This function calls code from pci.c which gives us a loop:
WARNING: Module
/lib/modules/2.6.39-rc1-wl-wireless+/kernel/drivers/net/wireless/b43/b43.ko
ignored, due to loop
WARNING: Module
/lib/modules/2.6.39-rc1-wl-wireless+/kernel/drivers/ssb/ssb.ko
ignored, due to loop
WARNING: Loop detected:
/lib/modules/2.6.39-rc1-wl-wireless+/kernel/drivers/ssb/bcmcorecc.ko
needs ssb.ko which needs bcmcorecc.ko again!
WARNING: Module
/lib/modules/2.6.39-rc1-wl-wireless+/kernel/drivers/ssb/bcmcorecc.ko
ignored, due to loop

Do you have idea how we could nicely solve that issue?

-- 
Rafał
