Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50875 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbZKDPPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 10:15:10 -0500
Date: Wed, 4 Nov 2009 10:11:33 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>, sidhayn@gmail.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix kernel oops when device is removed when
	LEDS enabled (Bugzilla #14539)
Message-ID: <20091104151132.GD12965@tuxdriver.com>
References: <4af11879./IumKJ+RAbw7Zkq6%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4af11879./IumKJ+RAbw7Zkq6%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 04, 2009 at 12:00:25AM -0600, Larry Finger wrote:
> As reported by Rick Farina (sidhayn@gmail.com), removing the RTL8187 USB
> stick, or unloading the driver rtl8187 using rmmod will cause a kernel oops.
> There are at least two forms of the failure, (1) BUG: Scheduling while atomic,
> and (2) a fatal kernel page fault. This problem is reported in Bugzilla #14539.
> 
> This problem does not occur for kernel 2.6.31, but does for 2.6.32-rc2, thus
> it is technically a regression; however, bisection did not locate any faulty
> patch. The fix was found by comparing the faulty code in rtl8187 with p54usb.
> My interpretation is that the handling of work queues in mac80211 changed
> enough to the LEDs to be unregistered before tasks on the work queues are
> cancelled. Previously, these actions could be done in either order.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Reported-and-tested by: Rick Farina <sidhayn@gmail.com>
> ---
> 
> John,
> 
> This is 2.6.32 material. Sorry to take so long to get a patch, but it was
> difficult for me to locate the problem. Fortunately, I had the postings of the
> two flame wars to amuse me while all the kernel compilations were happening.
> 
> Larry
> ---
> 
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_leds.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
> @@ -210,10 +210,10 @@ void rtl8187_leds_exit(struct ieee80211_
>  
>  	/* turn the LED off before exiting */
>  	ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
> -	cancel_delayed_work_sync(&priv->led_off);
> -	cancel_delayed_work_sync(&priv->led_on);
>  	rtl8187_unregister_led(&priv->led_rx);
>  	rtl8187_unregister_led(&priv->led_tx);
> +	cancel_delayed_work_sync(&priv->led_off);
> +	cancel_delayed_work_sync(&priv->led_on);
>  }
>  #endif /* def CONFIG_RTL8187_LED */
>  

This seems like a band-aid.  If anything, the original order would
seem to make more sense.

Do you have a link to the original backtrace?  I don't see one in
the bugzilla entry.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
