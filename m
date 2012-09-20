Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40639 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab2ITPNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 11:13:30 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20571.12875.594812.396218@gargle.gargle.HOWL> (sfid-20120920_171334_441130_A72F6917)
Date: Thu, 20 Sep 2012 20:42:11 +0530
To: Luiz Ramos <lramos.prof@yahoo.com.br>
CC: <linux-wireless@vger.kernel.org>
Subject: Atheros AR9485 receiving error -5 in init
In-Reply-To: <1348073684.14711.140661130028433.035E90DC@webmail.messagingengine.com>
References: <1348073684.14711.140661130028433.035E90DC@webmail.messagingengine.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luiz Ramos wrote:
> Hello,
> 
> Recently I changed the laptop, and there's something wrong with the new
> Wifi adapter, which is an Atheros AR9485. Now, when I do modprobe ath9k,
> a message like this is registered in dmesg:
> 
>   ath9k: probe of 0000:04:00.0 failed with error -5
> 
> The OS installed in that machine is a Slackware 13.37 with the stock
> kernel. I've tried, following some google research, using the
> compatibility backport kit. I've downloaded some versions, but now I
> stick with compat-wireless-3.5.3-2-sn in order to eliminate variables.
> 
> After some turns, I've put some printk() in
> drivers/net/wireless/ath/ath9k/hw.c, and my final conclusion is that the
> time is running out in the routine ath_hw_wait() when waiting for the
> register 0x7044 have some value, like showed by one message raised by
> one of the printk() inserted in the code:
> 
>   ath9k_hw_wait(): ret=0(timeout (100000 us) on reg 0x7044: 0xffffffff &
>   0x0000000f != 0x00000002)

Can you attach the output of lspci -vv and lsusb -v ?

Sujith

