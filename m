Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48142 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755847Ab2ISQyp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 12:54:45 -0400
Message-Id: <1348073684.14711.140661130028433.035E90DC@webmail.messagingengine.com> (sfid-20120919_185449_641918_5AA9F4A1)
From: Luiz Ramos <lramos.prof@yahoo.com.br>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Subject: Atheros AR9485 receiving error -5 in init
Date: Wed, 19 Sep 2012 13:54:44 -0300
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Recently I changed the laptop, and there's something wrong with the new
Wifi adapter, which is an Atheros AR9485. Now, when I do modprobe ath9k,
a message like this is registered in dmesg:

  ath9k: probe of 0000:04:00.0 failed with error -5

The OS installed in that machine is a Slackware 13.37 with the stock
kernel. I've tried, following some google research, using the
compatibility backport kit. I've downloaded some versions, but now I
stick with compat-wireless-3.5.3-2-sn in order to eliminate variables.

After some turns, I've put some printk() in
drivers/net/wireless/ath/ath9k/hw.c, and my final conclusion is that the
time is running out in the routine ath_hw_wait() when waiting for the
register 0x7044 have some value, like showed by one message raised by
one of the printk() inserted in the code:

  ath9k_hw_wait(): ret=0(timeout (100000 us) on reg 0x7044: 0xffffffff &
  0x0000000f != 0x00000002)

That is, the register has 0xffffffff, that when masked with 0x0f leads
to 0x0f, which is not the expected value 0x02.

There's also one key combination (Fn-F12), which seems to enable/disable
the wifi adapter, but it seems not to change anything.

(I think I would not mention that with Windows everything works, but
this may be a concern in a first level of analysis. Please don't
flame...).

Please could someone give me some hint?

Thanks,

Luiz Ramos
São Paulo - Brazil
lramos dot prof at yahoo dot com dot br
