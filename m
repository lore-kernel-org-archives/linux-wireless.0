Return-Path: <SRS0=jiki=YB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55215C10F14
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Oct 2019 12:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ECCD20679
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Oct 2019 12:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730834AbfJHMba (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Oct 2019 08:31:30 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:37682 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730301AbfJHMba (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Oct 2019 08:31:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iHoeA-0006bp-DF; Tue, 08 Oct 2019 14:31:22 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-10-08
Date:   Tue,  8 Oct 2019 14:31:10 +0200
Message-Id: <20191008123111.4019-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

Another week, another set of fixes.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 3afb0961884046c8fb4acbce65139088959681c8:

  tcp: fix slab-out-of-bounds in tcp_zerocopy_receive() (2019-10-03 12:05:34 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2019-10-08

for you to fetch changes up to dc0c18ed229cdcca283dd78fefa38273ec37a42c:

  mac80211: fix scan when operating on DFS channels in ETSI domains (2019-10-07 22:10:50 +0200)

----------------------------------------------------------------
A number of fixes:
 * allow scanning when operating on radar channels in
   ETSI regdomains
 * accept deauth frames in IBSS - we have code to parse
   and handle them, but were dropping them early
 * fix an allocation failure path in hwsim
 * fix a failure path memory leak in nl80211 FTM code
 * fix RCU handling & locking in multi-BSSID parsing
 * reject malformed SSID in mac80211 (this shouldn't
   really be able to happen, but defense in depth)
 * avoid userspace buffer overrun in ancient wext code
   if SSID was too long

----------------------------------------------------------------
Aaron Komisar (1):
      mac80211: fix scan when operating on DFS channels in ETSI domains

Johannes Berg (1):
      mac80211: accept deauth frames in IBSS mode

Michael Vassernis (1):
      mac80211_hwsim: fix incorrect dev_alloc_name failure goto

Navid Emamdoost (1):
      nl80211: fix memory leak in nl80211_get_ftm_responder_stats

Sara Sharon (1):
      cfg80211: fix a bunch of RCU issues in multi-bssid code

Will Deacon (2):
      mac80211: Reject malformed SSID elements
      cfg80211: wext: avoid copying malformed SSIDs

 drivers/net/wireless/mac80211_hwsim.c |  2 +-
 include/net/cfg80211.h                |  8 ++++++++
 net/mac80211/mlme.c                   |  5 +++--
 net/mac80211/rx.c                     | 11 ++++++++++-
 net/mac80211/scan.c                   | 30 ++++++++++++++++++++++++++++--
 net/wireless/nl80211.c                |  2 +-
 net/wireless/reg.c                    |  1 +
 net/wireless/reg.h                    |  8 --------
 net/wireless/scan.c                   | 23 +++++++++++++----------
 net/wireless/wext-sme.c               |  8 ++++++--
 10 files changed, 71 insertions(+), 27 deletions(-)

