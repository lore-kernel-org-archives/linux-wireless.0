Return-Path: <SRS0=wMe8=VF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D7FC606C1
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Jul 2019 15:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C9AB216F4
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Jul 2019 15:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387874AbfGHPzo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Jul 2019 11:55:44 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54324 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731637AbfGHPzo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jul 2019 11:55:44 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hkVzP-0000OC-Tj; Mon, 08 Jul 2019 18:55:41 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Jul 2019 18:55:32 +0300
Message-Id: <20190708155534.18241-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 0/2] iwlwifi: fixes intended for 5.3 2019-07-08
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the first patchset with fixes for v5.3.

The changes are:

* A few new PCI IDs for 9000 and 22000 series;
* Support for C-step 22000 devices;

As usual, I'm pushing this to a pending branch, for kbuild bot.  And
as we agreed, I'll delegate these patches to you in patchwork for you
to apply them directly.  There's no hurry with this, I know we're
still in the merge window, I just wanted to send them out for people
who have these devices and are having problems.  It's your call:
either send them during the merge window, if you send a new pull-req;
or take it when the merge window closes, for v5.3-rc1.

Note: all this area will probably have some conflicts when merging
with -next, because I've been sending new PCI IDs and such things for
fixes, while some other changes are being made for -next.  Let me know
if you need any help merging, when time comes.

Cheers,
Luca.


Ihab Zhaika (1):
  iwlwifi: add new cards for 9000 and 20000 series

Luca Coelho (1):
  iwlwifi: pcie: add support for qu c-step devices

 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 53 +++++++++++++++++++
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  7 +++
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |  2 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 23 ++++++++
 4 files changed, 85 insertions(+)

-- 
2.20.1

