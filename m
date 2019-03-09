Return-Path: <SRS0=krUy=RM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED93AC43381
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C366D20866
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfCIJWo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Mar 2019 04:22:44 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41766 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725764AbfCIJWo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Mar 2019 04:22:44 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h2YBl-0000qV-RG; Sat, 09 Mar 2019 11:22:42 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat,  9 Mar 2019 11:22:29 +0200
Message-Id: <20190309092237.10294-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 0/8] iwlwifi: updates intended for v5.2 2019-03-09
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the first set of patches intended for v5.2.  This one only
contains some patches that were pending on mac80211/cfg80211/radiotap
patches being merged.  Now that the all the dependencies are in place,
the iwlwifi patches can be merged.

The changes are:

    * Send NO_DATA events so they can be captured in radiotap;
    * Some channel-switch changes;
    * Support for multiple BSSID;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Johannes Berg (1):
  iwlwifi: mvm: report all NO_DATA events to mac80211

Sara Sharon (7):
  iwlwifi: mvm: report delayed beacon count to FW
  iwlwifi: mvm: implement CSA abort
  iwlwifi: mvm: track CSA beacons
  iwlwifi: mvm: notify FW on quiet mode in CSA
  iwlwifi: mvm: disconnect in case of bad channel switch parameters
  iwlwifi: mvm: track changes in beacon count during channel switch
  iwlwifi: mvm: support multiple BSSID

 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   2 +
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |   7 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 190 ++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  31 ++-
 .../wireless/intel/iwlwifi/mvm/time-event.c   |   5 +-
 7 files changed, 187 insertions(+), 65 deletions(-)

-- 
2.20.1

