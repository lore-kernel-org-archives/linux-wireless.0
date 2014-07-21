Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:55916 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933219AbaGUSgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 14:36:05 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
CC: <ath10k@lists.infradead.org>,
	<mathias.kretschmer@fokus.fraunhofer.de>,
	<kgiori@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<sven@narfation.org>
Subject: Re: [PATCHv2 2/2] ath10k: add spectral scan feature
References: <1405945943-8303-1-git-send-email-sw@simonwunderlich.de>
	<1405945943-8303-3-git-send-email-sw@simonwunderlich.de>
Date: Mon, 21 Jul 2014 21:35:58 +0300
In-Reply-To: <1405945943-8303-3-git-send-email-sw@simonwunderlich.de> (Simon
	Wunderlich's message of "Mon, 21 Jul 2014 14:32:23 +0200")
Message-ID: <87r41ewodt.fsf@kamboji.qca.qualcomm.com> (sfid-20140721_203618_911782_EB5C0CC9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Wunderlich <sw@simonwunderlich.de> writes:

> Adds the spectral scan feature for ath10k. The spectral scan is triggered by
> configuring a mode through a debugfs control file. Samples can be gathered via
> another relay debugfs file.
>
> Essentially, to try it out:
>
> ip link set dev wlan0 up
> echo background > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
> iw dev wlan0 scan
> echo disable > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
> cat /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan0 > samples
>
> This feature is still experimental. Based on the original RFC patch of
> Sven Eckelmann.
>
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

While I was commiting this to ath-next-test for build tests and review,
I had a trivial conflict. Please check the patch:

https://github.com/kvalo/ath/commit/85dec746d1f4728176bd06a53b6da4ef014f2a27

Oddly enough with this patch I see a new warning:

include/uapi/linux/swab.h:71:16: error: undefined identifier '__builtin_bswap64'

But I guess there's not much we can do about that?

-- 
Kalle Valo
