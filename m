Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49853 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab0AHSEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 13:04:32 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/2] iwlwifi fixes for 2.6.33
Date: Fri,  8 Jan 2010 10:04:29 -0800
Message-Id: <1262973871-2483-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two fixes are included. The first problem being fixed is to stop data
transmission when mac80211 indicates that station left IBSS. The second fix
is a companion fix to the one already included as "iwl3945: fix panic in
iwl3945 driver" that also addresses the panic. With this patch the panic is
addressed and we still need to figure out why bad data arrives from device.
This patch also targets stable.

Abhijeet Kolekar (1):
  iwlwifi: disable tx on beacon update notification

Zhu Yi (1):
  iwlwifi: fix iwl_queue_used bug when read_ptr == write_ptr

 drivers/net/wireless/iwlwifi/iwl-core.c |   45 +++++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 +-
 2 files changed, 26 insertions(+), 21 deletions(-)

These patches are also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

I had some problems compiling wireless-2.6 as I ran into the problem
described in http://patchwork.kernel.org/patch/68463/ . I assume that the
"CONFIG_KPROBES=n" relies on patch "[PATCH] x86: compile insn.c and inat.c
only for KPROBES", which is not present in wireless-2.6. I am using
gawk. For testing I manually applied this patch and disabled kprobes to be
able to build.

Thank you

Reinette



