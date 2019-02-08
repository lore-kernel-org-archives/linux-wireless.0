Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01003C282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C998D21919
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfBHKrU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:47:20 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56932 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726081AbfBHKrT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 05:47:19 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gs3gj-0002jg-8q; Fri, 08 Feb 2019 12:47:18 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 12:46:52 +0200
Message-Id: <20190208104712.16210-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/20] iwlwifi: updates intended for v5.1 2019-02-08
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the eighth set of patches intended for v5.1.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Yet more Work on the new debugging infrastructure;
* Some more FTM work;
* Work on the new device family continues;
* Bump supported FW API to 46;
* General bugfixes;
* Other cleanups;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Avraham Stern (3):
  iwlwifi: mvm: add support for new FTM fw API
  iwlwifi: mvm: add debug prints for FTM
  iwlwifi: mvm: stop static queues correctly

Emmanuel Grumbach (1):
  iwlwifi: mvm: fix the spatial reuse parsing for HE_TRIG PPDUs

Haim Dreyfuss (1):
  iwlwifi: mvm: add support for 32kHz external clock indication

Ilan Peer (3):
  iwiwifi: mvm: Fix FW scan concurrency support assumptions
  iwlwifi: mvm: Don't warn on command failure during restart
  iwlwifi: mvm: Do not return an error value on HW restart

Johannes Berg (2):
  iwlwifi: bump FW API to 46 for 9000 and 22000 series
  iwlwifi: mvm: fix HE radiotap data4 for HE-TB PPDUs

Luca Coelho (1):
  iwlwifi: start using B-step for some 9000 devices

Sara Sharon (1):
  iwlwifi: pcie: fix TX while flushing

Shahar S Matityahu (5):
  iwlwifi: mvm: add a debug_enable op
  iwlwifi: properly use delay option in dump trigger flow
  iwlwifi: dbg_ini: enable ignore consecutive trigger feature
  iwlwifi: dbg: buffer overflow in non_collect_ts_start array
  iwlwifi: dbg_ini: add early and after alive apply points to unified
    images

Shaul Triebitz (3):
  iwlwifi: dbg: temporarily skip periphery dump for AX210 devices
  iwlwifi: align to new periphery address space for AX210 family
  iwlwifi: add force NMI for AX210 devices

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  48 ++-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  |  32 ++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  |  22 +-
 .../wireless/intel/iwlwifi/fw/api/location.h  | 181 ++++++++-
 .../net/wireless/intel/iwlwifi/fw/api/power.h |  13 +-
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  29 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  57 ++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   5 +
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   7 +-
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   |  11 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h   |  43 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |   7 +-
 .../wireless/intel/iwlwifi/mvm/constants.h    |   3 +
 .../intel/iwlwifi/mvm/ftm-initiator.c         | 362 ++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  15 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  21 +
 .../net/wireless/intel/iwlwifi/mvm/power.c    |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  26 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |   9 +-
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       |  15 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |   8 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |  10 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  88 +++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  10 +
 31 files changed, 820 insertions(+), 249 deletions(-)

-- 
2.20.1

