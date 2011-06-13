Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:39331 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab1FMWfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:35:00 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id BC0FE8C0CF
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:34:59 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh01.mail.saunalahti.fi (Postfix) with ESMTP id A78F1402E
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:34:58 +0300 (EEST)
Subject: [PATCH v2 03/27] zd1211rw: include mac80211.h from zd_chip.h
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:34:57 +0300
Message-ID: <20110613223457.10517.84104.stgit@localhost6.localdomain6> (sfid-20110614_003504_010943_B3697353)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
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
 

