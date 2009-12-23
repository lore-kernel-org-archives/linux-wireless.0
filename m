Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31698 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbZLWCgS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 21:36:18 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2009 18:36:18 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19249.34294.19925.963051@gargle.gargle.HOWL>
Date: Wed, 23 Dec 2009 08:22:38 +0530
To: Luis Rodriguez <lrodriguez@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner case
In-Reply-To: <43e72e890912221716r64ea4542qd747302b536a3156@mail.gmail.com>
References: <20091222022355.GA32508@bombadil.infradead.org>
	<19248.19829.293087.367661@gargle.gargle.HOWL>
	<20091222155005.GA4385@tux>
	<20091222162055.GC4385@tux>
	<20091222165528.GE4385@tux>
	<20091222175939.GF4385@tux>
	<43e72e890912221716r64ea4542qd747302b536a3156@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis Rodriguez wrote:
> OK I have to go now but I managed to get this working without the
> issue coming up. At this point I am not sure if all of these are
> required but I cherry picked 2 patches from wireless-testing and then
> added 4, one based on sujith's suggestion.
> 
> http://bombadil.infradead.org/~mcgrof/patches/pm-stuff/0001-mac80211-fix-resume.patch
> http://bombadil.infradead.org/~mcgrof/patches/pm-stuff/0002-mac80211-fix-WMM-AP-settings-application.patch
> 
> http://bombadil.infradead.org/~mcgrof/patches/pm-stuff/0003-ath9k-set-and-restore-ps-prior-to-stop-and-interface.patch
> http://bombadil.infradead.org/~mcgrof/patches/pm-stuff/0004-ath9k-ensure-hardware-is-awake-during-ampdu-TX-actio.patch
> 
> http://bombadil.infradead.org/~mcgrof/patches/pm-stuff/0005-ath9k-synch-TX-DMA-buffer-upon-TX-cancelation.patch
> http://bombadil.infradead.org/~mcgrof/patches/pm-stuff/0006-ath9k-do-not-wake-up-device-if-it-hasn-t-been-starte.patch
> 
> Its likely only patch 3, 4, and 6 are the only ones required. In fact
> maybe even 6 will fix it, but I just gotta go so cannot test that. I
> was able to resume about 10 times consecutively which I was unable to
> do before.

Probably lucky. :)
None of the above patches address the issue of allowing configuration requests
after the chip has been shut down.

Can you try this on top of the earlier one I sent out ?

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 419c382..7fdcc6b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2673,6 +2673,11 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&sc->mutex);
 
+	if (sc->sc_flags & SC_OP_INVALID) {
+		mutex_unlock(&sc->mutex);
+		return 0;
+	}
+
 	/*
 	 * Leave this as the first check because we need to turn on the
 	 * radio if it was disabled before prior to processing the rest

