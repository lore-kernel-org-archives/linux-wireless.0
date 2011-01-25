Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40303 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1AYWAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 17:00:10 -0500
Date: Tue, 25 Jan 2011 16:58:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: use DECLARE_EVENT_CLASS
Message-ID: <20110125215810.GE2927@tuxdriver.com>
References: <1295437859.4685.4.camel@jlt3.sipsolutions.net>
 <20110121212447.GB7092@tuxdriver.com>
 <1295777573.3639.30.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1295777573.3639.30.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 23, 2011 at 11:12:53AM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> For events that include only the local struct as
> their parameter, we can use DECLARE_EVENT_CLASS
> and save quite some binary size across segments
> as well lines of code.
> 
>    text	   data	    bss	    dec	    hex	filename
>  375745	  19296	    916	 395957	  60ab5	mac80211.ko.before
>  367473	  17888	    916	 386277	  5e4e5	mac80211.ko.after
>   -8272   -1408       0   -9680   -25d0 delta
> 
> Some more tracepoints with identical arguments
> could be combined like this but for now this is
> the one that benefits most.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

OK, so what am I doing wrong?

Kernel: arch/x86/boot/bzImage is ready  (#11)
  Building modules, stage 2.
  MODPOST 2218 modules
ERROR: "__tracepoint_drv_return_void" [net/mac80211/mac80211.ko] undefined!
ERROR: "__tracepoint_api_remain_on_channel_expired" [net/mac80211/mac80211.ko] undefined!
ERROR: "__tracepoint_drv_get_tsf" [net/mac80211/mac80211.ko] undefined!
ERROR: "__tracepoint_drv_tx_last_beacon" [net/mac80211/mac80211.ko] undefined!
ERROR: "__tracepoint_drv_reset_tsf" [net/mac80211/mac80211.ko] undefined!
ERROR: "__tracepoint_drv_stop" [net/mac80211/mac80211.ko] undefined!
ERROR: "__tracepoint_drv_sw_scan_start" [net/mac80211/mac80211.ko] undefined!
ERROR: "__tracepoint_drv_sw_scan_complete" [net/mac80211/mac80211.ko] undefined!
ERROR: "__tracepoint_api_restart_hw" [net/mac80211/mac80211.ko] undefined!
ERROR: "__tracepoint_api_ready_on_channel" [net/mac80211/mac80211.ko] undefined!
ERROR: "__tracepoint_drv_cancel_remain_on_channel" [net/mac80211/mac80211.ko] undefined!
ERROR: "__tracepoint_drv_start" [net/mac80211/mac80211.ko] undefined!
WARNING: modpost: Found 5 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
