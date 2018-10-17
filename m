Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E51AECDE32
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 19:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65032213A2
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 19:29:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65032213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbeJRD0j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 23:26:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:10315 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbeJRD0j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 23:26:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2018 12:29:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,393,1534834800"; 
   d="scan'208";a="266547712"
Received: from jprestwo.jf.intel.com ([10.54.74.38])
  by orsmga005.jf.intel.com with ESMTP; 17 Oct 2018 12:29:29 -0700
From:   James Prestwood <james.prestwood@linux.intel.com>
To:     linux-wireless@vger.kernel.org
Cc:     James Prestwood <james.prestwood@linux.intel.com>
Subject: [PATCH v2 0/2] Configuring iftype/cipher support
Date:   Wed, 17 Oct 2018 12:33:05 -0700
Message-Id: <20181017193307.1780-1-james.prestwood@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is V2 of my original patch, but a lot has changed:

- (extended) feature support has been completely removed due to
  (extended) features being set in core driver code. There was
  no way to set all (extended) features in JUST mac80211_hwsim.

- Iftype support was changed to a bit mask, and checks were added
  to ensure only iftypes that mac80211_hwsim already supported
  were allowed to be enabled/disabled. The interface limit rules
  are now built dynamically rather than being static structures.
  This was done because limit verification code complains if you
  have a limit rule for an iftype that you do not support.

- A new patch was added to allow supported ciphers to be configured.


James Prestwood (2):
  mac80211_hwsim: allow setting iftype support
  mac80211_hwsim: allow configurable cipher types

 drivers/net/wireless/mac80211_hwsim.c | 218 ++++++++++++++++++--------
 drivers/net/wireless/mac80211_hwsim.h |   4 +
 2 files changed, 156 insertions(+), 66 deletions(-)

-- 
2.17.1

