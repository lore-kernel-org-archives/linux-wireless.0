Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29965 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab1CKC40 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:26 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:56:04 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 11/20] ath6kl: remove-typedef AR6K_GMBOX_INFO
Date: Thu, 10 Mar 2011 18:55:38 -0800
Message-ID: <1299812147-12069-12-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s AR6K_GMBOX_INFO \
	"struct ar6k_gmbox_info" drivers/staging/ath6kl/

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index e8b638c..0bee46a 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -96,14 +96,14 @@ struct ar6k_async_reg_io_buffer {
     u8 _Pad2[A_CACHE_LINE_PAD];
 };
 
-typedef struct _AR6K_GMBOX_INFO { 
+struct ar6k_gmbox_info { 
     void        *pProtocolContext;
     int    (*pMessagePendingCallBack)(void *pContext, u8 LookAheadBytes[], int ValidBytes);
     int    (*pCreditsPendingCallback)(void *pContext, int NumCredits,  bool CreditIRQEnabled);
     void        (*pTargetFailureCallback)(void *pContext, int Status);
     void        (*pStateDumpCallback)(void *pContext);
     bool      CreditCountIRQEnabled;
-} AR6K_GMBOX_INFO; 
+}; 
 
 struct ar6k_device {
     A_MUTEX_T                   Lock;
@@ -137,7 +137,7 @@ struct ar6k_device {
     bool                          ScatterIsVirtual;
     int                             MaxRecvBundleSize;
     int                             MaxSendBundleSize;
-    AR6K_GMBOX_INFO                 GMboxInfo;
+    struct ar6k_gmbox_info                 GMboxInfo;
     bool                          GMboxEnabled;
     struct ar6k_gmbox_ctrl_registers       GMboxControlRegisters;
     int                             RecheckIRQStatusCnt;
-- 
1.7.4.15.g7811d

