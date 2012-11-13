Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:53725
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab2KMH2X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 02:28:23 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20641.63106.943323.923565@gargle.gargle.HOWL> (sfid-20121113_082834_068383_4707CF11)
Date: Tue, 13 Nov 2012 12:58:02 +0530
To: Corey Richardson <corey@octayn.net>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org, netdev@vger.kernel.org,
	nbd@openwrt.org
Subject: ath9k_htc-based adapter unfunctioning after commit ceb26a6013
In-Reply-To: <CA++BO6SuRgOu7A4BKobrdEeSpSc3UUYHXaECmEGE=R17w7HjQA@mail.gmail.com>
References: <CA++BO6SuRgOu7A4BKobrdEeSpSc3UUYHXaECmEGE=R17w7HjQA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Corey Richardson wrote:
> I was giving 3.7-rc4 a whirl when I discovered my wireless adapter [0] wasn't
> working: the LED didn't light up. Went and ran 'ip link' and it just hung there.
> Tried a few other things and discovered that sudo was broken too. With
> strace I found that they were hanging in sendto().
> 
> If I then unplug the adapter, everything comes out of the hang.
> 
> Bisected and found that commit ceb26a6013b962b82f644189ea29d802490fc8fc is
> to blame.

I can see this issue too. I am not entirely convinced that the commit in
question is valid. If a HW reset fails for some reason in start(), bailing
out seems the right thing to do instead of continuing to fiddle with the HW
and silently returning a success code to mac80211.

I was able to bring up the device with this patch.

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 756191b..e06bcec 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1456,7 +1456,7 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
 	switch (type) {
 	case ATH9K_RESET_POWER_ON:
 		ret = ath9k_hw_set_reset_power_on(ah);
-		if (!ret)
+		if (ret)
 			ah->reset_power_on = true;
 		break;
 	case ATH9K_RESET_WARM:

Sujith
