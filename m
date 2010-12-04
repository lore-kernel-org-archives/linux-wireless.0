Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:12239 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab0LDBVD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 20:21:03 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 03 Dec 2010 17:20:49 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <amod.bodas@atheros.com>,
	<pstew@google.com>, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 3/3] ath9k_hw: warn if we cannot change the power to the chip
Date: Fri, 3 Dec 2010 17:20:53 -0800
Message-ID: <1291425653-2884-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1291425653-2884-1-git-send-email-lrodriguez@atheros.com>
References: <1291425653-2884-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Suspend requires the device to be in fullsleep otherwise upon
resume the device becomes unresponsive. We need to ensure
that when we want the device to go to sleep it yields to
the request, otherwise we'll have a useless devices upon
resume. Warn when changing the power fails as we need
to look into these issues.

Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9b1ee7f..8e87113 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1615,6 +1615,8 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 	}
 	ah->power_mode = mode;
 
+	WARN_ON(!status);
+
 	return status;
 }
 EXPORT_SYMBOL(ath9k_hw_setpower);
-- 
1.7.3.2.90.gd4c43

