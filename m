Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:43593 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab3K2RGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 12:06:54 -0500
Received: by mail-we0-f181.google.com with SMTP id x55so9315590wes.26
        for <linux-wireless@vger.kernel.org>; Fri, 29 Nov 2013 09:06:53 -0800 (PST)
From: Michal Nazarewicz <mpn@google.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: ath9k: avoid possible NULL pointer dereference
Date: Fri, 29 Nov 2013 18:06:46 +0100
Message-Id: <1385744806-10079-1-git-send-email-mpn@google.com> (sfid-20131129_180658_939567_1A7B65FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Nazarewicz <mina86@mina86.com>

Code in ath9k_hw_set_clockrate function indicates that ah->curchan
(and thus chan local variable) may be NULL.  If that is indeed the
case, IS_CHAN_HT40(chan) check has to be performed only in branch
where chan is not NULL.  Moving the code under already existing
if condition fixes this issue.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 54b0415..8918035 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -146,10 +146,9 @@ static void ath9k_hw_set_clockrate(struct ath_hw *ah)
 	else
 		clockrate = ATH9K_CLOCK_RATE_5GHZ_OFDM;
 
-	if (IS_CHAN_HT40(chan))
-		clockrate *= 2;
-
-	if (ah->curchan) {
+	if (chan) {
+		if (IS_CHAN_HT40(chan))
+			clockrate *= 2;
 		if (IS_CHAN_HALF_RATE(chan))
 			clockrate /= 2;
 		if (IS_CHAN_QUARTER_RATE(chan))
-- 
1.8.4.1

