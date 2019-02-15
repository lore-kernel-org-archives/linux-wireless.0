Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26589C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F148721929
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393743AbfBOLtc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:49:32 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60364 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726168AbfBOLtb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:49:31 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gubzl-0008TN-1R; Fri, 15 Feb 2019 13:49:29 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Feb 2019 13:49:04 +0200
Message-Id: <20190215114924.2545-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/20] iwlwifi: updates intended for v5.1 2019-02-15
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the nineth set of patches intended for v5.1.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Some small fixes in the new debugging infrastructure;
* Greg's debugfs clean-ups;
* Some janitorial patches from the community;
* Fix to one false-positive compiler warning;
* NSS suuport;
* Other general bugfixes and cleanups;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Andrei Otcheretianski (1):
  iwlwifi: mvm: Set TX_CMD_FLG_PROT_REQUIRE correctly

Arnd Bergmann (1):
  iwlwifi: fix false-positive maybe-uninitialized warning

Greg Kroah-Hartman (3):
  iwlwifi: dvm: no need to check return value of debugfs_create
    functions
  iwlwifi: fw: no need to check return value of debugfs_create functions
  iwlwifi: iwl-drv: no need to check return value of debugfs_create
    functions

Gustavo A. R. Silva (2):
  iwlwifi: eeprom-parse: use struct_size() in kzalloc()
  iwlwifi: nvm-parse: use struct_size() in kzalloc()

Ilan Peer (2):
  iwlwifi: mvm: Don't request HW restart if already requested
  iwlwifi: mvm: Allow retries for probe responses

Johannes Berg (4):
  iwlwifi: mvm: fix error path in iwl_mvm_mac_setup_register()
  iwlwifi: nvm-parse: advertise IEEE80211_VHT_EXT_NSS_BW_CAPABLE in VHT
  iwlwifi: mvm: remove IWL_MVM_INIT_STATUS_REG_HW_INIT_COMPLETE
  iwlwifi: mvm: implement VHT extended NSS support in rs.c

Liad Kaufman (1):
  iwlwifi: mvm: add read debugfs for he_sniffer_params

Sara Sharon (3):
  iwlwifi: mvm: reject new beacons when in inject mode
  iwlwifi: mvm: support non-transmitting AP
  iwlwifi: mvm: add some debug data to TX path

Shahar S Matityahu (2):
  iwlwifi: remove redundant condition from prior alive dump flow
  iwlwifi: dbg_ini: fix infinite time ignore consecutive dumps

Triebitz (1):
  iwlwifi: pcie: allocate rb_stts's for all queues in one place

 drivers/net/wireless/intel/iwlwifi/dvm/agn.h  |  9 +--
 .../net/wireless/intel/iwlwifi/dvm/debugfs.c  | 44 ++-----------
 drivers/net/wireless/intel/iwlwifi/dvm/main.c |  5 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 18 -----
 .../net/wireless/intel/iwlwifi/fw/debugfs.c   | 11 +---
 .../net/wireless/intel/iwlwifi/fw/debugfs.h   |  9 +--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  | 22 -------
 .../wireless/intel/iwlwifi/iwl-eeprom-parse.c |  3 +-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 25 ++++---
 .../wireless/intel/iwlwifi/mvm/constants.h    |  1 +
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  | 32 +++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  8 +--
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  8 +++
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 18 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  8 +--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   | 23 ++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 27 +++++---
 .../wireless/intel/iwlwifi/pcie/internal.h    |  9 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 66 ++++++++++++++-----
 20 files changed, 183 insertions(+), 166 deletions(-)

-- 
2.20.1

