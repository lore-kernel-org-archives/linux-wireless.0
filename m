Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF0C7C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C276C2080D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbfBFLR3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:17:29 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55674 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726914AbfBFLR3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 06:17:29 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grLCp-0001ED-0A; Wed, 06 Feb 2019 13:17:27 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  6 Feb 2019 13:17:06 +0200
Message-Id: <20190206111721.29283-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/15] cfg80211/mac80211 patches from our internal tree 2019-02-06
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Some patches with mac80211 and cfg80211 changes from our internal
tree.

Please review, though you have already reviewed most if not all of
them ;)

Cheers,
Luca.


Adiel Aloni (1):
  mac80211: shorten debug print to avoid warning

Aviya Erenfeld (1):
  nl80211: Fix FTM per burst maximum value

Ilan Peer (1):
  mac80211: Fix Tx aggregation session tear down with ITXQs

Johannes Berg (5):
  cfg80211: pmsr: record netlink port ID
  radiotap: add 0-length PSDU "not captured" type
  mac80211: call drv_ibss_join() on restart
  cfg80211: prevent speculation on cfg80211_classify8021d() return
  cfg80211: allow sending vendor events unicast

Liad Kaufman (2):
  mac80211: fix position of vendor_data read
  mac80211: update HE IEs to D3.3

Sara Sharon (5):
  mac80211: support max channel switch time element
  mac80211: abort CSA if beacon does not include CSA IEs
  mac80211: notify driver on subsequent CSA beacons
  mac80211: allow CSA to self with immediate quiet
  mac80211: ignore quiet mode in probe

 .../net/wireless/intel/iwlwifi/fw/api/mac.h   | 26 ++++++-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 58 ++++++---------
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 40 +++++++++++
 include/linux/ieee80211.h                     | 23 ++++--
 include/net/cfg80211.h                        | 49 ++++++++++++-
 include/net/ieee80211_radiotap.h              |  3 +-
 include/net/mac80211.h                        | 18 ++++-
 net/mac80211/agg-tx.c                         |  4 +-
 net/mac80211/debugfs_sta.c                    | 35 ++++++---
 net/mac80211/driver-ops.h                     | 31 +++++++-
 net/mac80211/ieee80211_i.h                    |  2 +
 net/mac80211/mlme.c                           | 72 ++++++++++++++-----
 net/mac80211/rx.c                             | 21 +++++-
 net/mac80211/spectmgmt.c                      |  6 ++
 net/mac80211/trace.h                          | 46 +++++++++++-
 net/mac80211/util.c                           | 10 ++-
 net/wireless/nl80211.c                        | 32 +++++++--
 net/wireless/pmsr.c                           |  1 +
 net/wireless/util.c                           | 35 ++++++---
 19 files changed, 409 insertions(+), 103 deletions(-)

-- 
2.20.1

