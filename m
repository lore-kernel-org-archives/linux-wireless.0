Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36795 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965Ab1EZRIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 13:08:05 -0400
Received: by yia27 with SMTP id 27so367045yia.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 May 2011 10:08:04 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 27 May 2011 01:08:04 +0800
Message-ID: <BANLkTi=uCB4Oya0UTRH7es5LHYpZi=VFCg@mail.gmail.com> (sfid-20110526_190820_421122_4D5112D3)
Subject: [PATCH] ath9k: Fix AR9287 calibration
From: Adrian Chadd <adrian.chadd@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AR9287 calibration code was not being called because of an
incorrect MAC revision check.
This forced the AR9287 to use the AR9285 initial calibration code and
bypass the AR9287 code entirely.

Signed-off-by: Adrian Chadd <adrian@freebsd.org>

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
