Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6060 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754018AbcJZVmY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 17:42:24 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 0/9] cfg80211/mac80211: Fast Initial Link Setup (IEEE 802.11ai)
Date: Thu, 27 Oct 2016 00:41:57 +0300
Message-ID: <1477518126-823-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20161026_234227_951454_5FCC1AF5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds support for using mac80211-based drivers with Fast
Initial Link Setup as defined in IEEE 802.11ai (to be published early
next year; no more technical changes are expected at this point). The
fils branch in git://w1.fi/hostap.git includes matching commits for
hostapd and wpa_supplicant to use this functionality and initial set of
mac80211_hwsim test cases for the functionality. Actually, most of the
commits are already in the master branch, i.e., only the changes
depending on the nl80211.h changes from this kernel patchset are waiting
in the fils branch.

This series covers only the FILS authentication/association
functionality from IEEE 802.11ai, i.e., the other changes like scanning
optimizations are not included.

v2: Updates to address comments from Johannes

Jouni Malinen (9):
  cfg80211: Rename SAE_DATA to more generic AUTH_DATA
  mac80211: Allow AUTH_DATA to be used for FILS
  cfg80211: Add feature flag for Fast Initial Link Setup (FILS) as STA
  cfg80211: Define IEEE P802.11ai (FILS) information elements
  cfg80211: Add Fast Initial Link Setup (FILS) auth algs
  cfg80211: Add KEK/nonces for FILS association frames
  mac80211: Add FILS auth alg mapping
  mac80211: FILS AEAD protection for station mode association frames
  mac80211: Claim Fast Initial Link Setup (FILS) STA support

 include/linux/ieee80211.h    |  26 ++++
 include/net/cfg80211.h       |  40 ++++-
 include/uapi/linux/nl80211.h |  30 +++-
 net/mac80211/Makefile        |   1 +
 net/mac80211/aes_cmac.c      |   8 +-
 net/mac80211/aes_cmac.h      |   4 +
 net/mac80211/fils_aead.c     | 347 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/fils_aead.h     |  19 +++
 net/mac80211/ieee80211_i.h   |   4 +
 net/mac80211/main.c          |   1 +
 net/mac80211/mlme.c          |  57 ++++++-
 net/wireless/core.h          |   2 +-
 net/wireless/mlme.c          |   6 +-
 net/wireless/nl80211.c       |  51 +++++--
 14 files changed, 561 insertions(+), 35 deletions(-)
 create mode 100644 net/mac80211/fils_aead.c
 create mode 100644 net/mac80211/fils_aead.h

-- 
1.9.1
