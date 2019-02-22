Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C91AC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 13:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 455CF2081B
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 13:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfBVNZX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 08:25:23 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38856 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfBVNZW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 08:25:22 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gxApL-00045w-Hz; Fri, 22 Feb 2019 14:25:19 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2019-02-22
Date:   Fri, 22 Feb 2019 14:25:12 +0100
Message-Id: <20190222132513.29834-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

Here's the promised update with the big multi-BSSID changes,
which are related to HE (802.11ax) for which we also have some
updates.

Note that I took the liberty of including Herbert's rhashtable
API removal, I merged net-next for that and verified that the
API he removed is also not used in anything new, but if you
apply/applied any patches after I pulled you should probably
double check that again.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 7a25c6c0aac85bbc50d3ce49cd08888adb14508b:

  rocker: Add missing break for PRE_BRIDGE_FLAGS (2019-02-21 21:29:23 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2019-02-22

for you to fetch changes up to 6c4128f658571b2dc7e01058ad09a8e947bc0159:

  rhashtable: Remove obsolete rhashtable_walk_init function (2019-02-22 13:49:00 +0100)

----------------------------------------------------------------
This time we have, of note:
 * the massive patch series for multi-BSSID support, I ended up
   applying that through a side branch to record some details
 * CSA improvements
 * HE (802.11ax) updates to Draft 3.3
 * strongly typed element iteration/etc. to make such code more
   readable - this came up in particular in multi-BSSID
 * rhashtable conversion patches from Herbert
Along, as usual, with various fixes and improvements.

----------------------------------------------------------------
Cody Schuffelen (1):
      virt_wifi: Remove REGULATORY_WIPHY_SELF_MANAGED

Herbert Xu (2):
      mac80211: Use rhashtable_lookup_get_insert_fast instead of racy code
      rhashtable: Remove obsolete rhashtable_walk_init function

Johannes Berg (13):
      cfg80211: add and use strongly typed element iteration macros
      cfg80211: use for_each_element() for multi-bssid parsing
      mac80211: use element iteration macro in parsing
      cfg80211: add various struct element finding helpers
      nl80211: use for_each_element() in validate_ie_attr()
      cfg80211: add missing kernel-doc for multi-BSSID fields
      Merge branch 'cfg80211-mac80211-multi-bssid' into mac80211-next
      ieee80211: fix for_each_element_extid()
      cfg80211: restore regulatory without calling userspace
      cfg80211: fix and clean up cfg80211_gen_new_bssid()
      radiotap: add 0-length PSDU "not captured" type
      cfg80211: allow sending vendor events unicast
      Merge remote-tracking branch 'net-next/master' into mac80211-next

Jouni Malinen (4):
      mac80211_hwsim: Support boottime in scan results
      mac80211_hwsim: Declare support for Multi-BSSID
      cfg80211: Use const more consistently in for_each_element macros
      cfg80211: Report Association Request frame IEs in association events

Liad Kaufman (2):
      mac80211: fix position of vendor_data read
      mac80211: update HE IEs to D3.3

Mao Wenan (1):
      cfg80211: pmsr: use eth_broadcast_addr() to assign broadcast address

Peng Xu (1):
      cfg80211: Parsing of Multiple BSSID information in scanning

Sara Sharon (16):
      mac80211: pass bssids to elements parsing function
      mac80211: move the bss update from elements to an helper
      cfg80211: Properly track transmitting and non-transmitting BSS
      cfg80211: Move Multiple BSS info to struct cfg80211_bss to be visible
      cfg80211: parse multi-bssid only if HW supports it
      cfg80211: make BSSID generation function inline
      cfg80211: save multi-bssid properties
      mac80211: support multi-bssid
      mac80211: indicate support for multiple BSSID
      cfg80211: fix the IE inheritance of extension IEs
      cfg80211: fix memory leak of new_ie
      mac80211: support max channel switch time element
      mac80211: abort CSA if beacon does not include CSA IEs
      mac80211: notify driver on subsequent CSA beacons
      mac80211: allow CSA to self with immediate quiet
      mac80211: ignore quiet mode in probe

 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |  26 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  58 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  40 ++
 drivers/net/wireless/mac80211_hwsim.c              |   7 +-
 drivers/net/wireless/virt_wifi.c                   |   1 -
 include/linux/ieee80211.h                          | 115 +++-
 include/linux/rhashtable.h                         |   8 -
 include/net/cfg80211.h                             | 233 +++++++-
 include/net/ieee80211_radiotap.h                   |   3 +-
 include/net/mac80211.h                             |  40 +-
 lib/rhashtable.c                                   |   2 +-
 lib/test_rhashtable.c                              |   9 +-
 net/ipv6/ila/ila_xlat.c                            |  15 +-
 net/mac80211/debugfs.c                             |   4 +-
 net/mac80211/debugfs_sta.c                         |  35 +-
 net/mac80211/driver-ops.h                          |  31 +-
 net/mac80211/ibss.c                                |   8 +-
 net/mac80211/ieee80211_i.h                         |  28 +-
 net/mac80211/main.c                                |  13 +-
 net/mac80211/mesh.c                                |  10 +-
 net/mac80211/mesh_hwmp.c                           |   3 +-
 net/mac80211/mesh_pathtbl.c                        |  24 +-
 net/mac80211/mesh_plink.c                          |   4 +-
 net/mac80211/mlme.c                                | 269 +++++++---
 net/mac80211/rx.c                                  |  21 +-
 net/mac80211/scan.c                                | 160 +++---
 net/mac80211/spectmgmt.c                           |   6 +
 net/mac80211/tdls.c                                |   6 +-
 net/mac80211/trace.h                               |  46 +-
 net/mac80211/util.c                                | 137 ++++-
 net/netlink/af_netlink.c                           |  10 +-
 net/wireless/core.h                                |  13 +-
 net/wireless/mlme.c                                |   8 +-
 net/wireless/nl80211.c                             |  82 +--
 net/wireless/nl80211.h                             |   3 +-
 net/wireless/pmsr.c                                |   2 +-
 net/wireless/reg.c                                 |  73 ++-
 net/wireless/reg.h                                 |   2 +
 net/wireless/scan.c                                | 595 ++++++++++++++++++---
 net/wireless/util.c                                |   6 +-
 40 files changed, 1713 insertions(+), 443 deletions(-)

