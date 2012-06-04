Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38858 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760445Ab2FDMYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 08:24:22 -0400
Received: by ghrr11 with SMTP id r11so3234013ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jun 2012 05:24:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120604110811.GA3671@redhat.com>
References: <20120517230400.GB22418@yumi.tdiedrich.de>
	<CAGXE3d_Yz=-UWO+PiJkRQ7ZSBgh_fdcwsPz6FCig2VjOOoMQOg@mail.gmail.com>
	<20120518162158.GE22418@yumi.tdiedrich.de>
	<CAGXE3d8e+hYo_MT30XUW+r4-Dq6AgqLTJxD_oGnRuR94zjZ7_Q@mail.gmail.com>
	<4FB769DF.5060400@01019freenet.de>
	<4FBB5083.4000606@01019freenet.de>
	<CAGXE3d-2ndXX1D-JQLo6m=Osg6RRe4Z2gb_=BPrz0wASzFciNA@mail.gmail.com>
	<20120604110811.GA3671@redhat.com>
Date: Mon, 4 Jun 2012 14:24:21 +0200
Message-ID: <CAGXE3d8PE6OZ3z8uLGfTTx5TMEJNOUNzMfWeb7N-OmpHNBo6Zw@mail.gmail.com> (sfid-20120604_142432_169441_CFC12C66)
Subject: Re: [PATCH] rt2800: Initialize max_txpower to MAX_G_TXPOWER and
 MAX_A_TXPOWER respectively
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Jun 4, 2012 at 1:08 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Tue, May 22, 2012 at 12:02:24PM +0200, Helmut Schaa wrote:
>> Btw. I've got a proof-of-concept patch for this but need to dig it up first.
>
> So, when you will post it  ? :-)

Now :D

However, treat this with care, and it still requires Tobias initial
cfg80211 patch  ...

Helmut

>From 44e01b6fcfa70fa2d015b30bab0cb1fb377dd3ca Mon Sep 17 00:00:00 2001
From: Helmut Schaa <helmut.schaa@googlemail.com>
Date: Mon, 4 Jun 2012 14:19:38 +0200
Subject: [PATCH] rt2x00: Allow txpower control on rt2800 devices
without eirp max tx power

Some rt2800 devices don't have their calibrated max eirp tx power in
their calibration data. For these devices we only allow tx power
reduction. As a calculation base we use the maximum allowed tx power as
imposed by the regulatory framework.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   56 ++++++++++++++++++++++++++-----
 1 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c
b/drivers/net/wireless/rt2x00/rt2800lib.c
index f028aa5..2304d0d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2330,6 +2330,24 @@ static int rt2800_get_txpower_bw_comp(struct
rt2x00_dev *rt2x00dev,
 	return comp_value;
 }

+static int rt2800_get_txpower_reg_delta(struct rt2x00_dev *rt2x00dev,
+					int power_level)
+{
+	if (!test_bit(CAPABILITY_POWER_LIMIT, &rt2x00dev->cap_flags))
+		return 0;
+
+	/*
+	 * XXX: We don't know the maximum transmit power of our hardware since
+	 * the EEPROM doesn't expose it. We only know that we are calibrated
+	 * to 100% tx power.
+	 *
+	 * Hence, we assume the regulatory limit that cfg80211 calulated for
+	 * the current channel is our maximum and if we are requested to lower
+	 * the value we just reduce our tx power accordingly.
+	 */
+	return power_level - rt2x00dev->hw->conf.channel->max_power;
+}
+
 static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int
is_rate_b,
 				   enum ieee80211_band band, int power_level,
 				   u8 txpower, int delta)
@@ -2341,9 +2359,6 @@ static u8 rt2800_compensate_txpower(struct
rt2x00_dev *rt2x00dev, int is_rate_b,
 	u8 eirp_txpower_criterion;
 	u8 reg_limit;

-	if (!((band == IEEE80211_BAND_5GHZ) && is_rate_b))
-		return txpower;
-
 	if (test_bit(CAPABILITY_POWER_LIMIT, &rt2x00dev->cap_flags)) {
 		/*
 		 * Check if eirp txpower exceed txpower_limit.
@@ -2370,10 +2385,17 @@ static u8 rt2800_compensate_txpower(struct
rt2x00_dev *rt2x00dev, int is_rate_b,

 		reg_limit = (eirp_txpower > power_level) ?
 					(eirp_txpower - power_level) : 0;
-	} else
-		reg_limit = 0;

-	return txpower + delta - reg_limit;
+		return txpower + delta - reg_limit;
+	} else if (delta < 0) {
+		/*
+		 * For devices without calibrated max EIRP tx power only allow
+		 * tx power reduction.
+		 */
+		return txpower + delta;
+	}
+
+	return txpower;
 }

 static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
@@ -2399,13 +2421,29 @@ static void rt2800_config_txpower(struct
rt2x00_dev *rt2x00dev,
 	delta += rt2800_get_gain_calibration_delta(rt2x00dev);

 	/*
-	 * set to normal bbp tx power control mode: +/- 0dBm
+	 * Apply regulatory delta
+	 */
+	delta += rt2800_get_txpower_reg_delta(rt2x00dev, power_level);
+
+	/*
+	 * Set bbp tx power control mode
 	 */
 	rt2800_bbp_read(rt2x00dev, 1, &r1);
-	rt2x00_set_field8(&r1, BBP1_TX_POWER_CTRL, 0);
+	if (delta <= -12) {
+		/* reduce tx power by 12 dBm */
+		rt2x00_set_field8(&r1, BBP1_TX_POWER_CTRL, 2);
+		delta += 12;
+	} else if (delta <= -6) {
+		/* reduce tx power by 6 dBm */
+		rt2x00_set_field8(&r1, BBP1_TX_POWER_CTRL, 1);
+		delta += 6;
+	} else {
+	 	/* set to normal bbp tx power control mode: +/- 0dBm */
+		rt2x00_set_field8(&r1, BBP1_TX_POWER_CTRL, 0);
+	}
 	rt2800_bbp_write(rt2x00dev, 1, r1);
-	offset = TX_PWR_CFG_0;

+	offset = TX_PWR_CFG_0;
 	for (i = 0; i < EEPROM_TXPOWER_BYRATE_SIZE; i += 2) {
 		/* just to be safe */
 		if (offset > TX_PWR_CFG_4)
-- 
1.7.7
