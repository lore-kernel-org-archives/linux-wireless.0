Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BAE8C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 11:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6EFE21580
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 11:19:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6EFE21580
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbeI0Rg5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 13:36:57 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54586 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbeI0Rg5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 13:36:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5UK4-0002YO-1t; Thu, 27 Sep 2018 13:19:08 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2018-09-27
Date:   Thu, 27 Sep 2018 13:18:50 +0200
Message-Id: <20180927111851.8058-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

Here's another - unfortunately pretty large - set of fixes
for the current cycle. The changes are pretty simple or even
trivial though.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 28619527b8a712590c93d0a9e24b4425b9376a8c:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-09-04 12:45:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2018-09-27

for you to fetch changes up to 1222a16014888ed9733c11e221730d4a8196222b:

  nl80211: Fix possible Spectre-v1 for CQM RSSI thresholds (2018-09-27 11:44:44 +0200)

----------------------------------------------------------------
More patches than I'd like perhaps, but each seems reasonable:
 * two new spectre-v1 mitigations in nl80211
 * TX status fix in general, and mesh in particular
 * powersave vs. offchannel fix
 * regulatory initialization fix
 * fix for a queue hang due to a bad return value
 * allocate TXQs for active monitor interfaces, fixing my
   earlier patch to avoid unnecessary allocations where I
   missed this case needed them
 * fix TDLS data frames priority assignment
 * fix scan results processing to take into account duplicate
   channel numbers (over different operating classes, but we
   don't necessarily know the operating class)
 * various hwsim fixes for radio destruction and new radio
   announcement messages
 * remove an extraneous kernel-doc line

----------------------------------------------------------------
Andrei Otcheretianski (3):
      mac80211: Always report TX status
      mac80211: Don't wake up from PS for offchannel TX
      cfg80211: reg: Init wiphy_idx in regulatory_hint_core()

Bob Copeland (1):
      mac80211: fix pending queue hang due to TX_DROP

Felix Fietkau (1):
      mac80211: allocate TXQs for active monitor interfaces

Johannes Berg (1):
      mac80211: TDLS: fix skb queue/priority assignment

Jouni Malinen (1):
      cfg80211: Address some corner cases in scan result channel updating

Martin Willi (3):
      mac80211_hwsim: fix locking when iterating radios during ns exit
      mac80211_hwsim: fix race in radio destruction from netlink notifier
      mac80211_hwsim: do not omit multicast announce of first added radio

Masashi Honma (2):
      nl80211: Fix possible Spectre-v1 for NL80211_TXRATE_HT
      nl80211: Fix possible Spectre-v1 for CQM RSSI thresholds

Randy Dunlap (1):
      cfg80211: fix reg_query_regdb_wmm kernel-doc

Yuan-Chi Pang (1):
      mac80211: fix TX status reporting for ieee80211s

 drivers/net/wireless/mac80211_hwsim.c | 36 ++++++++++------------
 include/net/cfg80211.h                |  2 --
 net/mac80211/iface.c                  |  3 +-
 net/mac80211/mesh.h                   |  3 +-
 net/mac80211/mesh_hwmp.c              |  9 ++----
 net/mac80211/status.c                 | 11 +++----
 net/mac80211/tdls.c                   |  8 ++---
 net/mac80211/tx.c                     |  6 +++-
 net/wireless/nl80211.c                | 20 +++++++++---
 net/wireless/reg.c                    |  1 +
 net/wireless/scan.c                   | 58 +++++++++++++++++++++++++++++------
 11 files changed, 103 insertions(+), 54 deletions(-)
