Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56578 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbZJLVUB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 17:20:01 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/10] [compat-2.6 and compat-stable] Mostly build fixes
Date: Mon, 12 Oct 2009 23:19:08 +0200
Message-Id: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series is for compat-2.6 and compat-stable-2.6.32. I have
compiled compat-wireless against mainline kernel 2.6.25 to 2.6.32. This
was all done with Ubuntu 9.04. compat-wireless should still compile with
openSuse, but I have not tried it.

The compat-stable fixes are addressing some compile problems with older
kernel versions. I have not tested all supported kernels.

The last stable kernel was added later so the number does not match.

Hauke Mehrtens (10):
  [compat-2.6 and compat-stable] Export round_jiffies_up again.
  [compat-2.6 and compat-stable] Remove unused code
  [compat-2.6] Move trace headers
  [compat-2.6] Fix compile bug with kernel 2.6.32
  [compat-2.6] Remove temporary fix
  [compat-2.6] Fix build with kernel < 2.6.27
  [compat-2.6] b44 fix
  [compat-2.6] refresh patches
  [compat-2.6] Add skb_add_rx_frag to backport.
  [compat-stable] fix build with recent mainline kernel

 compat/compat-2.6.27.h                             |   20 +++++
 compat/compat-2.6.28.c                             |   12 +++-
 compat/compat-2.6.28.h                             |   32 ++------
 compat/patches/01-netdev.patch                     |   77 ++++++--------------
 compat/patches/06-header-changes.patch             |   19 -----
 compat/patches/08-rename-iwl4965-config.patch      |    2 +-
 compat/patches/09-threaded-irq.patch               |    4 +-
 .../patches/10-add-wext-handlers-to-netdev.patch   |    2 +-
 compat/patches/12-iw_handler-changes.patch         |    7 ++-
 compat/patches/13-trace.patch                      |   35 ++++++++-
 scripts/admin-update.sh                            |    2 +-
 11 files changed, 101 insertions(+), 111 deletions(-)

