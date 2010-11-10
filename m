Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58629 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab0KJCUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:20:41 -0500
Received: by qwh5 with SMTP id 5so5541qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:20:40 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 00/44] Compat
Date: Tue,  9 Nov 2010 21:19:42 -0500
Message-Id: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

You will find in answer of this mail the first part of the compat upgrade I am
using to support a network-oriented module on kernel from 2.6.15 to 2.6.36.

All this code is available on my repository on github:

https://github.com/lacombar/linux-compat.git local

This repository also contains the second part I will post later concerning a
tentative to reduce namespace pollution when using the compat module. As it is
mostly mechanical, I will start another thread with a single proof of concept
patch and gather feedbacks :)

Comments welcome !

Thanks,
 - Arnaud

Arnaud Lacombe (44):
  compat/2.6.17: add header's skeleton
  compat/2.6.17: add compat macro for `NET_SKB_PAD'
  compat/2.6.18: add compat skeleton for the `hwrng' API
  compat/2.6.18: add compat inline for netdev_alloc_skb()
  compat/2.6.19: fix comment
  compat/2.6.19: add typedef for `bool' and `true'/`false'
  compat/2.6.19: rework compat macro to kmem_cache_destroy()
  compat/2.6.20: add header's skeleton
  compat/2.6.20: add compat macro for `struct delayed_work'
  compat/2.6.23: add compat inline for notifier_{from,to}_errno()
  compat/2.6.24: add compat macro for sk_alloc()
  compat/2.6.25: don't include <linux/hw_random.h> prior to 2.6.18
  compat/2.6.25: don't include <linux/{io,leds}.h> prior to 2.6.17
  compat/2.6.25: conditionally defines `__WARN'
  compat/2.6.25: add compat macro for ip_route_output_key()
  compat/2.6.29: don't include <linux/if_link.h> prior to 2.6.19
  compat/2.6.29: const'ify compat inline to dev_get_stats()
  compat/2.6.31: gather all the threaded IRQ backport together
  compat/2.6.31: fix threaded irq backport wrt. INIT_WORK() macro
  compat/2.6.32: fix compat inline to flush_delayed_work()
  compat/2.6.32: add compat macros for sysctl helpers
  compat/2.6.33: add compat macro to BUILD_BUG_ON_NOT_POWER_OF_2()
  compat/2.6.33: fix pcmcia include
  compat/2.6.33: don't export prototype for pccard_loop_tuple()
  compat/2.6.36: `va_list' needs <stdarg.h>
  compat: remove a couple of macro definition protection
  compat/2.6.33: remove macro not in mainline
  compat: avoid using `#include_next' directive in compat headers
  compat/2.6.22: rework `uninitialized_var' and `__maybe_unused' macros
  compat/2.6.22: nuke pci_{clear,set}_mwi()
  compat/2.6.22: add compat for couple of TCP accessors
  compat/2.6.22: add compat inline for ip_hdrlen()
  compat/2.6.22: constify skb_transport_header()'s argument
  compat/2.6.24: move 'struct net' to its own compat header
  compat/2.6.26: {U,}SHORT_MAX/SHORT_MIN have been deprecated
  compat/2.6.26: move unaligned backport to its own header
  compat/2.6.2{7,8}: fix definition for IEEE80211_HT_CAP_DSSSCCK40
  compat/2.6.2{8,9}: fix tracepoint macros
  compat/2.6.29: protect headers inclusion
  compat/2.6.29: don't waste space around DIV_ROUND_CLOSEST()
  compat/2.6.29: fix typos
  compat/2.6.{21,30}: make dev_set_uevent_suppress() a no-op for
    <2.6.21
  compat/2.6.{19,31}: fix threaded irq backport for <2.6.19
  compat/2.6.35: 2.6.35 does not define `SHRT_MIN'

 include/linux/asm/unaligned.h |  194 ++++++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.17.h |   13 +++
 include/linux/compat-2.6.18.h |   45 +++++++++
 include/linux/compat-2.6.19.h |   23 ++---
 include/linux/compat-2.6.20.h |   14 +++
 include/linux/compat-2.6.22.h |   41 ++++++--
 include/linux/compat-2.6.23.h |   18 +++-
 include/linux/compat-2.6.24.h |   34 +------
 include/linux/compat-2.6.25.h |   10 ++-
 include/linux/compat-2.6.26.h |  219 +----------------------------------------
 include/linux/compat-2.6.27.h |    3 -
 include/linux/compat-2.6.28.h |   27 +-----
 include/linux/compat-2.6.29.h |   40 ++++++--
 include/linux/compat-2.6.30.h |    2 +
 include/linux/compat-2.6.31.h |   54 ++++++++---
 include/linux/compat-2.6.32.h |   31 ++++++-
 include/linux/compat-2.6.33.h |   12 +--
 include/linux/compat-2.6.35.h |    1 -
 include/linux/compat-2.6.36.h |    1 +
 include/linux/pm_qos_params.h |    7 +-
 include/linux/tracepoint.h    |   14 ++--
 include/net/net_namespace.h   |   50 ++++++++--
 include/trace/define_trace.h  |    5 -
 23 files changed, 503 insertions(+), 355 deletions(-)
 create mode 100644 include/linux/asm/unaligned.h
 create mode 100644 include/linux/compat-2.6.17.h
 create mode 100644 include/linux/compat-2.6.20.h

-- 
1.7.2.30.gc37d7.dirty

