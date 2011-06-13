Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:36280 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab1FMWfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:35:08 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh06-2.mail.saunalahti.fi (Postfix) with SMTP id BDE26C7EF9
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:35:06 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh05.mail.saunalahti.fi (Postfix) with ESMTP id A7ED527D85
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:35:05 +0300 (EEST)
Subject: [PATCH v2 04/27] rtlwifi: include mac80211.h from core.h
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:35:04 +0300
Message-ID: <20110613223504.10517.6465.stgit@localhost6.localdomain6> (sfid-20110614_003510_923968_42B87F5E)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

core.h references ieee80211_ops but doesn't include mac80211.h, which issues
a warning once mac80211-compat.h is taken into use.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
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

