Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33440 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3K0Pi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 10:38:28 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21142.4319.977971.553792@gargle.gargle.HOWL> (sfid-20131127_163832_208603_567C00CF)
Date: Wed, 27 Nov 2013 21:03:51 +0530
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k pending patches
In-Reply-To: <5295EB1D.1050604@meshcoding.com>
References: <1385547828-4330-1-git-send-email-sujith@msujith.org>
	<21141.51790.303263.385517@gargle.gargle.HOWL>
	<5295EB1D.1050604@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antonio Quartulli wrote:
> What does this ALWAYS_PERFORM_KEY_SEARCH bit do? Is it set within the
> initvalues?

Here is a patch to set ALWAYS_PERFORM_KEY_SEARCH for AR9300 2.2.
Since AR9331, AR9340 and AR9580 use the same array, it applies for
them too.


diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 1553395..819ecf3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -303,7 +303,7 @@ static const u32 ar9300_2p2_mac_postamble[][5] = {
 	{0x000010b0, 0x00000e60, 0x00001cc0, 0x00007c70, 0x00003e38},
 	{0x00008014, 0x03e803e8, 0x07d007d0, 0x10801600, 0x08400b00},
 	{0x0000801c, 0x128d8027, 0x128d804f, 0x12e00057, 0x12e0002b},
-	{0x00008120, 0x08f04800, 0x08f04800, 0x08f04810, 0x08f04810},
+	{0x00008120, 0x18f04800, 0x18f04800, 0x18f04810, 0x18f04810},
 	{0x000081d0, 0x00003210, 0x00003210, 0x0000320a, 0x0000320a},
 	{0x00008318, 0x00003e80, 0x00007d00, 0x00006880, 0x00003440},
 };


Sujith
