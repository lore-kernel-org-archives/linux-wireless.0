Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE87C67863
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 08:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EA2720779
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 08:23:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EA2720779
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sig21.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbeJVQks (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 12:40:48 -0400
Received: from mail.sig21.net ([80.244.240.74]:39014 "EHLO mail.sig21.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbeJVQks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 12:40:48 -0400
X-Greylist: delayed 1257 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2018 12:40:47 EDT
Received: from p54ae9eee.dip0.t-ipconnect.de ([84.174.158.238] helo=abc.local)
        by mail.sig21.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <js@sig21.net>)
        id 1gEVAF-0006O3-LD; Mon, 22 Oct 2018 10:02:20 +0200
Received: from js by abc.local with local (Exim 4.91)
        (envelope-from <js@sig21.net>)
        id 1gEVAE-0001g9-QN; Mon, 22 Oct 2018 10:02:14 +0200
Date:   Mon, 22 Oct 2018 10:02:14 +0200
From:   Johannes Stezenbach <js@sig21.net>
To:     Arend van Spriel <aspriel@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     linux-wireless@vger.kernel.org
Subject: 4.18.16: memory leak in sta_set_sinfo
Message-ID: <20181022080214.GA6379@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I used 4.18.11 for a while and noticed a memleak showing
in slabtop as kmalloc-2048.  Then I updated to 4.18.16
and enabled kmemleak, it dumps this:

unreferenced object 0xffffa10a5cc49800 (size 2048):
  comm "conky", pid 2734, jiffies 4295635396 (age 454.650s)
  hex dump (first 32 bytes):
    1e 00 00 00 00 00 00 00 ad 13 00 00 00 00 00 00  ................
    a1 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000b7b13d1a>] sta_set_sinfo+0x634/0x900 [mac80211]
    [<00000000a74db622>] ieee80211_get_station+0x50/0x70 [mac80211]
    [<0000000039cfbb15>] cfg80211_wireless_stats+0x103/0x350 [cfg80211]
    [<000000003e9c0192>] iw_handler_get_iwstats+0x3b/0x90
    [<0000000058160332>] ioctl_standard_iw_point+0xef/0x370
    [<000000008af7fc78>] ioctl_standard_call+0x9d/0xb0
    [<000000009ad7a410>] wext_handle_ioctl+0x99/0xf0
    [<000000006bc483dc>] sock_ioctl+0x1b5/0x330
    [<000000004a40c83b>] do_vfs_ioctl+0xa4/0x620
    [<00000000c498918f>] ksys_ioctl+0x3a/0x70
    [<00000000033ccded>] __x64_sys_ioctl+0x16/0x20
    [<0000000038d98ffe>] do_syscall_64+0x56/0x110
    [<00000000913ebc09>] entry_SYSCALL_64_after_hwframe+0x49/0xbe
    [<00000000b4781b29>] 0xffffffffffffffff
unreferenced object 0xffffa10a5cc4c000 (size 2048):
  comm "conky", pid 2734, jiffies 4295635396 (age 454.650s)
  hex dump (first 32 bytes):
    1e 00 00 00 00 00 00 00 ad 13 00 00 00 00 00 00  ................
    a1 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000b7b13d1a>] sta_set_sinfo+0x634/0x900 [mac80211]
    [<00000000a74db622>] ieee80211_get_station+0x50/0x70 [mac80211]
    [<000000009fd8a7aa>] cfg80211_wext_giwrate+0x111/0x2b0 [cfg80211]
    [<0000000045f8e84f>] ioctl_standard_call+0x4d/0xb0
    [<000000009ad7a410>] wext_handle_ioctl+0x99/0xf0
    [<000000006bc483dc>] sock_ioctl+0x1b5/0x330
    [<000000004a40c83b>] do_vfs_ioctl+0xa4/0x620
    [<00000000c498918f>] ksys_ioctl+0x3a/0x70
    [<00000000033ccded>] __x64_sys_ioctl+0x16/0x20
    [<0000000038d98ffe>] do_syscall_64+0x56/0x110
    [<00000000913ebc09>] entry_SYSCALL_64_after_hwframe+0x49/0xbe
    [<00000000b4781b29>] 0xffffffffffffffff

etc.

sta_set_sinfo+0x634/0x900 seemt to be the call to
cfg80211_sinfo_alloc_tid_stats().


dmesg:

[ 2975.537043] kmemleak: 1223 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[ 3140.960503] kmemleak: 851 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[ 3755.462385] kmemleak: 280 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[ 4369.876913] kmemleak: 1011 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[ 4984.711904] kmemleak: 1002 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[ 5598.838136] kmemleak: 1023 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[ 6213.236272] kmemleak: 1088 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[ 6833.692160] kmemleak: 1004 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[ 7447.151259] kmemleak: 1147 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

I guess it relates to
0fdf1493b41 " mac80211: allocate and fill tidstats only when needed"
which Fixes: 8689c051a201 ("cfg80211: dynamically allocate per-tid stats for station info")


Johannes
