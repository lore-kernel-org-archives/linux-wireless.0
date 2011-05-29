Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:57818 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1E2UEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 16:04:30 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh02-2.mail.saunalahti.fi (Postfix) with SMTP id 11C26EF5AE
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:04:29 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id ED7B2158A63
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:04:27 +0300 (EEST)
Subject: [RFC PATCH 03/27] zd1211rw: include mac80211.h from zd_chip.h
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 29 May 2011 23:04:17 +0300
Message-ID: <20110529200417.16479.30806.stgit@localhost6.localdomain6> (sfid-20110529_220433_084274_67E85BFE)
In-Reply-To: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
References: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zd_chip.h contains one function with a pointer to ieee80211_hw but doesn't
include mac80211.h. As a temporary solution include mac80211.h to avoid
a warning.

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 drivers/net/wireless/zd1211rw/zd_chip.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index 4be7c3b..117c412 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -21,6 +21,8 @@
 #ifndef _ZD_CHIP_H
 #define _ZD_CHIP_H
 
+#include <net/mac80211.h>
+
 #include "zd_rf.h"
 #include "zd_usb.h"
 

