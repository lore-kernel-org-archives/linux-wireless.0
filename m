Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56594 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145Ab1DWQG3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Apr 2011 12:06:29 -0400
Subject: Re: [PATCH 4/4] iwlwifi: split the drivers for agn and legacy
 devices 3945/4965
From: wwguy <wey-yi.w.guy@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
In-Reply-To: <1303562444.11751.6.camel@maxim-laptop>
References: <1298315209-17986-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1298315209-17986-5-git-send-email-wey-yi.w.guy@intel.com>
	 <1303558517.8537.7.camel@maxim-laptop>
	 <1303562444.11751.6.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Apr 2011 09:03:37 -0700
Message-ID: <1303574617.10937.4.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Maxim

On Sat, 2011-04-23 at 05:40 -0700, Maxim Levitsky wrote:
> On Sat, 2011-04-23 at 14:35 +0300, Maxim Levitsky wrote:
> > On Mon, 2011-02-21 at 11:06 -0800, Wey-Yi Guy wrote:

> OK, found the cause, it is dead simple, and in fact affects all intel
> wireless card.
> I wonder how such bug could escape unnoticed.
> Nobody uses linux these days I guess.... :-(
> 
> 
> The problem is in iwl-led.c in both drivers.
> It defines a blink table for new generi rate based blink support (yay!)
> but first entry is negative, and code in mac layer uses it.
> Why? Beats me.
> 
> The code in mac does this:
> 
> 	on = 1;
> 	off = 0;
> 
> 	for (i = tpt_trig->blink_table_len - 1; i >= 0; i--) {
> 		if (tpt_trig->blink_table[i].throughput < 0 ||
> 		    tpt > tpt_trig->blink_table[i].throughput) {
> 			off = tpt_trig->blink_table[i].blink_time / 2;
> 			on = tpt_trig->blink_table[i].blink_time - off;
> 			break;
> 		}
> 	}
> 
> 
> So it takes ether entry that is smaller that current one or negative,
> and iterates from end to start.
> 
> 
> 
> 
> I am note sure why you have the X - 1 pattern in the iwl-led.c
> Not sending a patch because not sure what were the intentions of this
> code.
> For me removing -1s works fine.
> 
> 
Good catch, thanks, this behavior changed was cause by
commit 843f26f06a41c5797f19e843c23ca4ed2a71a0bc
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Wed Dec 15 07:30:01 2010 -0800

    iwlwifi: use mac80211 throughput trigger

-static const struct {
-       u16 tpt;        /* Mb/s */
-       u8 on_time;
-       u8 off_time;
-} blink_tbl[] =
-{
-       {300, 25, 25},
-       {200, 40, 40},
-       {100, 55, 55},
-       {70, 65, 65},
-       {50, 75, 75},
-       {20, 85, 85},
-       {10, 95, 95},
-       {5, 110, 110},
-       {1, 130, 130},
-       {0, 167, 167},
-       /* SOLID_ON */
-       {-1, IWL_LED_SOLID, 0}
+static const struct ieee80211_tpt_blink iwl_blink[] = {
+       { .throughput = 0 * 1024 - 1, .blink_time = 334 },
+       { .throughput = 1 * 1024 - 1, .blink_time = 260 },
+       { .throughput = 5 * 1024 - 1, .blink_time = 220 },
+       { .throughput = 10 * 1024 - 1, .blink_time = 190 },
+       { .throughput = 20 * 1024 - 1, .blink_time = 170 },
+       { .throughput = 50 * 1024 - 1, .blink_time = 150 },
+       { .throughput = 70 * 1024 - 1, .blink_time = 130 },
+       { .throughput = 100 * 1024 - 1, .blink_time = 110 },
+       { .throughput = 200 * 1024 - 1, .blink_time = 80 },
+       { .throughput = 300 * 1024 - 1, .blink_time = 50 },
 };

For negative, the LED should be SOLID_ON.
I will push patch to fix this.

ALso, I agree both _agn and 3945/4965 use the same "iwl_led.c" is
confuse. I will change that.

Thanks


