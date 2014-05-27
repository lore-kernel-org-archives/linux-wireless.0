Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:64364 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbaE0UGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 16:06:05 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so2453862wiw.14
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2014 13:06:03 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/10] staging: vt6656: WCTLbIsDuplicate fix PSCacheEntry base types and warnings
Date: Tue, 27 May 2014 21:05:17 +0100
Message-Id: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com> (sfid-20140527_220611_345175_882F4521)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix wFmSequence and wFrameCtl to __le16

Don't restrict to u8, if packet is a duplicate both bytes of __le16 will be
the same.

Fixes warnings
wctl.c:66:9: warning: restricted __le16 degrades to integer
wctl.c:71:56: warning: restricted __le16 degrades to integer
wctl.c:73:49: warning: cast from restricted __le16
wctl.c:83:30: warning: incorrect type in assignment (different base types)
wctl.c:83:30:    expected unsigned short [unsigned] [usertype] wFmSequence
wctl.c:83:30:    got restricted __le16 [usertype] seq_ctrl
wctl.c:85:28: warning: incorrect type in assignment (different base types)
wctl.c:85:28:    expected unsigned short [unsigned] [usertype] wFrameCtl
wctl.c:85:28:    got restricted __le16 [usertype] frame_control

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 6 +++---
 drivers/staging/vt6656/wctl.c   | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index e5f84f5..5b64ca7 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -340,9 +340,9 @@ typedef struct tagSPMKIDCandidateEvent {
 
 /* The receive duplicate detection cache entry */
 typedef struct tagSCacheEntry{
-    u16        wFmSequence;
-    u8        abyAddr2[ETH_ALEN];
-    u16        wFrameCtl;
+	__le16 wFmSequence;
+	u8 abyAddr2[ETH_ALEN];
+	__le16 wFrameCtl;
 } SCacheEntry, *PSCacheEntry;
 
 typedef struct tagSCache{
diff --git a/drivers/staging/vt6656/wctl.c b/drivers/staging/vt6656/wctl.c
index 814342c..efdc5d5 100644
--- a/drivers/staging/vt6656/wctl.c
+++ b/drivers/staging/vt6656/wctl.c
@@ -70,7 +70,7 @@ bool WCTLbIsDuplicate (PSCache pCache, struct ieee80211_hdr *pMACHeader)
             pCacheEntry = &(pCache->asCacheEntry[uIndex]);
             if ((pCacheEntry->wFmSequence == pMACHeader->seq_ctrl) &&
 		ether_addr_equal(pCacheEntry->abyAddr2, pMACHeader->addr2) &&
-                (LOBYTE(pCacheEntry->wFrameCtl) == LOBYTE(pMACHeader->frame_control))
+		(pCacheEntry->wFrameCtl == pMACHeader->frame_control)
                 ) {
                 /* Duplicate match */
                 return true;
-- 
1.9.1

