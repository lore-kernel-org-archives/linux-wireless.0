Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:45472 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbaGWRO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 13:14:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
CC: <ath10k@lists.infradead.org>,
	<mathias.kretschmer@fokus.fraunhofer.de>,
	<kgiori@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<sven@narfation.org>
Subject: Re: [PATCHv3 0/2] ath10k spectral scan support
References: <1406130837-10353-1-git-send-email-sw@simonwunderlich.de>
Date: Wed, 23 Jul 2014 20:14:53 +0300
In-Reply-To: <1406130837-10353-1-git-send-email-sw@simonwunderlich.de> (Simon
	Wunderlich's message of "Wed, 23 Jul 2014 17:53:55 +0200")
Message-ID: <87mwc0ro8i.fsf@kamboji.qca.qualcomm.com> (sfid-20140723_191507_728395_05424DC5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Wunderlich <sw@simonwunderlich.de> writes:

> This is the third "PATCH" patchset iteration for the ath10k spectral
> scan feature. It includes quite a few style fixes, the compile issues
> were fixed when debugfs were disabled, and sending WMI commands after
> a firmware crash should not happen any more. Thanks to Michal, Chun-Yeow
> and Kalle for reviewing!
>
> To view the samples, please have a look at the fft_eval tool [1] which
> now supports both ath9k and ath10k formats.
>
> The count issue is still open: Even when a count is specified, the
> hardware seems to send endless samples. It seems to work most of the
> time in VHT80 mode though, but in HT20 and HT40 the count value seems
> to be ignored. To reproduce this, start hostapd with the desired
> channel width and do:
>
> echo 8 > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_count
> echo manual > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
> echo trigger > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
> cat /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan0 >> /tmp/fft.dump
>
> Repeating the last line and checking the filesize will easily show
> whether ath10k still sends samples or not. We would expect 8 samples in
> this configuration.
>
> Please see the patches for more information on the changes.

This one had conflicts so I'm dropping it.

-- 
Kalle Valo
