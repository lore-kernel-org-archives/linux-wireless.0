Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:39656 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843Ab1BDOGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 09:06:15 -0500
Message-ID: <20110204160608.20567gbpmp95luq8@hayate.sektori.org>
Date: Fri, 04 Feb 2011 16:06:08 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [PATCH 00/22] zd1211rw: add support for AP-mode
References: <20110131184657.10044.98610.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Is this too much, should I split fixes (oops and device reset for  
TX-stall) to separate patchset?

OOPS fixed by first patch and TX-stall/device freeze under heavy load  
happens in station mode (and AP, probably adhoc too). Heavy load here  
means connected at rate 54Mbit, with iperf running both ways, freezes  
usually with in ~20 minutes.

-Jussi

Quoting Jussi Kivilinna <jussi.kivilinna@mbnet.fi>:

> This patchset adds AP-mode support to zd1211rw. Tested with zd1211b  
> devices only.
>
> Patches are mix of fixes and AP support adding code.
>    [1-2]  fix oopses noticed while testing
>      [3]  add missing locking
>      [4]  fix beacon setup to match vendor driver (needed for AP mode)
>    [5-6]  'may sleep' cleanups, move code from workers to mac80211-functions
>   [7-11]  AP-mode supporting code
>  [12-16]  beacon setup fixes/workarounds
>  [17-20]  device reset and device/TX/RX stall workarounds
>     [21]  enable AP mode
>     [22]  add more debuging output
>
> ---
>
> Christian Lamparter (1):
>       mac80211: fix race between next beacon dtim and  
> ieee80211_get_buffered_bc
>
> Jussi Kivilinna (21):
>       zd1211rw: use urb anchors for tx and fix tx-queue disabling
>       zd1211rw: cancel process_intr work on zd_chip_disable_int()
>       zd1211rw: add locking for mac->process_intr
>       zd1211rw: fix beacon interval setup
>       zd1211rw: move set_multicast_hash and set_rx_filter from  
> workers to configure_filter
>       zd1211rw: move set_rts_cts_work to bss_info_changed
>       zd1211rw: support setting BSSID for AP mode
>       zd1211rw: fix ack_pending in filter_ack causing tx-packet  
> ordering problem on monitor
>       zd1211rw: let zd_set_beacon_interval() set dtim_period and add  
> AP-beacon flag
>       zd1211rw: implement beacon fetching and handling  
> ieee80211_get_buffered_bc()
>       zd1211rw: add beacon watchdog and setting HW beacon more failsafe
>       zd1211rw: batch beacon config commands together
>       [v2] zd1211rw: use stack and preallocated memory for small cmd-buffers
>       zd1211rw: change interrupt URB buffer to DMA buffer
>       zd1211rw: lower hw command timeouts
>       zd1211rw: collect driver settings and add function to restore theim
>       zd1211rw: add TX watchdog and device resetting
>       zd1211rw: reset device when CR_BCN_FIFO_SEMAPHORE freezes in  
> beacon setup
>       zd1211rw: reset rx urbs after idle period of 30 seconds
>       zd1211rw: enable NL80211_IFTYPE_AP
>       zd1211rw: add useful debug output
>
>
>  drivers/net/wireless/zd1211rw/zd_chip.c |  134 ++++++---
>  drivers/net/wireless/zd1211rw/zd_chip.h |    5
>  drivers/net/wireless/zd1211rw/zd_mac.c  |  448  
> ++++++++++++++++++++++++-------
>  drivers/net/wireless/zd1211rw/zd_mac.h  |   24 +-
>  drivers/net/wireless/zd1211rw/zd_usb.c  |  445  
> ++++++++++++++++++++++++-------
>  drivers/net/wireless/zd1211rw/zd_usb.h  |   30 ++
>  net/mac80211/ieee80211_i.h              |    1
>  net/mac80211/tx.c                       |    4
>  8 files changed, 822 insertions(+), 269 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



