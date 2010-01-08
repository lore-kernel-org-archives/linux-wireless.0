Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29219 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab0AHSEo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 13:04:44 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/4] iwlwifi updates for 2.6.34
Date: Fri,  8 Jan 2010 10:04:40 -0800
Message-Id: <1262973884-2551-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are a few cleanups targeting 2.6.34. Driver will now return
"unsupported" if receiving IEEE80211_AMPDU_TX_OPERATIONAL from mac80211.
The statistics data structure is updated to use a field previously marked
as "reserved". An obsolete host command is removed. This series also
includes a fix to use correct information when updating byte count table.

Wey-Yi Guy (4):
  iwlwifi: add IEEE80211_AMPDU_TX_OPERATIONAL
  iwlwifi: ucode statistics data structure update
  iwlwifi: remove obsoleted host command
  iwlwifi: fix bug in tx byte count table

 drivers/net/wireless/iwlwifi/iwl-5000.c     |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3 +++
 drivers/net/wireless/iwlwifi/iwl-commands.h |    7 +++----
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    3 +++
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    1 -
 5 files changed, 13 insertions(+), 9 deletions(-)

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

I had some problems compiling wireless-next-2.6 as I ran into the problem
described in http://patchwork.kernel.org/patch/68463/ . I assume that the
"CONFIG_KPROBES=n" relies on patch "[PATCH] x86: compile insn.c and inat.c
only for KPROBES", which is not present in wireless-next-2.6. I am using
gawk. For testing I manually applied this patch and disabled kprobes to be
able to build.

Thank you

Reinette


