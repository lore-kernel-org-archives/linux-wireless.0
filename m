Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0086.outbound.protection.outlook.com ([104.47.37.86]:38784
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754191AbdHYCak (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:30:40 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 00/27] qtnfmac: allow to configure channel, BW, HT/VHT caps
Date: Thu, 24 Aug 2017 19:29:57 -0700
Message-Id: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043059_895723_F2BC0058)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

This patchset has a goal to make operational parameters (channel, BW,
HT/VHT capabilities) configuration possible for qtnfmac driver.
Basically the idea is to make driver level as thin as possible, and let
everything to be handled by userspace/nl80211 and wireless device itself.


Tested by trying various parameters combinations in hostapd.conf.

Set channel=36, bw=20, HT=0, VHT=0:
  hw_mode=a
  channel=36
Set channel=36, bw=20, HT=1, VHT=0:
  ieee80211n=1
Set channel=36, bw=40 with secondary channel above, HT=1, VHT=0:
  ieee80211n=1
  ht_capab=[HT40+][SHORT-GI-20][SHORT-GI-40][MAX-AMSDU-7935]
Set channel=36, bw=40 with secondary channel below, HT=1, VHT=0:
  channel=40
  ieee80211n=1
  ht_capab=[HT40-][SHORT-GI-20][SHORT-GI-40][MAX-AMSDU-7935]
Set channel=36, bw=40, HT=1, VHT=1:
  ieee80211n=1
  ht_capab=[HT40+][SHORT-GI-20][SHORT-GI-40][MAX-AMSDU-7935]
  ieee80211ac=1
  vht_capab=[SHORT-GI-80][MAX-MPDU-11454][MAX-A-MPDU-LEN-EXP-7][SU-BEAMFORMER][SU-BEAMFORMEE]
  vht_oper_chwidth=0
Set channel=36, bw=80, HT=1, VHT=1:
  ieee80211ac=1
  vht_capab=[SHORT-GI-80][MAX-MPDU-11454][MAX-A-MPDU-LEN-EXP-7][SU-BEAMFORMER][SU-BEAMFORMEE]
  vht_oper_chwidth=1
  vht_oper_centr_freq_seg0_idx=42


Igor Mitsyanko (27):
  qtnfmac: qlink: convert channel width from bitfiled to simple enum
  qtnfmac: make "Channel change" event report full channel info
  qtnfmac: retreive current channel info from EP
  qtnfmac: do not cache AP settings in driver structures
  qtnfmac: pass all AP settings to wireless card for processing
  qtnfmac: pass full channel definition to device on start_ap command
  qtnfmac: get rid of QTNF_STATE_AP_CONFIG
  qtnfmac: get rid of QTNF_STATE_AP_START usage
  qtnfmac: do not cache BSS state in per-VIF structure
  qtnfmac: do not cache channel info from "connect" command
  qtnfmac: make encryption info a part of "connect" command.
  qtnfmac: let wifi card handle channel switch request to the same chan
  qtnfmac: pass VIF info to SendChannel command
  qtnfmac: do not cache CSA chandef info
  qtnfmac: remove unused mac::status field
  qtnfmac: stop using private driver info about current channel
  qtnfmac: do not report channel changes until wiphy is registered
  qtnfmac: use per-band HT/VHT info from wireless device
  qtnfmac: initialize HT/VHT caps "can override" masks
  qtnfmac: get rid of PHYMODE capabilities flags
  qtnfmac: extend "IE set" TLV to include frame type info
  qtnfmac: SCAN results: retreive frame type information from "IE set"
    TLV
  qtnfmac: convert "Append IEs" command to QTN_TLV_ID_IE_SET usage
  qtnfmac: configure and start AP interface with a single command
  nl80211: look for HT/VHT capabilities in beacon's tail
  qtnfmac: include HTCAP and VHTCAP into config AP command
  qtnfmac: pass all CONNECT cmd params to wireless card for processing

 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  | 234 ++--------
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 470 ++++++++++++++-------
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |  11 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |   3 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |  35 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     | 134 +++---
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     | 265 ++++++++----
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    | 113 ++++-
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |   7 +
 net/wireless/nl80211.c                             |   4 +-
 10 files changed, 709 insertions(+), 567 deletions(-)

-- 
2.9.5
