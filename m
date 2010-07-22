Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:24394 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758970Ab0GVIws (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 04:52:48 -0400
Subject: Re: [PATCH] wl1251: fix sparse-generated warnings
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Kalle Valo <kvalo@adurom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C48053A.6080504@adurom.com>
References: <1279729917-4451-1-git-send-email-linville@tuxdriver.com>
	 <4C48053A.6080504@adurom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 11:52:19 +0300
Message-ID: <1279788739.2322.39.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-22 at 10:45 +0200, ext Kalle Valo wrote:
> Hi John,
> 
> On 07/21/2010 06:31 PM, John W. Linville wrote:
> > @@ -225,7 +225,7 @@ static void wl1251_boot_set_ecpu_ctrl(struct wl1251 *wl, u32 flag)
> >  int wl1251_boot_run_firmware(struct wl1251 *wl)
> >  {
> >  	int loop, ret;
> > -	u32 chip_id, interrupt;
> > +	u32 chip_id, acx_intr;
> 
> I don't get why you did this change. I don't object renaming the
> variable, but I can't figure out the reasoning behind it.

Sparse complains that interrupt is shadowing the definition in hw_irq.h:

> drivers/net/wireless/wl12xx/wl1251_boot.c:228:22: warning: symbol
> 'interrupt' shadows an earlier one
> /home/linville/git/wireless-next-2.6/arch/x86/include/asm/hw_irq.h:132:13: originally declared here

So, it's just a cosmetic change, I guess.


-- 
Cheers,
Luca.

