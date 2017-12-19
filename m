Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36108 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752847AbdLSJ5Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 04:57:16 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2017-12-19
Date: Tue, 19 Dec 2017 10:57:09 +0100
Message-Id: <20171219095710.16889-1-johannes@sipsolutions.net> (sfid-20171219_105722_704889_F408BB59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Other work has been hectic, and I got caught by rc4. We still
have a few more fixes though - and more build issues were
reported.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 0afe9d4ab9d40c281bdcdd118661fe8e4bdcef18:

  mac80211: fix locking in ieee80211_sta_tear_down_BA_sessions (2017-12-11 10:50:00 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2017-12-19

for you to fetch changes up to 04a7279ff12fc47b657f70731d401c0064f5838a:

  cfg80211: ship certificates as hex files (2017-12-19 09:28:01 +0100)

----------------------------------------------------------------
A few more fixes:
 * hwsim:
   - set To-DS bit in some frames missing it
   - fix sleeping in atomic
 * nl80211:
   - doc cleanup
   - fix locking in an error path
 * build:
   - don't append to created certs C files
   - ship certificate pre-hexdumped

----------------------------------------------------------------
Adiel Aloni (1):
      mac80211_hwsim: enable TODS BIT in null data frame

Jia-Ju Bai (1):
      mac80211_hwsim: Fix a possible sleep-in-atomic bug in hwsim_get_radio_nl

Johannes Berg (2):
      nl80211: fix nl80211_send_iface() error paths
      cfg80211: ship certificates as hex files

Jonathan Corbet (1):
      nl80211: Remove obsolete kerneldoc line

Thierry Reding (1):
      cfg80211: always rewrite generated files from scratch

 drivers/net/wireless/mac80211_hwsim.c |   3 +-
 include/net/cfg80211.h                |   1 -
 net/wireless/Makefile                 |  31 ++++--------
 net/wireless/certs/sforshee.hex       |  86 ++++++++++++++++++++++++++++++++++
 net/wireless/certs/sforshee.x509      | Bin 680 -> 0 bytes
 net/wireless/nl80211.c                |   6 ++-
 6 files changed, 102 insertions(+), 25 deletions(-)
 create mode 100644 net/wireless/certs/sforshee.hex
 delete mode 100644 net/wireless/certs/sforshee.x509
