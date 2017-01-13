Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34686 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751654AbdAMMkL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 07:40:11 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Jan 2017 14:39:13 +0200
Message-Id: <20170113123919.30384-1-luca@coelho.fi> (sfid-20170113_134130_988107_232C7B98)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 0/6] iwlwifi: updates intended for v4.10 2017-01-13
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here are a few fixes that I intend to send for v4.10:

* fix suspend failure with unified firmware images
* fix a potential crash when dumping debug data
* fix a couple of mistakes in FW names exported by the modules
* small fix for PS-Poll enabling via debugfs
* fix for dynamic queue allocation offchannel data

I'll wait for kbuildbot results and then I'll send a pull-request for
them.

Cheers,
Luca.

Beni Lev (1):
  iwlwifi: mvm: Use aux queue for offchannel frames in dqa

Emmanuel Grumbach (1):
  iwlwifi: mvm: fix PS-Poll enablement

Johannes Berg (1):
  iwlwifi: mvm: properly check for transport data in dump

Jürg Billeter (2):
  iwlwifi: fix double hyphen in MODULE_FIRMWARE for 8000
  iwlwifi: fix MODULE_FIRMWARE for 6030

Luca Coelho (1):
  iwlwifi: mvm: don't restart HW if suspend fails with unified image

 drivers/net/wireless/intel/iwlwifi/iwl-6000.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c     | 13 ++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 11 ++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/power.c  | 18 ++++++++----------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c     | 10 ++++++----
 6 files changed, 30 insertions(+), 26 deletions(-)

-- 
2.11.0
