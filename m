Return-Path: <SRS0=ssZ+=5L=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31362C43331
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Mar 2020 12:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05CF120714
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Mar 2020 12:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgCZMA7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 26 Mar 2020 08:00:59 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44082 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727991AbgCZMA7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Mar 2020 08:00:59 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jHRBw-0003we-DY; Thu, 26 Mar 2020 14:00:57 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 26 Mar 2020 14:00:30 +0200
Message-Id: <20200326120042.578777-1-luca@coelho.fi>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/12] cfg80211/mac80211 patches from our internal tree 2020-03-26
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

A bunch of patches with mac80211 and cfg80211 changes from our
internal tree.

Please review, though you have already reviewed most if not all of
them ;)

Cheers,
Luca.


Andrei Otcheretianski (1):
  mac80211: Don't destroy auth data in case of anti-clogging

Ilan Peer (4):
  cfg80211: Parse HE membership selector
  mac80211: Skip entries with HE membership selector
  mac80211: Fail association when AP has no legacy rates
  cfg80211: Do not warn on same channel at the end of CSA

Johannes Berg (4):
  mac80211: implement Operating Mode Notification extended NSS support
  mac80211: minstrel_ht_assign_best_tp_rates: remove redundant test
  mac80211_hwsim: indicate in IBSS that we have transmitted beacons
  mac80211: drop data frames without key on encrypted links

Mordechay Goodstein (2):
  mac80211: agg-tx: refactor sending addba
  mac80211: agg-tx: add an option to defer ADDBA transmit

Shaul Triebitz (1):
  mac80211: add twt_protected flag to the bss_conf structure

 drivers/net/wireless/intel/iwlwifi/mvm/rs.c |  6 +-
 drivers/net/wireless/mac80211_hwsim.c       |  6 ++
 include/linux/ieee80211.h                   | 13 +++-
 include/net/cfg80211.h                      |  3 +-
 include/net/mac80211.h                      |  8 ++-
 net/mac80211/agg-tx.c                       | 79 +++++++++++++--------
 net/mac80211/debugfs_sta.c                  |  3 +-
 net/mac80211/key.c                          | 20 +++---
 net/mac80211/mlme.c                         | 33 +++++++--
 net/mac80211/rc80211_minstrel_ht.c          |  3 +-
 net/mac80211/sta_info.h                     |  3 +
 net/mac80211/tx.c                           | 12 +++-
 net/mac80211/vht.c                          | 10 ++-
 net/wireless/nl80211.c                      |  2 +
 net/wireless/scan.c                         |  6 +-
 net/wireless/util.c                         | 26 +++----
 16 files changed, 163 insertions(+), 70 deletions(-)

-- 
2.25.1

