Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0FAC10F14
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 12:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1B3E217D7
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 12:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388903AbfDRMPx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 08:15:53 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53906 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388858AbfDRMPw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 08:15:52 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hH5xE-0007X3-JM; Thu, 18 Apr 2019 15:15:49 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 18 Apr 2019 15:15:40 +0300
Message-Id: <20190418121544.32040-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 0/4] iwlwifi: fixes intended for 5.1 2019-04-18
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the third patchset with fixes for 5.1.

The changes are:

* Fix an oops when creating debugfs entries;
* Fix bug when trying to capture debugging info while in rfkill;
* Prevent potential uninitialized memory dumps into debugging logs;
* Fix some initialization parameters for AX210 devices;

Not in this series, but sent before separately:

* Fix an oops with non-MSIX devices;


As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Greg Kroah-Hartman (1):
  iwlwifi: mvm: properly check debugfs dentry before using it

Johannes Berg (1):
  iwlwifi: mvm: don't attempt debug collection in rfkill

Shahar S Matityahu (1):
  iwlwifi: dbg_ini: check debug TLV type explicitly

Shaul Triebitz (1):
  iwlwifi: cfg: use family 22560 based_params for AX210 family

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h      | 15 +++++++++------
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  |  3 ++-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c  |  5 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |  4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  2 +-
 6 files changed, 21 insertions(+), 10 deletions(-)

-- 
2.20.1

