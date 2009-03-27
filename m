Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:61346 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbZC0EHd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 00:07:33 -0400
Subject: Re: [ath5k-devel] [BISECTED] AR5414 fails to scan after "ath5k:
 Update reset code"
From: Pavel Roskin <proski@gnu.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <40f31dec0903251847p260446bfi22a1b4c587dc41cc@mail.gmail.com>
References: <1238020625.15025.15.camel@mj>
	 <40f31dec0903251847p260446bfi22a1b4c587dc41cc@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 00:07:29 -0400
Message-Id: <1238126849.20768.12.camel@mj> (sfid-20090327_050735_550143_5E423D6C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-03-26 at 03:47 +0200, Nick Kossifidis wrote:

> That's weird, I've tested this with my 5413 and it works just fine. It
> seems that 5424 (pci-e version of 5413) still has some issues. Have
> you tried monitor mode ?

I have reduced the patch to the clock setting in ath5k_hw_nic_wakeup().

Testing with madwifi-free shows that the clock register for 802.11a
channels for RF5413 should be 0x04.  ath5k uses 0x44
(AR5K_PHY_PLL_40MHZ_5413 | AR5K_PHY_PLL_RF5112).  The value before the
patch that broke scanning was 0xea (AR5K_PHY_PLL_40MHZ |
AR5K_PHY_PLL_RF5112).

With the following patch, scanning works for both 2.4 GHz and 5 GHz
bands.  Please test with your hardware.  If it works, I'll submit it.


ath5k: fix scanning in AR2424

AR5K_PHY_PLL_40MHZ_5413 shouldn't be ORed with AR5K_PHY_MODE_RAD_RF5112.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/ath5k/reset.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/ath5k/reset.c b/drivers/net/wireless/ath5k/reset.c
index 7a17d31..faede82 100644
--- a/drivers/net/wireless/ath5k/reset.c
+++ b/drivers/net/wireless/ath5k/reset.c
@@ -359,7 +359,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 			mode |= AR5K_PHY_MODE_FREQ_5GHZ;
 
 			if (ah->ah_radio == AR5K_RF5413)
-				clock |= AR5K_PHY_PLL_40MHZ_5413;
+				clock = AR5K_PHY_PLL_40MHZ_5413;
 			else
 				clock |= AR5K_PHY_PLL_40MHZ;
 


-- 
Regards,
Pavel Roskin
