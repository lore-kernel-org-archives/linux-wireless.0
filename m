Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40778 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab2HKAaP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 20:30:15 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/4] compat: some fixes
Date: Sat, 11 Aug 2012 02:30:03 +0200
Message-Id: <1344645007-26757-1-git-send-email-hauke@hauke-m.de> (sfid-20120811_023019_305648_86DA0047)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With these patches and "compat: fixup error in no_printk definition" by 
Andy Gospodarek <andy@greyhouse.net> compat and compat-wireless are 
building for me on all supported kernel versions. There is also a patch 
for compat-wireless needed.

Results of ckmake on compat and compat-wireless:
Trying kernel 3.6.0-030600rc1-generic [OK]
Trying kernel 3.5.0-030500-generic [OK]
Trying kernel 3.4.7-030407-generic [OK]
Trying kernel 3.3.8-030308-generic [OK]
Trying kernel 3.2.26-030226-generic [OK]
Trying kernel 3.1.10-030110-generic [OK]
Trying kernel 3.0.39-030039-generic [OK]
Trying kernel 2.6.39-02063904-generic [OK]
Trying kernel 2.6.38-02063808-generic [OK]
Trying kernel 2.6.37-02063706-generic [OK]
Trying kernel 2.6.36-02063604-generic [OK]
Trying kernel 2.6.35-02063513-generic [OK]
Trying kernel 2.6.34-02063410-generic [OK]
Trying kernel 2.6.33-02063307-generic [OK]
Trying kernel 2.6.32-02063254-generic [OK]
Trying kernel 2.6.31-02063113-generic [OK]
Trying kernel 2.6.30-02063010-generic [OK]
Trying kernel 2.6.29-02062906-generic [OK]
Trying kernel 2.6.28-02062810-generic [OK]
Trying kernel 2.6.27-02062731-generic [OK]
Trying kernel 2.6.26-020626-generic [OK]
Trying kernel 2.6.25-020625-generic [OK]
Trying kernel 2.6.24-02062407-generic [OK]

Hauke Mehrtens (4):
  compat: fix SIMPLE_DEV_PM_OPS() on kernel 2.6.29
  compat: generate CONFIG_COMPAT_KERNEL_3_7
  compat: fix mod_delayed_work
  compat: move RHEL mask for qdisc_cb_private_validate

 compat/compat-3.7.c           |    2 ++
 include/linux/compat-2.6.29.h |   80 +++++++++++++++++++++++++++++------------
 include/linux/compat-2.6.32.h |   44 ++++-------------------
 include/linux/compat-2.6.33.h |   13 +++++++
 include/linux/compat-3.3.h    |    6 ++--
 scripts/gen-compat-config.sh  |    2 +-
 6 files changed, 83 insertions(+), 64 deletions(-)

-- 
1.7.9.5

