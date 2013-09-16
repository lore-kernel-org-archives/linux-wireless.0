Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:44898 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3IPOfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 10:35:08 -0400
Received: by mail-oa0-f44.google.com with SMTP id g12so69339oah.3
        for <linux-wireless@vger.kernel.org>; Mon, 16 Sep 2013 07:35:07 -0700 (PDT)
Date: Mon, 16 Sep 2013 09:35:06 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jason Andrews <jasona@cadence.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: guidance on struct alignment for rtl8192cu driver
Message-ID: <20130916143506.GC18593@thinkpad-t410> (sfid-20130916_163513_080833_1D9389B1)
References: <985A2B0C3F73B74792F35D4098E1CA7CB143670E93@MAILSJ3.global.cadence.com>
 <52346DE2.9090904@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52346DE2.9090904@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 14, 2013 at 09:08:34AM -0500, Larry Finger wrote:
> On 09/14/2013 12:36 AM, Jason Andrews wrote:
> >I'm using an ASUS USB N13 on an ARM platform with the rtl8192cu driver.
> >Linux kernel is 3.10 so I probably don't have the latest and greatest driver.
> >
> >When I booted I got an ARM alignment trap caused by the driver.
> >
> >I determined the cause was the 1st argument to spin_lock_irqsave() has an unaligned address.
> >
> >By trial-and-error I found that if I edit wifi.h and insert 2 dummy bytes into the rtl_priv struct just above priv (last variable) the locks work and the driver works fine.
> >
> >What is the recommended way to make sure the last variable in the rtl_priv struct (u8 priv[0]) is aligned on a 4 byte boundary so the driver works on ARM machines?
> 
> There are a lot of improvements for this driver in 3.11. The
> backports release has that code. In addition, I am currently working
> at improving the power management for 3.13.
> 
> The presence of unaligned variables that cause alignment traps on
> ARM does not surprise me as I test only on x86 and ppc
> architectures. I now own a Raspberry Pi and I will soon be testing
> with it as well.
> 
> What does surprise me is that the first argument in all the calls to
> spin_lock_irqsave() are contained within the rtl_locks struct and
> everything there should be aligned. Perhaps some ARM expert will
> know why aligning the last item in the rtl_priv struct fixes the
> problem.

Depending on architecture version and configuration ARM may or may not
allow unaligned accesses. Even when allowed there is a cost though, so
it's better to properly align the data. In the past this would have
always meant 4-byte alignment, but my ARM experience is a bit dated now
and I don't know about 64-bit ARM. That variable-size array probably
only has byte alignment.

> As far as I know, the proper way to do a 4-byte alignment is as in
> the following patch:
> 
> Index: wireless-testing-save/drivers/net/wireless/rtlwifi/wifi.h
> ===================================================================
> --- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/wifi.h
> +++ wireless-testing-save/drivers/net/wireless/rtlwifi/wifi.h
> @@ -2057,7 +2057,7 @@ struct rtl_priv {
>  	  that it points to the data allocated
>  	  beyond  this structure like:
>  	  rtl_pci_priv or rtl_usb_priv */
> -	u8 priv[0];
> +	u8 __aligned(4) priv[0];
>  };

__attribute__((aligned)) might be a safer bet, as this will align it to
the largest alignment that could possibly be needed.

Seth
