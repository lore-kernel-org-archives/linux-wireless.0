Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:40816 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbZGRSUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 14:20:22 -0400
Received: by ey-out-2122.google.com with SMTP id 9so365598eyd.37
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2009 11:20:21 -0700 (PDT)
Message-ID: <4A621264.4030102@tuffmail.co.uk>
Date: Sat, 18 Jul 2009 19:20:20 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] rfkill: remove too-strict __must_check
References: <4A61EE43.4060003@tuffmail.co.uk> <1247938802.18391.0.camel@johannes.local>
In-Reply-To: <1247938802.18391.0.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers don't need the return value of rfkill_set_hw_state(),
so it should not be marked as __must_check.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 include/linux/rfkill.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index f3d5812..1020290 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -238,7 +238,7 @@ void rfkill_destroy(struct rfkill *rfkill);
  * should be blocked) so that drivers need not keep track of the soft
  * block state -- which they might not be able to.
  */
-bool __must_check rfkill_set_hw_state(struct rfkill *rfkill, bool blocked);
+bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked);
 
 /**
  * rfkill_set_sw_state - Set the internal rfkill software block state
-- 
1.6.3.2



