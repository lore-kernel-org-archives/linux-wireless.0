Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:57495 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaGVFCC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 01:02:02 -0400
Received: by mail-vc0-f179.google.com with SMTP id hq11so12319988vcb.38
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 22:02:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj9878tYieueZn4fn4EZSgPSTTnoTj4Xb8wu_Es1gHy0KEqQ@mail.gmail.com>
References: <1405689992-8538-1-git-send-email-sw@simonwunderlich.de>
	<1405689992-8538-3-git-send-email-sw@simonwunderlich.de>
	<CAEFj986Vruig8wCP+RLS_gQf8utAirmTDCKwmMGyfj7B2vH9pw@mail.gmail.com>
	<201407211143.04868.sw@simonwunderlich.de>
	<CAEFj9878tYieueZn4fn4EZSgPSTTnoTj4Xb8wu_Es1gHy0KEqQ@mail.gmail.com>
Date: Tue, 22 Jul 2014 13:02:01 +0800
Message-ID: <CAEFj985r+nA3Sr2x0aExaZxnhzs24r=Teguowq+3AcDyV4Xt_A@mail.gmail.com> (sfid-20140722_070212_345090_BC037DAD)
Subject: Re: [PATCH 2/2] ath10k: add spectral scan feature
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	mathias.kretschmer@fokus.fraunhofer.de, kgiori@qca.qualcomm.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Simon

Sorry, resend-email...

>>
>> Thanks for the output! Could it be that you are using the old RFC patch with
>> the new fft-eval? I've added another byte (max_exp), so the header became
>> longer. Please try again with the latest patch (from this thread), if that is
>> the case. Otherwise we have to find out whats wrong ... The sample_len as used
>> in fft_eval (tlv-header + data) should be 93 with that version.
>
Yes, you are right. I am picking out the ath-next-test branch which is
using the RFC old patch before that.

By the way, the new submitted patch v2 [1] has taken out the following:

if (mode == SPECTRAL_BACKGROUND)
ath10k_spectral_scan_trigger(ar);

So should we add the trigger command in the comment?

ip link set dev wlan0 up
echo background > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
echo trigger > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
iw dev wlan0 scan
echo disable > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
cat /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan0 > samples

Otherwise, I am not able to get any useful data.

-----
Chun-Yeow

[1] http://lists.infradead.org/pipermail/ath10k/2014-July/002711.html
