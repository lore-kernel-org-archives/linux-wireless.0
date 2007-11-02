Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:27986 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbXKBUqw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2007 16:46:52 -0400
Received: by an-out-0708.google.com with SMTP id b36so132460ana
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2007 13:46:51 -0700 (PDT)
Date: Fri, 2 Nov 2007 16:46:38 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	ath5k-devel@lists.ath5k.org
Subject: [PATCH] ath5k: Set ACK to user lower bit rates
Message-ID: <20071102204638.GA3227@pogo> (sfid-20071102_204655_673653_89BC4B98)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, forgot this last hunk in my patch series... This applies on top
of my series.

This sets the ACK bitrate to the lower rates. Without this I get 
about 70% packet loss when using the 11M rate. Not sure exactly what rates
this is setting the HW to send the ACKs in but it sure does help.

I'll be poking more with this and trying to fix rates for g. We'll figure
this out ;)

Note: our higher rates are still pretty unusable, something is still
wrong with those.

Changes to base.c
Changes-licensed-under: 3-clause-BSD

Changes to ath5k.h, hw.c
Changes-licensed-under: ISC

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/ath5k.h |    2 ++
 drivers/net/wireless/ath5k/base.c  |    2 ++
 drivers/net/wireless/ath5k/hw.c    |   19 +++++++++++++++++++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 72c24bc..b6f5364 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -1061,6 +1061,8 @@ extern int ath5k_hw_set_beacon_timers(struct ath5k_hw *ah, const struct ath5k_be
 extern void ath5k_hw_reset_beacon(struct ath5k_hw *ah);
 extern int ath5k_hw_wait_for_beacon(struct ath5k_hw *ah, unsigned long phys_addr);
 extern void ath5k_hw_update_mib_counters(struct ath5k_hw *ah, struct ath5k_mib_stats *statistics);
+/* ACK bit rate */
+void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high);
 /* ACK/CTS Timeouts */
 extern int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout);
 extern unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah);
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 15ae868..8173feb 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2193,6 +2193,8 @@ ath5k_init(struct ath5k_softc *sc)
 		AR5K_INT_RXORN | AR5K_INT_FATAL | AR5K_INT_GLOBAL;
 
 	ath5k_hw_set_intr(sc->ah, sc->imask);
+	/* Set ack to be sent at low bit-rates */
+	ath5k_hw_set_ack_bitrate_high(sc->ah, false);
 
 	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
 			msecs_to_jiffies(ath5k_calinterval * 1000)));
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index f1ba863..f597502 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -2852,6 +2852,25 @@ void ath5k_hw_update_mib_counters(struct ath5k_hw *ah,
 	}
 }
 
+/** ath5k_hw_set_ack_bitrate - set bitrate for ACKs
+ *
+ * @ah: the &struct ath5k_hw
+ * @high: determines if to use low bit rate or now
+ */
+void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high)
+{
+	if (ah->ah_version != AR5K_AR5212)
+		return;
+	else {
+		u32 val = AR5K_STA_ID1_BASE_RATE_11B | AR5K_STA_ID1_ACKCTS_6MB;
+		if (high)
+			AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1, val);
+		else
+			AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1, val);
+	}
+}
+
+
 /*
  * ACK/CTS Timeouts
  */
