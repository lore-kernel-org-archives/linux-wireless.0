Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21043 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab0FFG4N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:13 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/4] iwlwifi fixes fo 2.6.35
Date: Sat,  5 Jun 2010 23:55:59 -0700
Message-Id: <1275807363-18150-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include four fixes. This series includes the overdue 3945 fix to
internal scanning. The system hang issue fixed by this patch is
encountered by many people, see:
http://thread.gmane.org/gmane.linux.kernel/994562
http://thread.gmane.org/gmane.linux.kernel.wireless.general/51343
http://thread.gmane.org/gmane.linux.kernel.wireless.general/51614
http://thread.gmane.org/gmane.linux.kernel/992191/focus=51561

We include a second fix for iwl3945 that enables a workaround to detect and
recover when the command queue, or a transmit queue, becomes stuck.
Unfortunately users seem to be running into this issue more frequently now.
The bugs related to this issue is noted in the commit message.

A third fix addresses a lockdep warning.

We also include an update to the MAINTAINERS file that we would like to
include in 2.6.35 since Wey-Yi will be maintainer during this
kernel's stabilization as well as thereafter.

These patches are also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Abhijeet Kolekar (1):
  iwl3945: fix internal scan

Emmanuel Grumbach (1):
  iwlwifi: move sysfs_create_group to post request firmware

Reinette Chatre (1):
  iwl3945: enable stuck queue detection on 3945

Wey-Yi Guy (1):
  iwlwifi: add name to Maintainers list

 MAINTAINERS                                 |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   30 +---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  318 +++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   39 ++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   56 +++++-
 7 files changed, 257 insertions(+), 190 deletions(-)

