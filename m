Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DBB5C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F4192077B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbfCOQgn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:36:43 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44218 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728171AbfCOQgn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 12:36:43 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4pp2-0004qp-9C; Fri, 15 Mar 2019 18:36:40 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 18:36:18 +0200
Message-Id: <20190315163634.17315-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/16] iwlwifi: updates intended for v5.1 2019-03-15
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the second set of patches intended for v5.2.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Continued work and bugfixes for the new debugging infra;
* Support for some new FW API versions;
* Some work to support new hardware;
* General bugfixes;
* Other cleanups;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Ilan Peer (1):
  iwlwifi: mvm: Support new format of SCAN_OFFLOAD_PROFILES_QUERY_RSP

Johannes Berg (2):
  iwlwifi: mvm: enable HT/VHT IBSS
  iwlwifi: pcie: switch to correct RBD/CD layout for 22560

Luca Coelho (2):
  mac80211_hwsim: make copying of ciphers safer by checking the length
  iwlwifi: remove unnecessary goto out in iwl_parse_nvm_mcc_info()

Mordechay Goodstein (1):
  iwlwifi: mvm: set max amsdu for TLC offload

Shahar S Matityahu (5):
  iwlwifi: dbg: use dump mask for tx command dumping length
  iwlwifi: mvm: use dump worker during restart instead of sync dump
  iwlwifi: dbg: add DRAM monitor support for AX210 device family
  iwlwifi: dbg_ini: separate between ini and legacy dump flows
  iwlwifi: dbg_ini: align to FW api version 1

Shaul Triebitz (4):
  iwlwifi: mvm: be more forgiving if num of channels is too big
  iwlwifi: add support for 6-7 GHz channels
  iwlwifi: support new NVM response API
  iwlwifi: for AX210 device support radio GF4

YueHaibing (1):
  iwlwifi: Use struct_size() in kzalloc

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   9 +
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   | 177 ++++++++++------
 .../wireless/intel/iwlwifi/fw/api/nvm-reg.h   |  39 +++-
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |  67 +------
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  |  54 ++++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 189 ++++++++++--------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  17 +-
 .../wireless/intel/iwlwifi/fw/error-dump.h    |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   7 +
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   1 +
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |   5 +-
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  |  10 +-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 139 +++++++------
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |   6 +
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   1 -
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |  90 +++++++--
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  13 --
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   2 +
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    |  44 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |  25 ++-
 .../wireless/intel/iwlwifi/pcie/internal.h    |  30 +--
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |  13 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  38 +++-
 drivers/net/wireless/mac80211_hwsim.c         |  12 +-
 27 files changed, 628 insertions(+), 385 deletions(-)

-- 
2.20.1

