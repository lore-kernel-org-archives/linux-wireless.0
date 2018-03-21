Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.161.202]:43224 "EHLO
        mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753309AbeCUWoh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 18:44:37 -0400
Received: by mail-yw0-f202.google.com with SMTP id f185so1395401ywd.10
        for <linux-wireless@vger.kernel.org>; Wed, 21 Mar 2018 15:44:37 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <00000000000080af470567f3ef29@google.com> (sfid-20180321_234441_374247_F40B62AD)
Date: Wed, 21 Mar 2018 22:44:36 +0000
Subject: [PATCH] brcmfmac: Add timestamp to scan results report
From: dimitrysh@google.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, franky.lin@broadcom.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 From 01da9ee11ce6e0973972b2ffd37eef660714f71a Mon Sep 17 00:00:00 2001
From: Dmitry Shmidt <dimitrysh@google.com>
Date: Wed, 21 Mar 2018 15:35:45 -0700
Subject: [PATCH] brcmfmac: Add timestamp to scan results report

Monotonic time from boot is good timestamp indicator
and it can be used by kernel and userspace.

Change-Id: I122374fa79c6dbd7967b2c30553cb04dee032ebc
Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
---
  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 6 +++++-
  1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 4157c90ad973..76d6ed553b7c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2845,6 +2845,8 @@ static s32 brcmf_inform_single_bss(struct  
brcmf_cfg80211_info *cfg,
  	struct cfg80211_bss *bss;
  	struct ieee80211_supported_band *band;
  	struct brcmu_chan ch;
+	struct timespec ts;
+	u64 timestamp;
  	u16 channel;
  	u32 freq;
  	u16 notify_capability;
@@ -2885,10 +2887,12 @@ static s32 brcmf_inform_single_bss(struct  
brcmf_cfg80211_info *cfg,
  	brcmf_dbg(CONN, "Beacon interval: %d\n", notify_interval);
  	brcmf_dbg(CONN, "Signal: %d\n", notify_signal);

+	get_monotonic_boottime(&ts);
+	timestamp = (u64)ts.tv_sec * 1000000 + ts.tv_nsec / 1000;
  	bss = cfg80211_inform_bss(wiphy, notify_channel,
  				  CFG80211_BSS_FTYPE_UNKNOWN,
  				  (const u8 *)bi->BSSID,
-				  0, notify_capability,
+				  timestamp, notify_capability,
  				  notify_interval, notify_ie,
  				  notify_ielen, notify_signal,
  				  GFP_KERNEL);
-- 
2.17.0.rc0.231.g781580f067-goog
