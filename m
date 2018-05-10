Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:59793 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756734AbeEJHUU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 03:20:20 -0400
Subject: [PATCH v3 2/3] staging: Dynamically allocate struct station_info
From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Date: Thu, 10 May 2018 09:20:17 +0200
Message-ID: <152593681722.16852.2696052770562763059.stgit@alrua-kau> (sfid-20180510_092025_799125_73B6B912)
In-Reply-To: <152593681714.16852.1707659146940273335.stgit@alrua-kau>
References: <152593681714.16852.1707659146940273335.stgit@alrua-kau>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the addition of the TXQ stats to cfg80211, the station_info struct
has grown to be quite large, which results in warnings when allocated on
the stack. Fix the affected places to do dynamic allocations instead.

This patch applies the fix to the rtl8723bs driver in staging while a
separate patch fixes the drivers in the main tree.

Fixes: 52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to userspace")
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index 46bc2e512557..1ffc8c9ada52 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -2431,17 +2431,23 @@ void rtw_cfg80211_indicate_sta_assoc(struct adapter *padapter, u8 *pmgmt_frame,
 	DBG_871X(FUNC_ADPT_FMT"\n", FUNC_ADPT_ARG(padapter));
 
 	{
-		struct station_info sinfo;
+		struct station_info *sinfo;
 		u8 ie_offset;
 		if (GetFrameSubType(pmgmt_frame) == WIFI_ASSOCREQ)
 			ie_offset = _ASOCREQ_IE_OFFSET_;
 		else /*  WIFI_REASSOCREQ */
 			ie_offset = _REASOCREQ_IE_OFFSET_;
 
-		sinfo.filled = 0;
-		sinfo.assoc_req_ies = pmgmt_frame + WLAN_HDR_A3_LEN + ie_offset;
-		sinfo.assoc_req_ies_len = frame_len - WLAN_HDR_A3_LEN - ie_offset;
-		cfg80211_new_sta(ndev, GetAddr2Ptr(pmgmt_frame), &sinfo, GFP_ATOMIC);
+		sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
+		if (!sinfo)
+			return;
+
+		sinfo->filled = 0;
+		sinfo->assoc_req_ies = pmgmt_frame + WLAN_HDR_A3_LEN + ie_offset;
+		sinfo->assoc_req_ies_len = frame_len - WLAN_HDR_A3_LEN - ie_offset;
+		cfg80211_new_sta(ndev, GetAddr2Ptr(pmgmt_frame), sinfo, GFP_ATOMIC);
+
+		kfree(sinfo);
 	}
 }
 
