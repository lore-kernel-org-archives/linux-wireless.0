Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbZJIUVM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:21:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/17] iwlwifi driver updates 10/9/2009
Date: Fri,  9 Oct 2009 13:20:16 -0700
Message-Id: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series we include the following fixes targeting 2.6.32:
1/17 prevents a potential null pointer exception if a particular error
path is hit during module probe
2/17 and 3/17 combine to address a serious problem with powersaving. We
have discovered that when the interface is downed the device keeps
consuming peak power. This is because in these cases the power saving state
is just reset based on a (wrong) assumption that the interface will be
brought back up shortly. Patch 2/17 ensures that the power initialization
is done correctly for 3945 to be able to accomodate initialization after a
complete stop while patch 3/17 tells the device to stop when interface goes
down.

Patch 2/17 is provided in two versions, one that applies cleanly on
wireless-testing and another that applies cleanly on v2.6.32.

The rest of the series is mostly cleanup. We do have some additions to the
channel switch API.

[PATCH 01/17 v2.6.32 and w-t] iwlwifi: change the order of freeing memory
[PATCH 02/17 w-t] iwl3945: update iwl3945_apm_init()
[PATCH 02/17 v2.6.32] iwl3945: update iwl3945_apm_init()
[PATCH 03/17 v2.6.32 and w-t] iwlwifi: turn off device when not used.
[PATCH 04/17] iwl3945: remove unnecessary call to apm_ops.reset()
[PATCH 05/17] iwlagn, iwl3945: remove apm_reset() functions
[PATCH 06/17] iwlwifi: remove duplicated/unused definition
[PATCH 07/17] iwlwifi: additional items in sensitivity range table
[PATCH 08/17] iwlwifi: fix userspace setting of sleep_level_override
[PATCH 09/17] iwl3945: streamline iwl3945_rfkill_poll()
[PATCH 10/17] iwl3945: move iwl_power_initialize()
[PATCH 11/17] iwlwifi: dynamic allocate tx queue structure
[PATCH 12/17] iwlwifi: showing accumulative ucode statistics counters
[PATCH 13/17] iwlwifi/iwl3945: unify rts_tx_cmd_flag
[PATCH 14/17] iwl3945: rename tx to tx_cmd
[PATCH 15/17] iwlwifi/iwl3945: remove data_retry_limit
[PATCH 16/17] iwl3945: rearrange the code.
[PATCH 17/17] iwlwifi: update channel switch command API


Reinette
