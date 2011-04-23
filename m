Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58115 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab1DWMku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Apr 2011 08:40:50 -0400
Received: by wya21 with SMTP id 21so832603wya.19
        for <linux-wireless@vger.kernel.org>; Sat, 23 Apr 2011 05:40:49 -0700 (PDT)
Subject: Re: [PATCH 4/4] iwlwifi: split the drivers for agn and legacy
 devices 3945/4965
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
In-Reply-To: <1303558517.8537.7.camel@maxim-laptop>
References: <1298315209-17986-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1298315209-17986-5-git-send-email-wey-yi.w.guy@intel.com>
	 <1303558517.8537.7.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Apr 2011 15:40:44 +0300
Message-ID: <1303562444.11751.6.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-04-23 at 14:35 +0300, Maxim Levitsky wrote:
> On Mon, 2011-02-21 at 11:06 -0800, Wey-Yi Guy wrote:
> > From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
> > 
> > Intel WiFi devices 3945 and 4965 now have their own driver in the folder
> > 
> > 	drivers/net/wireless/iwlegacy
> > 
> > Add support to build these drivers independently of the driver for
> > AGN devices. Selecting the 3945 builds iwl3945.ko and iwl_legacy.ko,
> > and selecting the 4965 builds iwl4965.ko and iwl_legacy.ko. iwl-legacy.ko
> > contains code shared between both devices.
> > 
> > The 3945 is an ABG/BG device, with no support for 802.11n. The 4965 is a 2x3
> > ABGN device.
> 
> This one came to me as a surprise, I updated the kernel, and whoops, the
> wireless led, blinks all the time!
> It turns out that in splitted driver iwl3945 doesn't have any led
> support, and indeed the light on my notebook doesn't change state often.
> It ether doesn't light up at all, or just blinks at constant rate.
OK, found the cause, it is dead simple, and in fact affects all intel
wireless card.
I wonder how such bug could escape unnoticed.
Nobody uses linux these days I guess.... :-(


The problem is in iwl-led.c in both drivers.
It defines a blink table for new generi rate based blink support (yay!)
but first entry is negative, and code in mac layer uses it.
Why? Beats me.

The code in mac does this:

	on = 1;
	off = 0;

	for (i = tpt_trig->blink_table_len - 1; i >= 0; i--) {
		if (tpt_trig->blink_table[i].throughput < 0 ||
		    tpt > tpt_trig->blink_table[i].throughput) {
			off = tpt_trig->blink_table[i].blink_time / 2;
			on = tpt_trig->blink_table[i].blink_time - off;
			break;
		}
	}


So it takes ether entry that is smaller that current one or negative,
and iterates from end to start.




I am note sure why you have the X - 1 pattern in the iwl-led.c
Not sending a patch because not sure what were the intentions of this
code.
For me removing -1s works fine.


-- 
Best regards,
        Maxim Levitsky

Visit my blog: http://maximlevitsky.wordpress.com
Warning: Above blog contains rants.

