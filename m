Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:12759 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbXKAEiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 00:38:21 -0400
Received: by an-out-0708.google.com with SMTP id b36so57753ana
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2007 21:38:21 -0700 (PDT)
Date: Thu, 1 Nov 2007 00:38:16 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 4/7] ath5k: Fix clock on OFDM timing computation
Message-ID: <20071101043815.GE21987@pogo> (sfid-20071101_043825_517438_54B1CE0F)
References: <20071101043520.GC21987@pogo> <20071101043718.GD21987@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071101043718.GD21987@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were setting the clock to the turbo sampling rate always, lets fix this
for plain OFDM sampling rate at 40 MHz. I believe this tunes the PLL to
the desired frequency, by setting the mantissa and the exponent.

Changes to hw.c
Changes-licensed-under: ISC

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/hw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 17c46e1..3f78d20 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -698,10 +698,11 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		/* Write OFDM timings on 5212*/
 		if (ah->ah_version == AR5K_AR5212) {
 			if (channel->val & CHANNEL_OFDM) {
+				/* Get exponent and mantissa and set it */
 				u32 coef_scaled, coef_exp, coef_man,
 					ds_coef_exp, ds_coef_man, clock;
 
-				clock = channel->val & CHANNEL_T ? 80 : 40;
+				clock = channel->val & CHANNEL_TURBO ? 80 : 40;
 				coef_scaled = ((5 * (clock << 24)) / 2) /
 					channel->freq;
 
-- 
1.5.2.5

