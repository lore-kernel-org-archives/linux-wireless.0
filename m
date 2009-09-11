Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49357 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbZIKRiR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 13:38:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/13] iwlwifi driver updates 09/11/2009
Date: Fri, 11 Sep 2009 10:38:06 -0700
Message-Id: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series we include a few fixes for 2.6.32. It also contains some
cleanup and preparation work for new hardware.

The fixes for 2.6.32 are:
- patch 2/13 fixes the problem where stations are not able to use HT rates
and keep using legacy rates
- patch 6/13 fixes buffer loss that occur when system is not able to
allocate an skb. This can happen more often than expected since the driver
attempts skb allocation while in tasklet and thus with GFP_ATOMIC that is
more likely to fail.
- patch 12/13 fixes the problem where we transmit on incorrect antenna
- patch 13/13 even though powersave is default disabled for iwlwifi users
are still able to enable it using iwconfig. We need to prevent this for
4965 since it cannot handle the powersave requests well.

[PATCH 01/13] iwlwifi: modify LED blink index table
[PATCH 02/13 v2.6.32 and w-t] iwlwifi: fix HT operation in 2.4 GHz band
[PATCH 03/13] iwlwifi: remove un-supported eeprom parameters
[PATCH 04/13] iwlwifi: separate nic_config for different NIC
[PATCH 05/13] iwlwifi: separate set_hw_params function for 6000 series
[PATCH 06/13 v2.6.32 and w-t] iwlwifi: fix potential rx buffer loss
[PATCH 07/13] iwlwifi: clean up ht config a little
[PATCH 08/13] iwlwifi: Adjust blink rate to compensate Clock difference
[PATCH 09/13] iwlwifi: clean up ht config naming
[PATCH 10/13] iwlwifi: show NVM version in debugfs
[PATCH 11/13] iwlwifi: clarify and clean up chain settings
[PATCH 12/13 v2.6.32 and w-t] iwlwifi: find the correct first antenna
[PATCH 13/13 v2.6.32 and w-t] iwlwifi: disable powersave for 4965


Thank you

Reinette

