Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:53749 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896Ab0JMPYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 11:24:44 -0400
Date: Wed, 13 Oct 2010 17:29:31 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Set RX filter for Probe Request based on filter flag
Message-ID: <20101013142931.GA7003@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows mac80211 to enable receiving of Probe Request frames in
station mode which is needed for P2P.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/ath9k/main.c |    1 +
 drivers/net/wireless/ath/ath9k/recv.c |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

This depends on the "mac80211: add probe request filter flag" from
Johannes.


--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/recv.c	2010-10-13 06:39:30.000000000 -0700
+++ wireless-testing/drivers/net/wireless/ath/ath9k/recv.c	2010-10-13 06:46:42.000000000 -0700
@@ -430,8 +430,7 @@ u32 ath_calcrxfilter(struct ath_softc *s
 		| ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
 		| ATH9K_RX_FILTER_MCAST;
 
-	/* If not a STA, enable processing of Probe Requests */
-	if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
+	if (sc->rx.rxfilter & FIF_PROBE_REQ)
 		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
 
 	/*
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2010-10-13 06:42:25.000000000 -0700
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2010-10-13 07:24:45.000000000 -0700
@@ -1739,6 +1739,7 @@ skip_chan_change:
 	FIF_PSPOLL |				\
 	FIF_OTHER_BSS |				\
 	FIF_BCN_PRBRESP_PROMISC |		\
+	FIF_PROBE_REQ |				\
 	FIF_FCSFAIL)
 
 /* FIXME: sc->sc_full_reset ? */

-- 
Jouni Malinen                                            PGP id EFC895FA
