Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58132 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751701AbcLUEMC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 23:12:02 -0500
From: David Lin <dlin@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Chor Teck Law <ctlaw@marvell.com>,
        James Lin <jamesl@marvell.com>, Pete Hsieh <peteh@marvell.com>
Subject: [PATCH v9] Add new mac80211 driver mwlwifi.
Date: Wed, 21 Dec 2016 04:11:55 +0000
Message-ID: <fd5b7d6b70ee4965a845eaa460f20246@SC-EXCH02.marvell.com> (sfid-20161221_051205_876456_E6438D3F)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PATCH v8 changes since PATCH v7:

- Used scnprintf() to replace sprintf() for debugfs output messages to avoid
overwriting buffer boundary.
- Used mutex to replace spinlock for the protection of firmware command.
- Used NL80211_BAND_XXXX instead of IEEE80211_BAND_XXXX (in order to work with
updated mac80211).
- Used usleep_range() instead of mdelay().
- Modified the code to work with new mac80211 API ampdu_action() and get peer
AMSDU information from parameters of this function instead of peeking ADDBA
related packets.
- Removed BA stream if traffic is not heavy.
- Removed version information.
- Added DFS, WPS, WDS and thermal function.
- Changed length of mac vht_mpdu from 7991 to 3895.

PATCH v9 changes since PATCH v8:

- Added code to support Marvell WiFi chip with device power table.
- Used IS_ENABLED macro to test for Kconfig symbols.

David Lin (1):
  Add new mac80211 driver mwlwifi.

 MAINTAINERS                                     |    6 +
 drivers/net/wireless/marvell/Kconfig            |    1 +
 drivers/net/wireless/marvell/Makefile           |    1 +
 drivers/net/wireless/marvell/mwlwifi/Kconfig    |   23 +
 drivers/net/wireless/marvell/mwlwifi/Makefile   |   13 +
 drivers/net/wireless/marvell/mwlwifi/debugfs.c  |  830 +++++++
 drivers/net/wireless/marvell/mwlwifi/debugfs.h  |   24 +
 drivers/net/wireless/marvell/mwlwifi/dev.h      |  516 +++++
 drivers/net/wireless/marvell/mwlwifi/fwcmd.c    | 2837 +++++++++++++++++++++++
 drivers/net/wireless/marvell/mwlwifi/fwcmd.h    |  223 ++
 drivers/net/wireless/marvell/mwlwifi/fwdl.c     |  186 ++
 drivers/net/wireless/marvell/mwlwifi/fwdl.h     |   25 +
 drivers/net/wireless/marvell/mwlwifi/hostcmd.h  |  913 ++++++++
 drivers/net/wireless/marvell/mwlwifi/isr.c      |  172 ++
 drivers/net/wireless/marvell/mwlwifi/isr.h      |   27 +
 drivers/net/wireless/marvell/mwlwifi/mac80211.c |  719 ++++++
 drivers/net/wireless/marvell/mwlwifi/main.c     |  840 +++++++
 drivers/net/wireless/marvell/mwlwifi/rx.c       |  513 ++++
 drivers/net/wireless/marvell/mwlwifi/rx.h       |   25 +
 drivers/net/wireless/marvell/mwlwifi/sysadpt.h  |   83 +
 drivers/net/wireless/marvell/mwlwifi/thermal.c  |  182 ++
 drivers/net/wireless/marvell/mwlwifi/thermal.h  |   42 +
 drivers/net/wireless/marvell/mwlwifi/tx.c       | 1250 ++++++++++
 drivers/net/wireless/marvell/mwlwifi/tx.h       |   37 +
 24 files changed, 9488 insertions(+)
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/Kconfig
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/Makefile
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/debugfs.c
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/debugfs.h
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/dev.h
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/fwcmd.c
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/fwcmd.h
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/fwdl.c
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/fwdl.h
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/hostcmd.h
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/isr.c
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/isr.h
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/mac80211.c
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/main.c
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/rx.c
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/rx.h
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/sysadpt.h
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/thermal.c
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/thermal.h
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/tx.c
 create mode 100644 drivers/net/wireless/marvell/mwlwifi/tx.h

-- 
1.9.3
