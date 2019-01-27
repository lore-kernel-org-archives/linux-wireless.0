Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A88C282C0
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B630F2146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfA0KTW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:19:22 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51268 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726516AbfA0KTW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:19:22 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhX5-0001vC-PG; Sun, 27 Jan 2019 12:19:20 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:18:47 +0200
Message-Id: <20190127101908.6428-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/21] iwlwifi: updates intended for v5.1 2019-01-27
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the fourth set of patches intended for v5.1.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Reworked the TOF/CSI implementation;
* Work on new debugging infra continues;
* Some product name updates in the human-readable strings
* General bugfixes;
* Other cleanups and small fixes;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Andrei Otcheretianski (1):
  iwlwifi: mvm: Disconnect on large beacon loss

David Spinadel (1):
  iwlwifi: mvm: Change FW channel info API

Emmanuel Grumbach (1):
  iwlwifi: mvm: freeze management TXQ timer when station goes to sleep

Ihab Zhaika (1):
  iwlwifi: update product name for 9260 and 9560

Johannes Berg (8):
  iwlwifi: mvm: fix A-MPDU reference assignment
  iwlwifi: remove TOF implementation
  iwlwifi: dvm: remove useless condition
  iwlwifi: pcie: use u32* argument to iwl_trans_get_fw_monitor_len()
  iwlwifi: mvm: add location APIs
  iwlwifi: mvm: implement CSI reporting
  iwlwifi: mvm: document monitor mode reorder buffer bypass
  iwlwifi: mvm: include configured sniffer AID in radiotap

Mordechay Goodstein (1):
  iwlwifi: mvm: disable completely low latency mode with debugfs

Sara Sharon (1):
  iwlwifi: mvm: get rid of tx_path_lock

Shahar S Matityahu (6):
  iwlwifi: trigger dump on assert prior to setting the device up
  iwlwifi: dbg_ini: allocate dram buffer with proper flags
  iwlwifi: dbg_ini: properly handle ini user trigger
  iwlwifi: dbg_ini: retrieve dump_delay value properly
  iwlwifi: dbg_ini: set dump mask BIT(n) instead of n
  iwiwifi: fix bad monitor buffer register addresses

Shaul Triebitz (1):
  iwlwifi: mvm: update firmware when MU EDCA params change

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   6 +
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |  29 +
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c   |   5 +-
 .../wireless/intel/iwlwifi/fw/api/commands.h  |  15 +-
 .../wireless/intel/iwlwifi/fw/api/datapath.h  |  55 ++
 .../wireless/intel/iwlwifi/fw/api/location.h  | 711 +++++++++++++++
 .../wireless/intel/iwlwifi/fw/api/phy-ctxt.h  |  51 +-
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |   2 +
 .../net/wireless/intel/iwlwifi/fw/api/tdls.h  |  19 +-
 .../intel/iwlwifi/fw/api/time-event.h         |  34 +-
 .../net/wireless/intel/iwlwifi/fw/api/tof.h   | 393 ---------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  16 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  12 +-
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   5 +
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/Makefile   |   1 -
 .../wireless/intel/iwlwifi/mvm/debugfs-vif.c  | 813 +-----------------
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |  45 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api.h   |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |   5 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  88 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  | 135 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  26 +-
 .../net/wireless/intel/iwlwifi/mvm/phy-ctxt.c |  24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  63 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c |  33 +-
 .../wireless/intel/iwlwifi/mvm/time-event.c   |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tof.c  | 305 -------
 drivers/net/wireless/intel/iwlwifi/mvm/tof.h  |  89 --
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 188 ++--
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |   2 +-
 32 files changed, 1380 insertions(+), 1806 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/location.h
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/tof.h
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/tof.c
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/tof.h

-- 
2.20.1

