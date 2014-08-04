Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53177 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaHDGJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 02:09:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
CC: <ath10k@lists.infradead.org>,
	<mathias.kretschmer@fokus.fraunhofer.de>,
	<kgiori@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<sven@narfation.org>
Subject: Re: [PATCHv5 0/2] ath10k spectral scan support
References: <1406899034-13473-1-git-send-email-sw@simonwunderlich.de>
Date: Mon, 4 Aug 2014 09:09:29 +0300
In-Reply-To: <1406899034-13473-1-git-send-email-sw@simonwunderlich.de> (Simon
	Wunderlich's message of "Fri, 1 Aug 2014 15:17:12 +0200")
Message-ID: <877g2o6b1i.fsf@kamboji.qca.qualcomm.com> (sfid-20140804_081009_571591_8BBECA4D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Wunderlich <sw@simonwunderlich.de> writes:

> This is the fifth "PATCH" patchset iteration for the ath10k spectral
> scan feature. It includes a small change compared to Kalles PATCHv4
> series: the parameter initialization has been moved to
> ath10k_spectral_start() so that the parameters also get reset when the
> firmware crashes.
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
>
> Cheers,
>     Simon
>
> [1] https://github.com/simonwunderlich/FFT_eval
>
> Simon Wunderlich (1):
>   ath10k: add spectral scan feature
>
> Sven Eckelmann (1):
>   ath: Move spectral debugfs structs to shared header

Thanks, both patches applied.

And thanks for fixing a bug I introduced!

-- 
Kalle Valo
