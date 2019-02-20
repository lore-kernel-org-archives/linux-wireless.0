Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA459C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7703E206DD
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfBTMEI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:04:08 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34492 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726354AbfBTMEI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 07:04:08 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gwQbe-000411-1A; Wed, 20 Feb 2019 14:04:06 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 20 Feb 2019 14:03:52 +0200
Message-Id: <20190220120400.8814-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 0/8] iwlwifi: updates intended for v5.1 2019-02-20
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the tenth and final set of patches intended for v5.1.  This one
is mostly to add some new PCI IDs and to align with an internal
version we tested.

The changes are:

* New PCI IDs for 9260 and 22000 series;
* Continued work on the new debugging mechanism;


As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.



Ihab Zhaika (2):
  iwlwifi: add new card for 9260 series
  iwlwifi: add new cards for 22000 and killer series and change the
    market name

Shahar S Matityahu (6):
  iwlwifi: dbg_ini: add print to iwl_dump_ini_mem in case of invalid
    range
  iwlwifi: dbg_ini: make memory dump get_size handler include headers
  iwlwifi: dbg_ini: make fill_range handler accept generic range pointer
  iwlwifi: dbg_ini: add region to fill_header handler
  iwlwifi: dbg_ini: implement Tx fifos dump
  iwlwifi: dbg_ini: implement Rx fifos dump

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   8 +-
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   |  13 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 490 +++++++++++++++---
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  32 +-
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   1 +
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  99 ++--
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |   4 +-
 8 files changed, 507 insertions(+), 142 deletions(-)

-- 
2.20.1

