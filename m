Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABA3C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20977218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfAaUWQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:22:16 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53524 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725802AbfAaUWQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:22:16 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIqk-0004pL-7v; Thu, 31 Jan 2019 22:22:14 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:21:45 +0200
Message-Id: <20190131202206.15903-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/21] iwlwifi: updates intended for v5.1 2019-01-31
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the sixth set of patches intended for v5.1.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* More work on the new debugging infrastructure;
* HE radiotap;
* More fixes for static analyzer reported issues;
* General bugfixes;
* Other cleanups and small fixes;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.



Avigail Grinstein (1):
  iwlwifi: mvm: support absolute thresholds in bf configuration

Johannes Berg (8):
  iwlwifi: mvm: remove redundant condition
  iwlwifi: dvm: use %u for sscanf() into unsigned variable
  iwlwifi: mvm: add HE TB PPDU SIG-A BW to radiotap
  iwlwifi: move config structs to C file
  iwlwifi: mvm: don't hide HE radiotap data in SKB
  iwlwifi: refactor NIC init sequence
  iwlwifi: mvm: fix RFH config command with >=10 CPUs
  iwlwifi: implement BISR HW workaround for 22260 devices

Liad Kaufman (2):
  iwlwifi: mvm: add tlc command name to output
  iwlwifi: mvm: config mac ctxt to HE before TLC

Naftali Goldstein (1):
  iwlwifi: mvm: add description to second BAD_COMMAND assert number

Sara Sharon (2):
  iwlwifi: mvm: limit AMSDU size to 8K
  iwlwifi: mvm: fix RSS config command

Shahar S Matityahu (7):
  iwlwifi: dbg_ini: remove redundant dram buffer allocation
  iwlwifi: dbg_ini: align struct iwl_fw_ini_region_cfg to the FW
  iwlwifi: dbg_ini: create new dump flow and implement prph dump
  iwlwifi: dbg_ini: implement csr memory dump
  iwlwifi: dbg_ini: implement device internal memory dump
  iwlwifi: dbg_ini: implement paging memory dump
  iwlwifi: fix send hcmd timeout recovery flow

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   3 +
 .../net/wireless/intel/iwlwifi/dvm/debugfs.c  |   3 +-
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   |  40 +-
 .../net/wireless/intel/iwlwifi/fw/api/power.h |  11 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 450 ++++++++++++------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |   4 +
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  42 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   3 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h   |  19 +-
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  35 +-
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  |  23 +-
 .../wireless/intel/iwlwifi/iwl-eeprom-read.c  |  47 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   |  72 +++
 drivers/net/wireless/intel/iwlwifi/iwl-io.h   |   5 +
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  18 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  32 +-
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |   3 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   1 +
 .../net/wireless/intel/iwlwifi/mvm/power.c    |  20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  68 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |   8 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  19 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info.c   |   6 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |  19 +-
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |  21 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 102 ++--
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |   8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |   8 +-
 include/net/ieee80211_radiotap.h              |   6 +
 32 files changed, 716 insertions(+), 393 deletions(-)

-- 
2.20.1

