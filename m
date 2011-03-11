Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29976 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330Ab1CKC4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:42 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:56:19 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 16/20] ath6kl: remove-typedef ATHBT_FILTER_INSTANCE
Date: Thu, 10 Mar 2011 18:55:43 -0800
Message-ID: <1299812147-12069-17-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We mark this as unused as well, given that I find no users,
at a later time we can determine to nuke this or not...

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/include/athbtfilter.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ath6kl/include/athbtfilter.h b/drivers/staging/ath6kl/include/athbtfilter.h
index 378f967..81456ee 100644
--- a/drivers/staging/ath6kl/include/athbtfilter.h
+++ b/drivers/staging/ath6kl/include/athbtfilter.h
@@ -61,7 +61,7 @@ typedef enum _ATHBT_STATE {
 
 typedef void   (*ATHBT_INDICATE_STATE_FN)(void *pContext, ATHBT_STATE_INDICATION Indication, ATHBT_STATE State, unsigned char LMPVersion);
 
-typedef struct _ATHBT_FILTER_INSTANCE {
+struct athbt_filter_instance {
 #ifdef UNDER_CE
     WCHAR                       *pWlanAdapterName;  /* filled in by user */
 #else
@@ -74,7 +74,7 @@ typedef struct _ATHBT_FILTER_INSTANCE {
     ATHBT_FILTER_DATA_FN        pFilterAclDataOut;  /* function ptr to filter ACL data out (to radio) */
     ATHBT_FILTER_DATA_FN        pFilterAclDataIn;   /* function ptr to filter ACL data in (from radio) */
     ATHBT_INDICATE_STATE_FN     pIndicateState;     /* function ptr to indicate a state */
-} ATH_BT_FILTER_INSTANCE;
+}; /* XXX: unused ? */
 
 
 /* API MACROS */
-- 
1.7.4.15.g7811d

