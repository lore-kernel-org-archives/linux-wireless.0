Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52226 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab2B0X5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:57:15 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch, ralf@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 01/11] ssb: sprom fix some sizes / signedness
Date: Tue, 28 Feb 2012 00:56:04 +0100
Message-Id: <1330386974-4056-2-git-send-email-hauke@hauke-m.de> (sfid-20120228_005718_783649_DF07C417)
In-Reply-To: <1330386974-4056-1-git-send-email-hauke@hauke-m.de>
References: <1330386974-4056-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some parts of the sprom struct are bigger than needed.
The leddc and maxpwr values are just 8 bit long and not 16.
rxpo2g and rxpo5g are signed

I got these information for the open source part of the Broadcom SDK
covering sprom version 1 to 9. rxpo2g contained a negative number on my
bcm5354 based device, this cased an error and Broadcom SDK says this is
signed.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/ssb/ssb.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index bbc2612..f169621 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -33,8 +33,8 @@ struct ssb_sprom {
 	u8 et1mdcport;		/* MDIO for enet1 */
 	u16 board_rev;		/* Board revision number from SPROM. */
 	u8 country_code;	/* Country Code */
-	u16 leddc_on_time;	/* LED Powersave Duty Cycle On Count */
-	u16 leddc_off_time;	/* LED Powersave Duty Cycle Off Count */
+	u8 leddc_on_time;	/* LED Powersave Duty Cycle On Count */
+	u8 leddc_off_time;	/* LED Powersave Duty Cycle Off Count */
 	u8 ant_available_a;	/* 2GHz antenna available bits (up to 4) */
 	u8 ant_available_bg;	/* 5GHz antenna available bits (up to 4) */
 	u16 pa0b0;
@@ -53,10 +53,10 @@ struct ssb_sprom {
 	u8 gpio1;		/* GPIO pin 1 */
 	u8 gpio2;		/* GPIO pin 2 */
 	u8 gpio3;		/* GPIO pin 3 */
-	u16 maxpwr_bg;		/* 2.4GHz Amplifier Max Power (in dBm Q5.2) */
-	u16 maxpwr_al;		/* 5.2GHz Amplifier Max Power (in dBm Q5.2) */
-	u16 maxpwr_a;		/* 5.3GHz Amplifier Max Power (in dBm Q5.2) */
-	u16 maxpwr_ah;		/* 5.8GHz Amplifier Max Power (in dBm Q5.2) */
+	u8 maxpwr_bg;		/* 2.4GHz Amplifier Max Power (in dBm Q5.2) */
+	u8 maxpwr_al;		/* 5.2GHz Amplifier Max Power (in dBm Q5.2) */
+	u8 maxpwr_a;		/* 5.3GHz Amplifier Max Power (in dBm Q5.2) */
+	u8 maxpwr_ah;		/* 5.8GHz Amplifier Max Power (in dBm Q5.2) */
 	u8 itssi_a;		/* Idle TSSI Target for A-PHY */
 	u8 itssi_bg;		/* Idle TSSI Target for B/G-PHY */
 	u8 tri2g;		/* 2.4GHz TX isolation */
@@ -67,8 +67,8 @@ struct ssb_sprom {
 	u8 txpid5gl[4];		/* 4.9 - 5.1GHz TX power index */
 	u8 txpid5g[4];		/* 5.1 - 5.5GHz TX power index */
 	u8 txpid5gh[4];		/* 5.5 - ...GHz TX power index */
-	u8 rxpo2g;		/* 2GHz RX power offset */
-	u8 rxpo5g;		/* 5GHz RX power offset */
+	s8 rxpo2g;		/* 2GHz RX power offset */
+	s8 rxpo5g;		/* 5GHz RX power offset */
 	u8 rssisav2g;		/* 2GHz RSSI params */
 	u8 rssismc2g;
 	u8 rssismf2g;
-- 
1.7.5.4

