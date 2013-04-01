Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f169.google.com ([209.85.210.169]:49489 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232Ab3DAOXF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 10:23:05 -0400
Received: by mail-ia0-f169.google.com with SMTP id j5so1955444iaf.28
        for <linux-wireless@vger.kernel.org>; Mon, 01 Apr 2013 07:23:04 -0700 (PDT)
MIME-Version: 1.0
From: Robert Shade <robert.shade@gmail.com>
Date: Mon, 1 Apr 2013 10:22:44 -0400
Message-ID: <CAMgrJ3b0EUUae8k1Z2RR92eLbFyPGpqA5px1J_gALDTJ+rmAnA@mail.gmail.com> (sfid-20130401_162603_158244_7F098D24)
Subject: [PATCH] ath9k: Re-enable interrupts after a channel change failure
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: Adrian Chadd <adrian@freebsd.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Re-enable interrupts after a channel change failure, since
ath_complete_reset will not be called.  Also schedule a reset as a
best effort method to recover the chip from whatever state caused the
channel change failure.

Signed-off-by: Robert Shade <robert.shade@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c
b/drivers/net/wireless/ath/ath9k/main.c
index 24650fd..0567ac9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -280,6 +280,12 @@ static int ath_reset_internal(struct ath_softc
*sc, struct ath9k_channel *hchan)
  if (r) {
  ath_err(common,
  "Unable to reset channel, reset status %d\n", r);
+
+ ath9k_hw_set_interrupts(ah);
+ ath9k_hw_enable_interrupts(ah);
+
+ ath9k_queue_reset(sc, RESET_TYPE_BB_HANG);
+
  goto out;
  }

--
1.7.1
