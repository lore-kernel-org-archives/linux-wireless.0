Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55386 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab2JQXuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2012 19:50:40 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so3856049bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2012 16:50:38 -0700 (PDT)
Message-ID: <507F4448.2040707@gmail.com> (sfid-20121018_015053_792161_D46CFF48)
Date: Thu, 18 Oct 2012 01:50:32 +0200
From: Daniel Mack <zonque@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: mwifiex_sdio problem: firmware fails to be active in time
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we're trying to get a SD8787 to play which is connected via SDIO to an
OMAP hsmmc (AM33xx hardware). This fails with the following message:

# modprobe mwifiex_sdio
[   13.984779] [sched_delayed] sched: RT throttling activated
[   22.401700] mwifiex_sdio mmc0:0001:1: FW failed to be active in time

The firmware sd8787_uapsta.bin was taken from the linux-firmware.git and
apparently is transferred successfully, but then consequently fails to
do start up. When compiled with CONFIG_MMC_CONFIG=y, tons of successful
messages are logged like this:

[ 2607.867660] mmc0: starting CMD52 arg 00000a00 flags 00000195
[ 2607.867713] mmc0: req done (CMD52): 0: 00001000 00000000 00000000
00000000
[ 2607.883273] mmc0: starting CMD52 arg 00000a00 flags 00000195
[ 2607.883327] mmc0: req done (CMD52): 0: 00001000 00000000 00000000
00000000
[ 2607.898905] mmc0: starting CMD52 arg 00000a00 flags 00000195


The kernel we're based on is Linus' current merge tree (3.7-rc1), but
earlier version (3.6) have shown the same issue.

Before we start digging into this, I want to ask whether there are any
common pitfalls we should be aware of and that could cause this?

Please let me know whether you need any further information.


Many thanks,
Daniel
