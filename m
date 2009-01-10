Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:40378 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbZAJBVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 20:21:46 -0500
Received: by bwz14 with SMTP id 14so29805558bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 17:21:44 -0800 (PST)
Message-ID: <888a464d0901091721l6657e755vbfe5bae0367f6413@mail.gmail.com> (sfid-20090110_022150_625117_5B992ABE)
Date: Sat, 10 Jan 2009 02:21:44 +0100
From: darklight <darklight.xdarklight@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: ignore the return value of ath5k_hw_noise_floor_calibration
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

some weeks ago Felix Fietkau posted a patch for the "ath5k phy0:
unsupported jumbo" warnings (see here:
http://article.gmane.org/gmane.linux.kernel.wireless.general/23430 )
I just had the same problem - after applying Felix' patch the warnings
went down from 50-100 per day to 5.

as a quick note: I did not just apply this patch, instead I replaced
Linus' upstream wireless stack with the one from wireless-testing
(using kernel version 2.6.28)

I hope Felix' patch can get into Linus' kernel (mainline) so other
users can profit from this

oh and just to make sure this patch will get accepted:
ath5k_hw_noise_floor_calibration was called without verifying it's
result in ath5k_hw_rf511x_calibrate -> so in theory this patch is
clean an get into mainline (just to be fair: I must admit I'm not
familiar with the mac80211 nor with ath5k code)

regards,
Martin
