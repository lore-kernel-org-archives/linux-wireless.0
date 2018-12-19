Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A03C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 09:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A337221850
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 09:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbeLSJas (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 04:30:48 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:55254 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbeLSJar (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 04:30:47 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gZYBg-0005g7-2F; Wed, 19 Dec 2018 10:30:44 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2018-12-19
Date:   Wed, 19 Dec 2018 10:30:33 +0100
Message-Id: <20181219093034.11602-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

Last chance, I guess, but do have quite a long list of
changes for -next, some of which I really should've
sent earlier, sorry about that. See below for a brief
summary in the tag, and of course the shortlog is also
below.

The biggest (code-wise) things are the virt_wifi for
pretending to have wifi control on another network
connection, and the peer measurement APIs for FTM
(flight time measurement, wifi location).

FWIW, this includes the nl_set_extack_cookie_u64()
I had sent previously, the peer measurement APIs now
finally use it.

Please pull and let me know if there's any problem.

Happy holidays!

johannes



The following changes since commit 29e12207174a58ac8cab4914d0a7ce5e6c872646:

  sfc: use the new __netdev_tx_sent_queue BQL optimisation (2018-11-08 20:01:29 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2018-12-19

for you to fetch changes up to d359bbce0601c6a19203a4b813a7e3910fcba282:

  mac80211: Properly access radiotap vendor data (2018-12-19 09:41:10 +0100)

----------------------------------------------------------------
This time we have too many changes to list, highlights:
 * virt_wifi - wireless control simulation on top of
   another network interface
 * hwsim configurability to test capabilities similar
   to real hardware
 * various mesh improvements
 * various radiotap vendor data fixes in mac80211
 * finally the nl_set_extack_cookie_u64() we talked
   about previously, used for
 * peer measurement APIs, right now only with FTM
   (flight time measurement) for location
 * made nl80211 radio/interface announcements more complete
 * various new HE (802.11ax) things:
   updates, TWT support, ...

----------------------------------------------------------------
Andrew Zaborowski (1):
      nl80211: Emit a SET_INTERFACE on iftype change

Bob Copeland (5):
      mac80211: mesh: advertise gates in mesh formation
      {nl,mac}80211: report gate connectivity in station info
      {nl,mac}80211: add dot11MeshConnectedToMeshGate to meshconf
      {nl,mac}80211: add rssi to mesh candidates
      mac80211: rewrite Kconfig text for mesh

Cody Schuffelen (1):
      mac80211-next: rtnetlink wifi simulation device

Emmanuel Grumbach (3):
      mac80211: fix deauth TX when we disconnect
      ieee80211: add bits for TWT in Extended Capabilities IE
      mac80211: propagate the support for TWT to the driver

Ilan Peer (2):
      mac80211: Properly handle SKB with radiotap only
      mac80211: Properly access radiotap vendor data

James Prestwood (4):
      mac80211_hwsim: allow setting iftype support
      mac80211_hwsim: allow configurable cipher types
      mac80211_hwsim: fixes kernel crash during mac80211_hwsim init
      mac80211_hwsim: fix overwriting of if_combination

Johannes Berg (17):
      cfg80211: tracing: avoid 'idx' variable
      mac80211: tracing: avoid 'idx' variable
      mac80211: sta_info: avoid tidstats variable shadowing
      mac80211: debugfs: avoid variable shadowing
      mac80211: tx: avoid variable shadowing
      netlink: add nl_set_extack_cookie_u64()
      cfg80211: add peer measurement with FTM initiator API
      mac80211: allow drivers to use peer measurement API
      mac80211_hwsim: move HWSIM_ATTR_RADIO_NAME parsing last
      mac80211: allow hardware scan to fall back to software
      mac80211: ftm responder: remove pointless defensive coding
      cfg80211: clarify LCI/civic location documentation
      mac80211: never pass NULL params to ieee80211_if_add()
      mac80211: remove superfluous NULL check
      mac80211: document RCU requirements for ieee80211_tx_dequeue()
      mac80211: fix radiotap vendor presence bitmap handling
      cfg80211: fix ieee80211_get_vht_max_nss()

Linus Walleij (1):
      rfkill: gpio: Remove unused include

Luca Coelho (1):
      cfg80211: add some missing fall through annotations

Martin Willi (1):
      nl80211: announce radios/interfaces when switching namespaces

Randy Dunlap (1):
      wireless: FTM: fix kernel-doc "cannot understand" warnings

Sara Sharon (1):
      mac80211: don't build AMSDU from GSO packets

Shaul Triebitz (4):
      mac80211: update HE operation fields to D3.0
      mac80211: update driver when MU EDCA params change
      mac80211: set STA flag DISABLE_HE if HE is not supported
      mac80211: do not advertise HE cap IE if HE disabled

Sriram R (1):
      nl80211: Add support to notify radar event info received from STA

Stephen Hemminger (1):
      uapi/nl80211: fix spelling errors

 drivers/net/wireless/Kconfig          |   7 +
 drivers/net/wireless/Makefile         |   2 +
 drivers/net/wireless/mac80211_hwsim.c | 257 +++++++++-----
 drivers/net/wireless/mac80211_hwsim.h |   4 +
 drivers/net/wireless/virt_wifi.c      | 632 ++++++++++++++++++++++++++++++++++
 include/linux/ieee80211.h             |  32 +-
 include/linux/netlink.h               |   9 +
 include/net/cfg80211.h                | 282 ++++++++++++++-
 include/net/mac80211.h                |  25 +-
 include/uapi/linux/nl80211.h          | 458 +++++++++++++++++++++++-
 net/mac80211/Kconfig                  |  11 +-
 net/mac80211/cfg.c                    |  29 +-
 net/mac80211/debugfs_netdev.c         |   3 +
 net/mac80211/debugfs_sta.c            |  14 +-
 net/mac80211/driver-ops.h             |  34 ++
 net/mac80211/ieee80211_i.h            |   1 +
 net/mac80211/iface.c                  |  10 +-
 net/mac80211/main.c                   |   4 +-
 net/mac80211/mesh.c                   |   8 +-
 net/mac80211/mesh.h                   |   3 +-
 net/mac80211/mesh_plink.c             |  35 +-
 net/mac80211/mlme.c                   |  53 ++-
 net/mac80211/rx.c                     |  37 +-
 net/mac80211/scan.c                   |  22 +-
 net/mac80211/sta_info.c               |  11 +-
 net/mac80211/sta_info.h               |   2 +
 net/mac80211/trace.h                  |  18 +-
 net/mac80211/tx.c                     |  11 +-
 net/mac80211/util.c                   |  51 ++-
 net/rfkill/rfkill-gpio.c              |   1 -
 net/wireless/Makefile                 |   1 +
 net/wireless/chan.c                   |   3 +
 net/wireless/core.c                   |  48 +++
 net/wireless/core.h                   |   5 +
 net/wireless/nl80211.c                | 307 +++++++++++++++--
 net/wireless/nl80211.h                |  32 ++
 net/wireless/pmsr.c                   | 590 +++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h               |  25 ++
 net/wireless/scan.c                   |   2 +-
 net/wireless/trace.h                  |  92 ++++-
 net/wireless/util.c                   |  15 +-
 41 files changed, 2934 insertions(+), 252 deletions(-)
 create mode 100644 drivers/net/wireless/virt_wifi.c
 create mode 100644 net/wireless/pmsr.c

