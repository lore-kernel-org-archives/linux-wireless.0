Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:40167 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751024AbeCZJS6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 05:18:58 -0400
From: Quytelda Kahja <quytelda@tamalin.org>
To: lkp@intel.com, gregkh@linuxfoundation.org
Cc: kbuild-all@01.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Quytelda Kahja <quytelda@tamalin.org>
Subject: [PATCH] staging: rtl8723bs: Remove duplicate #defines.
Date: Mon, 26 Mar 2018 02:18:30 -0700
Message-Id: <20180326091830.30132-1-quytelda@tamalin.org> (sfid-20180326_111913_332377_832DBA6B)
In-Reply-To: <CAFLvi237jR_tTQMXBNqCO=NQFOEFiJQkDBMxb_AxgBEqQDYQEw@mail.gmail.com>
References: <CAFLvi237jR_tTQMXBNqCO=NQFOEFiJQkDBMxb_AxgBEqQDYQEw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The modified file includes 'linux/ieee80211.h', but redefines many
constants that already exist in the header.  This will create a conflict
if the values are ever changed in the kernel.

Signed-off-by: Quytelda Kahja <quytelda@tamalin.org>
---
 drivers/staging/rtl8723bs/include/ieee80211.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/rtl8723bs/include/ieee80211.h b/drivers/staging/rtl8723bs/include/ieee80211.h
index 73ce63770c3c..a2402495f447 100644
--- a/drivers/staging/rtl8723bs/include/ieee80211.h
+++ b/drivers/staging/rtl8723bs/include/ieee80211.h
@@ -435,19 +435,7 @@ struct ieee80211_snap_hdr {
 #define WLAN_GET_SEQ_SEQ(seq)  ((seq) & RTW_IEEE80211_SCTL_SEQ)
 
 /* Authentication algorithms */
-#define WLAN_AUTH_OPEN 0
-#define WLAN_AUTH_SHARED_KEY 1
-
-#define WLAN_AUTH_CHALLENGE_LEN 128
-
 #define WLAN_CAPABILITY_BSS (1<<0)
-#define WLAN_CAPABILITY_IBSS (1<<1)
-#define WLAN_CAPABILITY_CF_POLLABLE (1<<2)
-#define WLAN_CAPABILITY_CF_POLL_REQUEST (1<<3)
-#define WLAN_CAPABILITY_PRIVACY (1<<4)
-#define WLAN_CAPABILITY_SHORT_PREAMBLE (1<<5)
-#define WLAN_CAPABILITY_PBCC (1<<6)
-#define WLAN_CAPABILITY_CHANNEL_AGILITY (1<<7)
 #define WLAN_CAPABILITY_SHORT_SLOT (1<<10)
 
 /* Status codes */
-- 
2.16.2
