Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54936 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbZBJPWx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 10:22:53 -0500
Subject: Re: wl12xx: driver for TI wl1251 chipset
From: Dan Williams <dcbw@redhat.com>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org, luciano.coelho@nokia.com
In-Reply-To: <87iqnishuj.fsf@nokia.com>
References: <87iqnishuj.fsf@nokia.com>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 10:21:19 -0500
Message-Id: <1234279279.3119.12.camel@localhost> (sfid-20090210_162257_196997_294F76FC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-02-10 at 12:32 +0200, Kalle Valo wrote:
> Hello all,
> 
> in Nokia we have been working on a mac80211 driver for TI wl1251
> chipset. We named it as wl12xx, and in the future we are planning to
> add wl1271 support to the driver as well.
> 
> wl1251 is a chipset for embedded devices, supporting both SDIO and SPI
> busses. Currently the driver supports only SPI. Adding support 1253
> (the 5 GHz version) should be relatively easy. More information here:
> 
> http://focus.ti.com/general/docs/wtbu/wtbuproductcontent.tsp?contentId=4711&navigationId=12494&templateId=6123
> 
> Because the patch is over 200 KB, the driver is temporarily available
> from my server:
> 
> http://www.valot.fi/kalle/tmp/wl12xx/wl12xx-2.6.28-1.patch
> 
> The patch is against linux-2.6.28-omap1 tag available here:
> 
> http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap-2.6.git;a=commit;h=0ec95b96fd77036a13398c66901e11cd301190d0
> 
> Currently known issues:
> 
> o short slot and preamble support missing
> o rts/cts and cts-to-self missing
> o no proper bitrate control support
> o using deprecated omap_get_config(), need to convert to use platform_data
> o firmware wakeup not working, deepest sleep state in firmware not yet
>   enabled
> 
> Also the driver has a netlink interface which is used for running
> production line tests and pushing the calibration data from user
> space.

When is the calibration data required, and is it likely to change at
runtime?  What I really mean is, if the calibration data isn't required
to change while the interface is up, maybe use request_firmware() and
load it at device open time or something?

Dan


