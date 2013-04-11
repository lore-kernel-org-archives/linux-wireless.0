Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:34697 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750806Ab3DKSfb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 14:35:31 -0400
Message-ID: <1365705330.1929.30.camel@joe-AO722> (sfid-20130411_203535_327456_D565AAAD)
Subject: Re: [PATCH] Fix uninitialized-variable warnings.
From: Joe Perches <joe@perches.com>
To: Han Shen <shenhan@google.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	chaoming_li@realsil.com.cn
Date: Thu, 11 Apr 2013 11:35:30 -0700
In-Reply-To: <1365703360-19982-1-git-send-email-shenhan@google.com>
References: <1365703360-19982-1-git-send-email-shenhan@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-04-11 at 11:02 -0700, Han Shen wrote:
> GCC 4.8 is spitting out uninitialized-varaible warnings against "drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c".
> This trivial patch just adds initialization to the variable.

Not sure this is correct.
I think the logic should be inspected instead.

ofdm_index_old[1] _is_ used uninitialized.

It appears there might be a missing

	ofdm_index_old[1] = (u8) i;

as that's the same style test done in the
section above.

Maybe this:
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index b793a65..56b2b2f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -717,6 +717,7 @@ static void rtl92c_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
 			for (i = 0; i < OFDM_TABLE_LENGTH; i++) {
 				if (ele_d == (ofdmswing_table[i] &
 				    MASKOFDM_D)) {
+					ofdm_index_old[1] = (u8) i;
 
 					RT_TRACE(rtlpriv, COMP_POWER_TRACKING,
 						 DBG_LOUD,


