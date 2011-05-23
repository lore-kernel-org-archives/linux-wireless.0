Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48679 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab1EWQta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 12:49:30 -0400
Received: by vws1 with SMTP id 1so4239763vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 09:49:29 -0700 (PDT)
Message-ID: <4DDA9016.3090701@lwfinger.net> (sfid-20110523_184933_873750_2970A4D9)
Date: Mon, 23 May 2011 11:49:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike McCormack <mikem@ring3k.org>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/8] rtl8192ce stability improvements
References: <4DDA66D5.2090801@ring3k.org>
In-Reply-To: <4DDA66D5.2090801@ring3k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2011 08:53 AM, Mike McCormack wrote:
> The following patch series is aimed at improving the stability
> of the rtl8192ce driver, with a bit of cleanup thrown in.
>
> thanks,
>
> Mike
>
> Mike McCormack (8):
>    rtlwifi: Synchronize IRQ after disabling it
>    rtlwifi: Remove set_rfpowerstate_inprogress
>    rtlwifi: Store loop index in local variable
>    rtlwifi: Run IPS leave work in a tasklet
>    rtlwifi: Don't block interrupts in spinlocks
>    rtlwifi: Assign rx buffer ownership to hardware last
>    rtlwifi: Use write barrier when assigning ownership
>    rtlwifi: Fix logic in rx_interrupt
>
>   drivers/net/wireless/rtlwifi/pci.c           |   41 ++++++++++++++----------
>   drivers/net/wireless/rtlwifi/ps.c            |   45 +++++++++++---------------
>   drivers/net/wireless/rtlwifi/rtl8192ce/hw.c  |    1 +
>   drivers/net/wireless/rtlwifi/rtl8192ce/phy.c |   12 ++----
>   drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |    2 +
>   drivers/net/wireless/rtlwifi/rtl8192cu/phy.c |    2 -
>   drivers/net/wireless/rtlwifi/rtl8192se/phy.c |   14 ++------
>   drivers/net/wireless/rtlwifi/wifi.h          |    2 +-
>   8 files changed, 55 insertions(+), 64 deletions(-)

Thanks for your changes. I have not yet tested them, but I noticed a few points 
that I want you to address.

Are you using wireless-testing for your patches? There are some patches pending 
in John's queue, but your patches got offsets and fuzz in files that those 
patches do not touch. Everything seemed to apply despite the fuzz and everything 
compiled, but I always get nervous about patches with anything more serious than 
offsets.

Patches 3, 4, 6 and 8 do modify driver rtlwifi, but patches 1 and 7 change 
driver rtl8192ce. Similarly, #2 changes rtl8192ce, rtl8192cu, and rtl8192se, and 
#5 changes rtl8192ce and rtl8192se. The subject line for the patch should 
indicate the driver that gets modified. I usually do it as "rtlwifi: rtl8192ce: 
blah-blah", etc. The rtlwifi is included even though it does not get changed by 
the patch.

I do not see anything serious in the body of the patches and I expect that I 
will be giving them an ACK, but I want to test first.

Thanks,

Larry
