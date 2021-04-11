Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6C1C433ED
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Apr 2021 10:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 214206103D
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Apr 2021 10:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbhDKK0E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Apr 2021 06:26:04 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44494 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229804AbhDKK0E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Apr 2021 06:26:04 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.lan)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1lVXHl-000K0H-5x; Sun, 11 Apr 2021 13:25:46 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Sun, 11 Apr 2021 13:25:37 +0300
Message-Id: <20210411102545.438654-1-luca@coelho.fi>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 0/8] iwlwifi: updates intended for v5.13 2021-04-11-2
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the fourth set of patches intended for v5.13.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Bump the FW API version support for AX devices;
* One more CSA fix;
* Some other small fixes, clean-ups and improvements.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (2):
  iwlwifi: mvm: don't disconnect immediately if we don't hear beacons
    after CSA
  iwlwifi: mvm: don't WARN if we can't remove a time event

Johannes Berg (2):
  iwlwifi: trans/pcie: defer transport initialisation
  iwlwifi: fw: print out trigger delay when collecting data

Krishnanand Prabhu (1):
  iwlwifi: mvm: add support for timing measurement

Luca Coelho (1):
  iwlwifi: bump FW API to 63 for AX devices

Matti Gottlieb (1):
  iwlwifi: pcie: Change ma product string name

Mukesh Sisodiya (1):
  iwlwifi: dbg:  disable ini debug in 9000 family and below

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  4 +-
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  2 +-
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  |  5 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.c    | 91 +++++++++++--------
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  1 +
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 39 +++++++-
 .../wireless/intel/iwlwifi/mvm/time-event.c   | 17 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 10 +-
 9 files changed, 118 insertions(+), 55 deletions(-)

-- 
2.31.0

