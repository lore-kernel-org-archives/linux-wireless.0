Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32897 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbbG3LlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 07:41:14 -0400
Received: by padck2 with SMTP id ck2so22458974pad.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2015 04:41:13 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [RESEND V2 0/3] cover letter of wilc1000 patches
Date: Thu, 30 Jul 2015 20:41:02 +0900
Message-Id: <1438256465-19540-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150730_134117_507294_CD270AAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Greg

I'm sorry that I did not say whether GFP_ATOMIC should be used or not.
This is my review on it. If it's not correct, please give me any comment or direction.

First patch has 4 sites of kmalloc change in coreconfigurator.c
First one, it is used for gps8ConfigPacket at CoreconfiguratorInit and CoreConfiguratorDeInit.
I think it should be removed next time because I cannot find anywhere to use it.
Then, it is okay to change flag as GFP_KERNEL.

Other three changes are used to handle host interface message within a kernel thread.
The manipulation of host interface message is not called on IRQ context and I could not
find any spin lock inside function.

If this patches are accepted, I will try to continue to change WILC_MALLOC macro as kmalloc.
I always appreciate your comment and advice.

Thanks
Chaehyun Lim


Chaehyun Lim (3):
  staging: wilc1000: coreconfigurator.c: remove WILC_MALLOC
  staging: wilc1000: coreconfigurator.c: add kmalloc error check
  staging: wilc1000: coreconfigurator.c: fix kmalloc error check

 drivers/staging/wilc1000/coreconfigurator.c | 38 +++++++++++++++++------------
 1 file changed, 23 insertions(+), 15 deletions(-)

-- 
1.9.1

