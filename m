Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43484 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1DGSFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 14:05:40 -0400
Received: by wya21 with SMTP id 21so2448373wya.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 11:05:39 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 7 Apr 2011 14:05:39 -0400
Message-ID: <BANLkTimL90zWhpHPzODNAWXKtVVtWFfdmQ@mail.gmail.com>
Subject: [PATCH] p54: Initialize extra_len in p54_tx_80211
From: Jason Conti <jason.conti@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When compiling with gcc-4.5 and CONFIG_DEBUG_SECTION_MISMATCH=y (which enables
-fno-inline-functions-called-once), p54_tx_80211_header will not be
inlined and extra_len will quickly
become corrupted because it uninitialized. The outgoing buffer fills
up before an attempt
to associate with a WPA access point can complete (it goes into an
associating 1, 2, 3, timed out
direct probe 1, 2, 3 timed out loop with wpa_supplicant and the driver
constantly returns ENOMEM).

I think this was previously hidden because in gcc-4.4, as well a
gcc-4.5 without
-fno-inline-functions-called-once, p54_tx_80211_header is always
inlined, which may have limited
the corruption.

It was suggested I submit this upstream by Stefan Bader to resolve LP: #722185

This patch is against 2.6.38.2

Signed-off-by: Jason Conti
---
--- a/drivers/net/wireless/p54/txrx.c	2011-04-06 18:05:01.951581773 -0400
+++ b/drivers/net/wireless/p54/txrx.c	2011-04-06 18:05:26.195581762 -0400
@@ -705,7 +705,7 @@ int p54_tx_80211(struct ieee80211_hw *de
 	struct p54_tx_info *p54info;
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
-	unsigned int padding, len, extra_len;
+	unsigned int padding, len, extra_len = 0;
 	int i, j, ridx;
 	u16 hdr_flags = 0, aid = 0;
 	u8 rate, queue = 0, crypt_offset = 0;
