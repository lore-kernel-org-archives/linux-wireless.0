Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48873 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbaCJNuk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 09:50:40 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 0/2] Add SRAM dump utility through udef
Date: Mon, 10 Mar 2014 15:48:21 +0200
Message-Id: <1394459303-11074-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140310_145043_647443_D1954042)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is very useful to have a dump of the device's SRAM when
the firmware asserts to ba eblt analyze the problem.

This small patch series allows to read the SRAM from the
device when an error occurs, and to save it aside. Then we
send a udev event that can trigger a script which will read
the data through debugfs. Going through userspace (udev)
allows us to reach the file system which is the purpose.
Today the SRAM is 80KB big so that we will have 80KB per
assert. This should compress really well though.

I send this series as a RFC for distributions. Would you use this?

Emmanuel Grumbach (2):
  iwlwifi: mvm: send udev event when ASSERT occur for SRAM dump
  iwlwifi: mvm: create a firmware error dump format

 drivers/net/wireless/iwlwifi/mvm/debugfs.c       |  51 +++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h | 106 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      |   7 ++
 drivers/net/wireless/iwlwifi/mvm/mvm.h           |   6 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c           |  36 +++++++-
 drivers/net/wireless/iwlwifi/mvm/utils.c         |  27 +++---
 7 files changed, 214 insertions(+), 20 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h

-- 
1.8.3.2

