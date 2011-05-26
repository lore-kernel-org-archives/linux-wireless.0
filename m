Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43248 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab1EZFAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 01:00:36 -0400
Received: by yia27 with SMTP id 27so150791yia.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 May 2011 22:00:35 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 26 May 2011 13:00:35 +0800
Message-ID: <BANLkTimrSD-zB5q+oM=8HkZ1nsTUNEG81g@mail.gmail.com> (sfid-20110526_070039_292611_4CC1D1D5)
Subject: [PATCH] ath9k: Fix Kiwi (AR9287) initial calibration
From: Adrian Chadd <adrian@freebsd.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The AR9287 initial calibration in ar9002_hw_init_cal() isn't ever
called because the Kite check (AR_SREV_9285_12_OR_LATER()) matches on
MACs versioned Kite and later.

The Atheros newma code checks it is Kite as well as being Kite >= 1.2.

I don't currently have Linux ath9k on something with an AR9287 so I'd
appreciate it if this were verified by someone who has.

The patch is quite simple:

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 015d974..2d4c091 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -829,7 +829,7 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah,
struct ath9k_channel *chan)
        if (AR_SREV_9271(ah)) {
                if (!ar9285_hw_cl_cal(ah, chan))
                        return false;
-       } else if (AR_SREV_9285_12_OR_LATER(ah)) {
+       } else if (AR_SREV_9285(ah) && AR_SREV_9285_12_OR_LATER(ah)) {
                if (!ar9285_hw_clc(ah, chan))
                        return false;
        } else {

Thanks,


Adrian
