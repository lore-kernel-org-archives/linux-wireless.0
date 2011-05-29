Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:41000 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab1E2UEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 16:04:36 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh01-2.mail.saunalahti.fi (Postfix) with SMTP id D5A168C4AF
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:04:35 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id C4C51158A64
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:04:34 +0300 (EEST)
Subject: [RFC PATCH 04/27] rtlwifi: include mac80211.h from core.h
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 29 May 2011 23:04:34 +0300
Message-ID: <20110529200434.16479.84395.stgit@localhost6.localdomain6> (sfid-20110529_220439_697893_5940F696)
In-Reply-To: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
References: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

core.h references ieee80211_ops but doesn't include mac80211.h, which issues
a warning once mac80211-compat.h is taken into use.

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 drivers/net/wireless/rtlwifi/core.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/core.h b/drivers/net/wireless/rtlwifi/core.h
index 4b247db..f02824a 100644
--- a/drivers/net/wireless/rtlwifi/core.h
+++ b/drivers/net/wireless/rtlwifi/core.h
@@ -30,6 +30,8 @@
 #ifndef __RTL_CORE_H__
 #define __RTL_CORE_H__
 
+#include <net/mac80211.h>
+
 #define RTL_SUPPORTED_FILTERS		\
 	(FIF_PROMISC_IN_BSS | \
 	FIF_ALLMULTI | FIF_CONTROL | \

