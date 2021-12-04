Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49AEC433F5
	for <linux-wireless@archiver.kernel.org>; Sat,  4 Dec 2021 11:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353956AbhLDLOW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 4 Dec 2021 06:14:22 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50360 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1350310AbhLDLOV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Dec 2021 06:14:21 -0500
Received: from 91-156-5-105.elisa-laajakaista.fi ([91.156.5.105] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <luca@coelho.fi>)
        id 1mtSwQ-0017RD-9C; Sat, 04 Dec 2021 13:10:55 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Sat,  4 Dec 2021 13:10:41 +0200
Message-Id: <20211204111053.852455-1-luca@coelho.fi>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/12] iwlwifi: updates intended for v5.16 2021-12-04 part 2
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the second set of patches intended for v5.17.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Support some new FW API command versions;
* Fix WGDS revision 3 reading bug;
* Some firmware debugging improvements;
* Fixes for in device configuration structures;
* Improvements in the session protection code;
* Some other small fixes, clean-ups and improvements.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (1):
  iwlwifi: mvm: remove session protection upon station removal

Ilan Peer (2):
  iwlwifi: mvm: Fix wrong documentation for scan request command
  iwlwifi: mvm: Add support for a new version of scan request command

Johannes Berg (1):
  iwlwifi: mvm: add some missing command strings

Luca Coelho (1):
  iwlwifi: add missing entries for Gf4 with So and SoF

Miri Korenblit (1):
  iwlwifi: acpi: fix wgds rev 3 size

Mordechay Goodstein (3):
  iwlwifi: mvm: add support for statistics update version 15
  iwlwifi: mvm: update rate scale in moving back to assoc state
  iwlwifi: fw: add support for splitting region type bits

Mukesh Sisodiya (1):
  iwlwifi: yoyo: support for DBGC4 for dram

Shaul Triebitz (1):
  iwlwifi: mvm: avoid clearing a just saved session protection id

Yaara Baruch (1):
  iwlwifi: swap 1650i and 1650s killer struct names

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  |   2 +-
 .../wireless/intel/iwlwifi/fw/api/commands.h  |   3 +-
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   |  10 +-
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  |  48 ++--
 .../net/wireless/intel/iwlwifi/fw/api/stats.h |  92 +++++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  14 +-
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  18 ++
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  |  10 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   2 +
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   | 261 +++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |  51 ++--
 .../wireless/intel/iwlwifi/mvm/time-event.c   |  12 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  51 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  10 +
 17 files changed, 477 insertions(+), 134 deletions(-)

-- 
2.33.1

