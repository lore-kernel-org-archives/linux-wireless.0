Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:61223 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab3DBXwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 19:52:47 -0400
Received: by mail-qa0-f44.google.com with SMTP id o13so1776421qaj.3
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2013 16:52:46 -0700 (PDT)
Message-ID: <515B6F4D.4030203@gmail.com> (sfid-20130403_020009_814012_4B5BA7E5)
Date: Tue, 02 Apr 2013 19:52:45 -0400
From: Robert Shade <robert.shade@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
CC: adrian@freebsd.org, nbd@openwrt.org
Subject: [PATCH V2] ath9k: Re-enable interrupts after a channel change failure
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_complete_reset will not be called if ath9k_hw_reset
is unsuccessful, so we need to re-enable intertupts to
balence the previous ath_prepare_reset call.  Also schedule a
reset as a best effort method to recover the chip from
whatever state caused the channel change failure.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=55771

Signed-off-by: Robert Shade <robert.shade@gmail.com>
---
V2
- (hopefully) Fixed whitespace issues
- Removed call to ath9k_hw_set_interrupts
---
 drivers/net/wireless/ath/ath9k/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 24650fd4..83608be 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -280,6 +280,10 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 	if (r) {
 		ath_err(common,
 			"Unable to reset channel, reset status %d\n", r);
+
+		ath9k_hw_enable_interrupts(ah);
+		ath9k_queue_reset(sc, RESET_TYPE_BB_HANG);
+
 		goto out;
 	}
 
-- 
1.8.2

