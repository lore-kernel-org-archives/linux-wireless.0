Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:41833 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZGXQWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 12:22:38 -0400
Received: by qyk34 with SMTP id 34so343527qyk.33
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 09:22:38 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 24 Jul 2009 09:22:18 -0700
Message-ID: <43e72e890907240922q3d7c9f0agfc8479008f9ba959@mail.gmail.com>
Subject: wireless drivers sparse warnings 07-24
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: dsd@gentoo.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't usually have these enabled but today I did so I figured I'd
report these.

  CHECK   drivers/net/wireless/mwl8k.c
drivers/net/wireless/mwl8k.c:1595:16: warning: incorrect type in
assignment (different address spaces)
drivers/net/wireless/mwl8k.c:1595:16:    expected unsigned short
[noderef] [usertype] <asn:2>*result
drivers/net/wireless/mwl8k.c:1595:16:    got unsigned short *<noident>
drivers/net/wireless/mwl8k.c:1606:23: warning: dereference of noderef expression
drivers/net/wireless/mwl8k.c:1611:33: warning: dereference of noderef expression

  CHECK   drivers/net/wireless/rtl818x/rtl8180_rtl8225.c
drivers/net/wireless/rtl818x/rtl8180_rtl8225.c:53:33: warning: dubious: x | !y

  CC [M]  drivers/net/wireless/iwlwifi/iwl-core.o
drivers/net/wireless/iwlwifi/iwl-core.c:1341: warning:
‘iwl_dump_nic_error_log’ defined but not used

  CHECK   drivers/net/wireless/b43/phy_g.c
drivers/net/wireless/b43/phy_g.c:974:56: warning: cast truncates bits
from constant value (ffff7fff becomes 7fff)

  CHECK   drivers/net/wireless/b43/wa.c
drivers/net/wireless/b43/wa.c:385:60: warning: cast truncates bits
from constant value (ffff00ff becomes ff)
drivers/net/wireless/b43/wa.c:403:55: warning: cast truncates bits
from constant value (ffff00ff becomes ff)
drivers/net/wireless/b43/wa.c:405:55: warning: cast truncates bits
from constant value (ffff00ff becomes ff)
drivers/net/wireless/b43/wa.c:415:71: warning: cast truncates bits
from constant value (ffff0fff becomes fff)

  CHECK   drivers/net/wireless/zd1211rw/zd_usb.c
drivers/net/wireless/zd1211rw/zd_usb.c:367:24: warning: implicit cast
from nocast type

I last tried to address this last one with Dan but I forget where we ended up.

  Luis
