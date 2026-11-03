Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793690526;
	b=JDED2l3FklEYNPDpiPtRvq4v+piE8deOT4R+FUwV89YwLoMAmotywpCa5c9qDFRrvmu9
	 icfDPgtfnX7jL/dKEdKqqkzTUe2LMH+4f1f2ZZsCLB8U2H4hi1W+BCaYXOpNrImdOl82/
	 Dp7LuGlDg4XW0Nr6lOs4rVtg6iPuD095Mz1SFpz1eP3svZtdt4z5K52asvBbdCoX2FJB+
	 +5IDQ2yiM0ad2OZJMbg5aIFH/mlps5d/gwPgQaYmHBDFtzW2H/o5j/2FJankuWhOuxpMW
	 re4EEq2z5sHy3HeVAwbAWrIedNdBw5NshbP4eC/155PkmPj2GmlxgNZVJ7cA0Q/z0Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793690526;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=VcKZbxGxnDf670MYv2ZlU3vquEwQHCxZSuyzdaUzO9w=;
	b=ezVlE5TKm6ziynwY4iNi8Qf+tg6dxyNFByKariOdgYQh25y8/WAowBEbCQR210ss+5Kj
	 Lk/IbjY+RosdfnqYCW8Pz82PFK4+c8AnCzTZnwq/p7QYusToNjWbSK1ySsCk83MMJXhgc
	 mR7jTqEYnLOwpNyzVssTMApbsukgxXiEUs/UBBDJd9VJxj/HNA3G2f+hU59ibN90k0jXs
	 osKnpxbbRcWv24Xg7aQLGXb/4XYvJjixr1+2cBMSnx93MXXRocjHZ9QjhMIyGPw9Q92vz
	 AXzcBd5frQVeqoNScZ2b2ew0mOBngX50cvQ6efLwrUAEL8wrCqxiTcQPU3yRg7o7ROQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QdcGGBv4;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9390E606A332
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 07:22:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9390E606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QdcGGBv4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793690525; x=1825226525;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1SKnSg+pIqDZFtJD7tZ7/aN8fjQWTk+cyVhupecIP38=;
  b=QdcGGBv4eMLYoIw8BGF0Em5TCTnvGsnHLN/eYYduFf0bUotMCD06QIwD
   C7ZKFEwKKX8qrDrlflnZQll76C8byuFJ3XgV3+mY/32ijAkvbapU6kmm7
   EH4G2CJSh0WRjG3s+fdvnR2YhvrZ7cIGrdjyJYGKVNwJWbtOM/8EmB3V9
   NIvtN0Xi2HnI3+/BrRG5Te0gxxNMlUrqlB4at4Gnnwgee784e+ZaQwS2a
   Apm5uCXtySrIwsAIZY1EyrHNbjRovGof74C9VSDxv6QULbrgJUbKRejdK
   ToVB7EgaK5siw5XS2Vy9yW4oeaLj8j0OlGWUzITqJVsYMFI9wYovupw+B
   A==;
X-CSE-ConnectionGUID: nHuxhJ4qTYW/LMhxr7lSWg==
X-CSE-MsgGUID: svkbwWFyQLeQOM5nhf46FA==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="2282328"
X-IronPort-AV: E=Sophos;i="6.27,192,1787036400"; 
   d="scan'208";a="2282328"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 23:22:04 -0800
X-CSE-ConnectionGUID: Y5aH+inaTRSJkZns7vkdtw==
X-CSE-MsgGUID: hwU7rUVZTreq/3Z7sRjMEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,192,1787036400"; 
   d="scan'208";a="6455411"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 02 Nov 2026 23:22:01 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xO8qF-00000000iR2-13Xb;
	Tue, 03 Nov 2026 07:21:59 +0000
Date: Tue, 3 Nov 2026 15:21:30 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: Re: [PATCH wireless-next] wifi: cfg80211: add APIs for SMD transition
Message-ID: <202611031530.dNReBXlc-lkp@intel.com>
References: <20261102231220.5b52ad631258.Id451626c78a925e85aaf2598ab471120940a91c7@changeid>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102231220.5b52ad631258.Id451626c78a925e85aaf2598ab471120940a91c7@changeid>

Hi Johannes,

kernel test robot noticed the following build warnings:

[auto build test WARNING on wireless-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Johannes-Berg/wifi-cfg80211-add-APIs-for-SMD-transition/20261102-231218
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20261102231220.5b52ad631258.Id451626c78a925e85aaf2598ab471120940a91c7%40changeid
patch subject: [PATCH wireless-next] wifi: cfg80211: add APIs for SMD transition
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20261103/202611031530.dNReBXlc-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261103/202611031530.dNReBXlc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611031530.dNReBXlc-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/trace/define_trace.h:134,
                    from net/wireless/trace.h:4711,
                    from net/wireless/trace.c:6:
   net/wireless/./trace.h: In function '__bpf_trace_cfg80211_rx_st_preparation_response':
>> include/trace/bpf_probe.h:26:24: warning: 'sizeof' on array function parameter 'links' will return size of 'struct cfg80211_bss **' [-Wsizeof-array-argument]
      26 |         UINTTYPE(sizeof(x)) __dst; \
         |                        ^
   include/trace/bpf_probe.h:19:42: note: in definition of macro 'UINTTYPE'
      19 |         __typeof__(__builtin_choose_expr(size == 1,  (u8)1, \
         |                                          ^~~~
   include/trace/bpf_probe.h:30:24: note: in expansion of macro '__CAST_TO_U64'
      30 | #define __CAST1(a,...) __CAST_TO_U64(a)
         |                        ^~~~~~~~~~~~~
   include/trace/bpf_probe.h:31:42: note: in expansion of macro '__CAST1'
      31 | #define __CAST2(a,...) __CAST_TO_U64(a), __CAST1(__VA_ARGS__)
         |                                          ^~~~~~~
   include/trace/bpf_probe.h:32:42: note: in expansion of macro '__CAST2'
      32 | #define __CAST3(a,...) __CAST_TO_U64(a), __CAST2(__VA_ARGS__)
         |                                          ^~~~~~~
   include/trace/bpf_probe.h:33:42: note: in expansion of macro '__CAST3'
      33 | #define __CAST4(a,...) __CAST_TO_U64(a), __CAST3(__VA_ARGS__)
         |                                          ^~~~~~~
   include/trace/bpf_probe.h:34:42: note: in expansion of macro '__CAST4'
      34 | #define __CAST5(a,...) __CAST_TO_U64(a), __CAST4(__VA_ARGS__)
         |                                          ^~~~~~~
   include/linux/args.h:25:24: note: in expansion of macro '__CAST5'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/trace/bpf_probe.h:43:26: note: in expansion of macro 'CONCATENATE'
      43 | #define CAST_TO_U64(...) CONCATENATE(__CAST, COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__)
         |                          ^~~~~~~~~~~
   include/trace/bpf_probe.h:49:62: note: in expansion of macro 'CAST_TO_U64'
      49 |         CONCATENATE(bpf_trace_run, COUNT_ARGS(args))(__data, CAST_TO_U64(args));        \
         |                                                              ^~~~~~~~~~~
   include/trace/bpf_probe.h:54:9: note: in expansion of macro '__BPF_DECLARE_TRACE'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:41:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      41 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4556:1: note: in expansion of macro 'TRACE_EVENT'
    4556 | TRACE_EVENT(cfg80211_rx_st_preparation_response,
         | ^~~~~~~~~~~
   net/wireless/./trace.h:4559:39: note: declared here
    4559 |                  struct cfg80211_bss *links[IEEE80211_MLD_MAX_NUM_LINKS]),
         |                  ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/bpf_probe.h:47:34: note: in definition of macro '__BPF_DECLARE_TRACE'
      47 | __bpf_trace_##call(void *__data, proto)                                 \
         |                                  ^~~~~
   include/trace/bpf_probe.h:54:35: note: in expansion of macro 'PARAMS'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |                                   ^~~~~~
   include/trace/trace_events.h:41:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      41 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:42:30: note: in expansion of macro 'PARAMS'
      42 |                              PARAMS(proto),                    \
         |                              ^~~~~~
   net/wireless/./trace.h:4556:1: note: in expansion of macro 'TRACE_EVENT'
    4556 | TRACE_EVENT(cfg80211_rx_st_preparation_response,
         | ^~~~~~~~~~~
   net/wireless/./trace.h:4557:9: note: in expansion of macro 'TP_PROTO'
    4557 |         TP_PROTO(struct net_device *netdev, const u8 *ap_mld_addr,
         |         ^~~~~~~~
>> include/trace/bpf_probe.h:26:24: warning: 'sizeof' on array function parameter 'links' will return size of 'struct cfg80211_bss **' [-Wsizeof-array-argument]
      26 |         UINTTYPE(sizeof(x)) __dst; \
         |                        ^
   include/trace/bpf_probe.h:20:42: note: in definition of macro 'UINTTYPE'
      20 |                    __builtin_choose_expr(size == 2, (u16)2, \
         |                                          ^~~~
   include/trace/bpf_probe.h:30:24: note: in expansion of macro '__CAST_TO_U64'
      30 | #define __CAST1(a,...) __CAST_TO_U64(a)
         |                        ^~~~~~~~~~~~~
   include/trace/bpf_probe.h:31:42: note: in expansion of macro '__CAST1'
      31 | #define __CAST2(a,...) __CAST_TO_U64(a), __CAST1(__VA_ARGS__)
         |                                          ^~~~~~~
   include/trace/bpf_probe.h:32:42: note: in expansion of macro '__CAST2'
      32 | #define __CAST3(a,...) __CAST_TO_U64(a), __CAST2(__VA_ARGS__)
         |                                          ^~~~~~~
   include/trace/bpf_probe.h:33:42: note: in expansion of macro '__CAST3'
      33 | #define __CAST4(a,...) __CAST_TO_U64(a), __CAST3(__VA_ARGS__)
         |                                          ^~~~~~~
   include/trace/bpf_probe.h:34:42: note: in expansion of macro '__CAST4'
      34 | #define __CAST5(a,...) __CAST_TO_U64(a), __CAST4(__VA_ARGS__)
         |                                          ^~~~~~~
   include/linux/args.h:25:24: note: in expansion of macro '__CAST5'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/trace/bpf_probe.h:43:26: note: in expansion of macro 'CONCATENATE'
      43 | #define CAST_TO_U64(...) CONCATENATE(__CAST, COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__)
         |                          ^~~~~~~~~~~
   include/trace/bpf_probe.h:49:62: note: in expansion of macro 'CAST_TO_U64'
      49 |         CONCATENATE(bpf_trace_run, COUNT_ARGS(args))(__data, CAST_TO_U64(args));        \
         |                                                              ^~~~~~~~~~~
   include/trace/bpf_probe.h:54:9: note: in expansion of macro '__BPF_DECLARE_TRACE'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:41:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      41 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4556:1: note: in expansion of macro 'TRACE_EVENT'
    4556 | TRACE_EVENT(cfg80211_rx_st_preparation_response,
         | ^~~~~~~~~~~
   net/wireless/./trace.h:4559:39: note: declared here
    4559 |                  struct cfg80211_bss *links[IEEE80211_MLD_MAX_NUM_LINKS]),
         |                  ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/bpf_probe.h:47:34: note: in definition of macro '__BPF_DECLARE_TRACE'
      47 | __bpf_trace_##call(void *__data, proto)                                 \
         |                                  ^~~~~
   include/trace/bpf_probe.h:54:35: note: in expansion of macro 'PARAMS'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |                                   ^~~~~~
   include/trace/trace_events.h:41:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      41 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:42:30: note: in expansion of macro 'PARAMS'
      42 |                              PARAMS(proto),                    \
         |                              ^~~~~~
   net/wireless/./trace.h:4556:1: note: in expansion of macro 'TRACE_EVENT'
    4556 | TRACE_EVENT(cfg80211_rx_st_preparation_response,
         | ^~~~~~~~~~~
   net/wireless/./trace.h:4557:9: note: in expansion of macro 'TP_PROTO'
    4557 |         TP_PROTO(struct net_device *netdev, const u8 *ap_mld_addr,
         |         ^~~~~~~~
>> include/trace/bpf_probe.h:26:24: warning: 'sizeof' on array function parameter 'links' will return size of 'struct cfg80211_bss **' [-Wsizeof-array-argument]
      26 |         UINTTYPE(sizeof(x)) __dst; \
         |                        ^
   include/trace/bpf_probe.h:21:42: note: in definition of macro 'UINTTYPE'
      21 |                    __builtin_choose_expr(size == 4, (u32)3, \
         |                                          ^~~~
   include/trace/bpf_probe.h:30:24: note: in expansion of macro '__CAST_TO_U64'
      30 | #define __CAST1(a,...) __CAST_TO_U64(a)
         |                        ^~~~~~~~~~~~~
   include/trace/bpf_probe.h:31:42: note: in expansion of macro '__CAST1'
      31 | #define __CAST2(a,...) __CAST_TO_U64(a), __CAST1(__VA_ARGS__)
         |                                          ^~~~~~~
   include/trace/bpf_probe.h:32:42: note: in expansion of macro '__CAST2'
      32 | #define __CAST3(a,...) __CAST_TO_U64(a), __CAST2(__VA_ARGS__)
         |                                          ^~~~~~~
   include/trace/bpf_probe.h:33:42: note: in expansion of macro '__CAST3'
      33 | #define __CAST4(a,...) __CAST_TO_U64(a), __CAST3(__VA_ARGS__)
         |                                          ^~~~~~~
   include/trace/bpf_probe.h:34:42: note: in expansion of macro '__CAST4'
      34 | #define __CAST5(a,...) __CAST_TO_U64(a), __CAST4(__VA_ARGS__)
         |                                          ^~~~~~~
   include/linux/args.h:25:24: note: in expansion of macro '__CAST5'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/trace/bpf_probe.h:43:26: note: in expansion of macro 'CONCATENATE'
      43 | #define CAST_TO_U64(...) CONCATENATE(__CAST, COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__)
         |                          ^~~~~~~~~~~
   include/trace/bpf_probe.h:49:62: note: in expansion of macro 'CAST_TO_U64'
      49 |         CONCATENATE(bpf_trace_run, COUNT_ARGS(args))(__data, CAST_TO_U64(args));        \
         |                                                              ^~~~~~~~~~~
   include/trace/bpf_probe.h:54:9: note: in expansion of macro '__BPF_DECLARE_TRACE'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:41:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      41 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4556:1: note: in expansion of macro 'TRACE_EVENT'
    4556 | TRACE_EVENT(cfg80211_rx_st_preparation_response,
         | ^~~~~~~~~~~
   net/wireless/./trace.h:4559:39: note: declared here
    4559 |                  struct cfg80211_bss *links[IEEE80211_MLD_MAX_NUM_LINKS]),
         |                  ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/bpf_probe.h:47:34: note: in definition of macro '__BPF_DECLARE_TRACE'
      47 | __bpf_trace_##call(void *__data, proto)                                 \
         |                                  ^~~~~
   include/trace/bpf_probe.h:54:35: note: in expansion of macro 'PARAMS'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |                                   ^~~~~~
   include/trace/trace_events.h:41:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      41 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:42:30: note: in expansion of macro 'PARAMS'
      42 |                              PARAMS(proto),                    \
         |                              ^~~~~~
   net/wireless/./trace.h:4556:1: note: in expansion of macro 'TRACE_EVENT'
    4556 | TRACE_EVENT(cfg80211_rx_st_preparation_response,
         | ^~~~~~~~~~~
   net/wireless/./trace.h:4557:9: note: in expansion of macro 'TP_PROTO'
    4557 |         TP_PROTO(struct net_device *netdev, const u8 *ap_mld_addr,
         |         ^~~~~~~~
>> include/trace/bpf_probe.h:26:24: warning: 'sizeof' on array function parameter 'links' will return size of 'struct cfg80211_bss **' [-Wsizeof-array-argument]
      26 |         UINTTYPE(sizeof(x)) __dst; \
         |                        ^
   include/trace/bpf_probe.h:22:42: note: in definition of macro 'UINTTYPE'
      22 |                    __builtin_choose_expr(size == 8, (u64)4, \
         |                                          ^~~~
   include/trace/bpf_probe.h:30:24: note: in expansion of macro '__CAST_TO_U64'
      30 | #define __CAST1(a,...) __CAST_TO_U64(a)
         |                        ^~~~~~~~~~~~~
   include/trace/bpf_probe.h:31:42: note: in expansion of macro '__CAST1'
      31 | #define __CAST2(a,...) __CAST_TO_U64(a), __CAST1(__VA_ARGS__)
         |                                          ^~~~~~~
   include/trace/bpf_probe.h:32:42: note: in expansion of macro '__CAST2'
      32 | #define __CAST3(a,...) __CAST_TO_U64(a), __CAST2(__VA_ARGS__)
         |                                          ^~~~~~~
   include/trace/bpf_probe.h:33:42: note: in expansion of macro '__CAST3'
      33 | #define __CAST4(a,...) __CAST_TO_U64(a), __CAST3(__VA_ARGS__)
         |                                          ^~~~~~~
   include/trace/bpf_probe.h:34:42: note: in expansion of macro '__CAST4'
      34 | #define __CAST5(a,...) __CAST_TO_U64(a), __CAST4(__VA_ARGS__)
         |                                          ^~~~~~~
   include/linux/args.h:25:24: note: in expansion of macro '__CAST5'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/trace/bpf_probe.h:43:26: note: in expansion of macro 'CONCATENATE'
      43 | #define CAST_TO_U64(...) CONCATENATE(__CAST, COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__)
         |                          ^~~~~~~~~~~
   include/trace/bpf_probe.h:49:62: note: in expansion of macro 'CAST_TO_U64'
      49 |         CONCATENATE(bpf_trace_run, COUNT_ARGS(args))(__data, CAST_TO_U64(args));        \
         |                                                              ^~~~~~~~~~~
   include/trace/bpf_probe.h:54:9: note: in expansion of macro '__BPF_DECLARE_TRACE'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:41:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      41 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4556:1: note: in expansion of macro 'TRACE_EVENT'
    4556 | TRACE_EVENT(cfg80211_rx_st_preparation_response,
         | ^~~~~~~~~~~
   net/wireless/./trace.h:4559:39: note: declared here
    4559 |                  struct cfg80211_bss *links[IEEE80211_MLD_MAX_NUM_LINKS]),
         |                  ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/bpf_probe.h:47:34: note: in definition of macro '__BPF_DECLARE_TRACE'
      47 | __bpf_trace_##call(void *__data, proto)                                 \
         |                                  ^~~~~
   include/trace/bpf_probe.h:54:35: note: in expansion of macro 'PARAMS'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |                                   ^~~~~~
   include/trace/trace_events.h:41:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      41 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:42:30: note: in expansion of macro 'PARAMS'
      42 |                              PARAMS(proto),                    \
         |                              ^~~~~~
   net/wireless/./trace.h:4556:1: note: in expansion of macro 'TRACE_EVENT'
    4556 | TRACE_EVENT(cfg80211_rx_st_preparation_response,
         | ^~~~~~~~~~~
   net/wireless/./trace.h:4557:9: note: in expansion of macro 'TP_PROTO'
    4557 |         TP_PROTO(struct net_device *netdev, const u8 *ap_mld_addr,
         |         ^~~~~~~~
   net/wireless/./trace.h: In function '__bpf_trace_cfg80211_st_evt':
>> include/trace/bpf_probe.h:26:24: warning: 'sizeof' on array function parameter 'links' will return size of 'struct cfg80211_bss **' [-Wsizeof-array-argument]
      26 |         UINTTYPE(sizeof(x)) __dst; \
         |                        ^
   include/trace/bpf_probe.h:19:42: note: in definition of macro 'UINTTYPE'
      19 |         __typeof__(__builtin_choose_expr(size == 1,  (u8)1, \
         |                                          ^~~~
   include/trace/bpf_probe.h:30:24: note: in expansion of macro '__CAST_TO_U64'
      30 | #define __CAST1(a,...) __CAST_TO_U64(a)
         |                        ^~~~~~~~~~~~~
   include/trace/bpf_probe.h:31:42: note: in expansion of macro '__CAST1'
      31 | #define __CAST2(a,...) __CAST_TO_U64(a), __CAST1(__VA_ARGS__)
         |                                          ^~~~~~~
   include/linux/args.h:25:24: note: in expansion of macro '__CAST2'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/trace/bpf_probe.h:43:26: note: in expansion of macro 'CONCATENATE'
      43 | #define CAST_TO_U64(...) CONCATENATE(__CAST, COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__)
         |                          ^~~~~~~~~~~
   include/trace/bpf_probe.h:49:62: note: in expansion of macro 'CAST_TO_U64'
      49 |         CONCATENATE(bpf_trace_run, COUNT_ARGS(args))(__data, CAST_TO_U64(args));        \
         |                                                              ^~~~~~~~~~~
   include/trace/bpf_probe.h:54:9: note: in expansion of macro '__BPF_DECLARE_TRACE'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |         ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4627:1: note: in expansion of macro 'DECLARE_EVENT_CLASS'
    4627 | DECLARE_EVENT_CLASS(cfg80211_st_evt,
         | ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4629:39: note: declared here
    4629 |                  struct cfg80211_bss *links[IEEE80211_MLD_MAX_NUM_LINKS]),
         |                  ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/bpf_probe.h:47:34: note: in definition of macro '__BPF_DECLARE_TRACE'
      47 | __bpf_trace_##call(void *__data, proto)                                 \
         |                                  ^~~~~
   include/trace/bpf_probe.h:54:35: note: in expansion of macro 'PARAMS'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |                                   ^~~~~~
   net/wireless/./trace.h:4627:1: note: in expansion of macro 'DECLARE_EVENT_CLASS'
    4627 | DECLARE_EVENT_CLASS(cfg80211_st_evt,
         | ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4628:9: note: in expansion of macro 'TP_PROTO'
    4628 |         TP_PROTO(struct net_device *netdev,
         |         ^~~~~~~~
>> include/trace/bpf_probe.h:26:24: warning: 'sizeof' on array function parameter 'links' will return size of 'struct cfg80211_bss **' [-Wsizeof-array-argument]
      26 |         UINTTYPE(sizeof(x)) __dst; \
         |                        ^
   include/trace/bpf_probe.h:20:42: note: in definition of macro 'UINTTYPE'
      20 |                    __builtin_choose_expr(size == 2, (u16)2, \
         |                                          ^~~~
   include/trace/bpf_probe.h:30:24: note: in expansion of macro '__CAST_TO_U64'
      30 | #define __CAST1(a,...) __CAST_TO_U64(a)
         |                        ^~~~~~~~~~~~~
   include/trace/bpf_probe.h:31:42: note: in expansion of macro '__CAST1'
      31 | #define __CAST2(a,...) __CAST_TO_U64(a), __CAST1(__VA_ARGS__)
         |                                          ^~~~~~~
   include/linux/args.h:25:24: note: in expansion of macro '__CAST2'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/trace/bpf_probe.h:43:26: note: in expansion of macro 'CONCATENATE'
      43 | #define CAST_TO_U64(...) CONCATENATE(__CAST, COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__)
         |                          ^~~~~~~~~~~
   include/trace/bpf_probe.h:49:62: note: in expansion of macro 'CAST_TO_U64'
      49 |         CONCATENATE(bpf_trace_run, COUNT_ARGS(args))(__data, CAST_TO_U64(args));        \
         |                                                              ^~~~~~~~~~~
   include/trace/bpf_probe.h:54:9: note: in expansion of macro '__BPF_DECLARE_TRACE'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |         ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4627:1: note: in expansion of macro 'DECLARE_EVENT_CLASS'
    4627 | DECLARE_EVENT_CLASS(cfg80211_st_evt,
         | ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4629:39: note: declared here
    4629 |                  struct cfg80211_bss *links[IEEE80211_MLD_MAX_NUM_LINKS]),
         |                  ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/bpf_probe.h:47:34: note: in definition of macro '__BPF_DECLARE_TRACE'
      47 | __bpf_trace_##call(void *__data, proto)                                 \
         |                                  ^~~~~
   include/trace/bpf_probe.h:54:35: note: in expansion of macro 'PARAMS'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |                                   ^~~~~~
   net/wireless/./trace.h:4627:1: note: in expansion of macro 'DECLARE_EVENT_CLASS'
    4627 | DECLARE_EVENT_CLASS(cfg80211_st_evt,
         | ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4628:9: note: in expansion of macro 'TP_PROTO'
    4628 |         TP_PROTO(struct net_device *netdev,
         |         ^~~~~~~~
>> include/trace/bpf_probe.h:26:24: warning: 'sizeof' on array function parameter 'links' will return size of 'struct cfg80211_bss **' [-Wsizeof-array-argument]
      26 |         UINTTYPE(sizeof(x)) __dst; \
         |                        ^
   include/trace/bpf_probe.h:21:42: note: in definition of macro 'UINTTYPE'
      21 |                    __builtin_choose_expr(size == 4, (u32)3, \
         |                                          ^~~~
   include/trace/bpf_probe.h:30:24: note: in expansion of macro '__CAST_TO_U64'
      30 | #define __CAST1(a,...) __CAST_TO_U64(a)
         |                        ^~~~~~~~~~~~~
   include/trace/bpf_probe.h:31:42: note: in expansion of macro '__CAST1'
      31 | #define __CAST2(a,...) __CAST_TO_U64(a), __CAST1(__VA_ARGS__)
         |                                          ^~~~~~~
   include/linux/args.h:25:24: note: in expansion of macro '__CAST2'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/trace/bpf_probe.h:43:26: note: in expansion of macro 'CONCATENATE'
      43 | #define CAST_TO_U64(...) CONCATENATE(__CAST, COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__)
         |                          ^~~~~~~~~~~
   include/trace/bpf_probe.h:49:62: note: in expansion of macro 'CAST_TO_U64'
      49 |         CONCATENATE(bpf_trace_run, COUNT_ARGS(args))(__data, CAST_TO_U64(args));        \
         |                                                              ^~~~~~~~~~~
   include/trace/bpf_probe.h:54:9: note: in expansion of macro '__BPF_DECLARE_TRACE'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |         ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4627:1: note: in expansion of macro 'DECLARE_EVENT_CLASS'
    4627 | DECLARE_EVENT_CLASS(cfg80211_st_evt,
         | ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4629:39: note: declared here
    4629 |                  struct cfg80211_bss *links[IEEE80211_MLD_MAX_NUM_LINKS]),
         |                  ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/bpf_probe.h:47:34: note: in definition of macro '__BPF_DECLARE_TRACE'
      47 | __bpf_trace_##call(void *__data, proto)                                 \
         |                                  ^~~~~
   include/trace/bpf_probe.h:54:35: note: in expansion of macro 'PARAMS'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |                                   ^~~~~~
   net/wireless/./trace.h:4627:1: note: in expansion of macro 'DECLARE_EVENT_CLASS'
    4627 | DECLARE_EVENT_CLASS(cfg80211_st_evt,
         | ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4628:9: note: in expansion of macro 'TP_PROTO'
    4628 |         TP_PROTO(struct net_device *netdev,
         |         ^~~~~~~~
>> include/trace/bpf_probe.h:26:24: warning: 'sizeof' on array function parameter 'links' will return size of 'struct cfg80211_bss **' [-Wsizeof-array-argument]
      26 |         UINTTYPE(sizeof(x)) __dst; \
         |                        ^
   include/trace/bpf_probe.h:22:42: note: in definition of macro 'UINTTYPE'
      22 |                    __builtin_choose_expr(size == 8, (u64)4, \
         |                                          ^~~~
   include/trace/bpf_probe.h:30:24: note: in expansion of macro '__CAST_TO_U64'
      30 | #define __CAST1(a,...) __CAST_TO_U64(a)
         |                        ^~~~~~~~~~~~~
   include/trace/bpf_probe.h:31:42: note: in expansion of macro '__CAST1'
      31 | #define __CAST2(a,...) __CAST_TO_U64(a), __CAST1(__VA_ARGS__)
         |                                          ^~~~~~~
   include/linux/args.h:25:24: note: in expansion of macro '__CAST2'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/trace/bpf_probe.h:43:26: note: in expansion of macro 'CONCATENATE'
      43 | #define CAST_TO_U64(...) CONCATENATE(__CAST, COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__)
         |                          ^~~~~~~~~~~
   include/trace/bpf_probe.h:49:62: note: in expansion of macro 'CAST_TO_U64'
      49 |         CONCATENATE(bpf_trace_run, COUNT_ARGS(args))(__data, CAST_TO_U64(args));        \
         |                                                              ^~~~~~~~~~~
   include/trace/bpf_probe.h:54:9: note: in expansion of macro '__BPF_DECLARE_TRACE'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |         ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4627:1: note: in expansion of macro 'DECLARE_EVENT_CLASS'
    4627 | DECLARE_EVENT_CLASS(cfg80211_st_evt,
         | ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4629:39: note: declared here
    4629 |                  struct cfg80211_bss *links[IEEE80211_MLD_MAX_NUM_LINKS]),
         |                  ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/bpf_probe.h:47:34: note: in definition of macro '__BPF_DECLARE_TRACE'
      47 | __bpf_trace_##call(void *__data, proto)                                 \
         |                                  ^~~~~
   include/trace/bpf_probe.h:54:35: note: in expansion of macro 'PARAMS'
      54 |         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
         |                                   ^~~~~~
   net/wireless/./trace.h:4627:1: note: in expansion of macro 'DECLARE_EVENT_CLASS'
    4627 | DECLARE_EVENT_CLASS(cfg80211_st_evt,
         | ^~~~~~~~~~~~~~~~~~~
   net/wireless/./trace.h:4628:9: note: in expansion of macro 'TP_PROTO'
    4628 |         TP_PROTO(struct net_device *netdev,
         |         ^~~~~~~~
..


vim +26 include/trace/bpf_probe.h

b229baa374dbb1 Andy Shevchenko    2023-07-19  16  
c4f6699dfcb855 Alexei Starovoitov 2018-03-28  17  /* cast any integer, pointer, or small struct to u64 */
c4f6699dfcb855 Alexei Starovoitov 2018-03-28  18  #define UINTTYPE(size) \
c4f6699dfcb855 Alexei Starovoitov 2018-03-28  19  	__typeof__(__builtin_choose_expr(size == 1,  (u8)1, \
c4f6699dfcb855 Alexei Starovoitov 2018-03-28  20  		   __builtin_choose_expr(size == 2, (u16)2, \
c4f6699dfcb855 Alexei Starovoitov 2018-03-28  21  		   __builtin_choose_expr(size == 4, (u32)3, \
c4f6699dfcb855 Alexei Starovoitov 2018-03-28  22  		   __builtin_choose_expr(size == 8, (u64)4, \
c4f6699dfcb855 Alexei Starovoitov 2018-03-28  23  					 (void)5)))))
c4f6699dfcb855 Alexei Starovoitov 2018-03-28  24  #define __CAST_TO_U64(x) ({ \
c4f6699dfcb855 Alexei Starovoitov 2018-03-28  25  	typeof(x) __src = (x); \
c4f6699dfcb855 Alexei Starovoitov 2018-03-28 @26  	UINTTYPE(sizeof(x)) __dst; \
c4f6699dfcb855 Alexei Starovoitov 2018-03-28  27  	memcpy(&__dst, &__src, sizeof(__dst)); \
c4f6699dfcb855 Alexei Starovoitov 2018-03-28  28  	(u64)__dst; })
c4f6699dfcb855 Alexei Starovoitov 2018-03-28  29  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
