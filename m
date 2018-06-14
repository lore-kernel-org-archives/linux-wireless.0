Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr60104.outbound.protection.outlook.com ([40.107.6.104]:11993
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754737AbeFNKK5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 06:10:57 -0400
From: Omer Efrat <omer.efrat@tandemg.com>
To: linux-wireless@vger.kernel.org
Cc: Omer Efrat <omer.efrat@tandemg.com>
Subject: [PATCH v2 0/5] use BIT_ULL for NL80211_STA_INFO_* attribute types
Date: Thu, 14 Jun 2018 13:08:45 +0300
Message-Id: <1528970925-32697-1-git-send-email-omer.efrat@tandemg.com> (sfid-20180614_121101_416478_7E600BA0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since 'filled' member in station_info changed to u64, BIT_ULL macro
should be used with NL80211_STA_INFO_* attribute types instead of BIT.

The BIT macro uses unsigned long type which some architectures handle as 32bit
and this results in compilation warnings such as:

net/mac80211/sta_info.c:2223:2: warning: left shift count >= width of type
  sinfo->filled |= BIT(NL80211_STA_INFO_TID_STATS);
  ^

This patch series replaces the described BIT usage with BIT_ULL.

Changes in v2: Split patches so cfg80211, mac80211 and batman will be
  seperated.

Omer Efrat (5):
  cfg80211: use BIT_ULL for NL80211_STA_INFO_* attribute types
  mac80211: use BIT_ULL for NL80211_STA_INFO_* attribute types
  batman: use BIT_ULL for NL80211_STA_INFO_* attribute types
  wireless-drivers: use BIT_ULL for NL80211_STA_INFO_* attribute types
  staging: use BIT_ULL for NL80211_STA_INFO_* attribute types

 drivers/net/wireless/ath/ath6kl/cfg80211.c         | 14 ++--
 drivers/net/wireless/ath/wil6210/cfg80211.c        | 18 ++---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 40 +++++------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  6 +-
 drivers/net/wireless/marvell/libertas/cfg.c        | 12 ++--
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    | 14 ++--
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 32 ++++-----
 drivers/net/wireless/rndis_wlan.c                  |  4 +-
 drivers/net/wireless/ti/wlcore/main.c              |  2 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  | 10 +--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c  | 14 ++--
 drivers/staging/wlan-ng/cfg80211.c                 |  4 +-
 net/batman-adv/bat_v_elp.c                         |  2 +-
 net/mac80211/ethtool.c                             |  6 +-
 net/mac80211/sta_info.c                            | 84 +++++++++++-----------
 net/wireless/nl80211.c                             | 22 +++---
 net/wireless/wext-compat.c                         | 10 +--
 17 files changed, 147 insertions(+), 147 deletions(-)

-- 
2.7.4
