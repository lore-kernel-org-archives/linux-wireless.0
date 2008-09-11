Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:25354 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYIKU3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 16:29:40 -0400
Received: by wf-out-1314.google.com with SMTP id 27so496329wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2008 13:29:38 -0700 (PDT)
Message-ID: <2da21fe50809111329q2d0cbaaayea6b57acdd6a6e28@mail.gmail.com> (sfid-20080911_222944_824589_D49EB2D8)
Date: Thu, 11 Sep 2008 22:29:38 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Frequent disconnections with ath9k
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm running a recent kernel from the wireless-testing tree (using
ath9k driver) and I'm experiencing disconnections very frequently.
Versions before 2.6.27-rc4 were working much better... The regression
was probably introduced between 2.6.27-rc4-wl-15768-g4829c3c and
2.6.27-rc4-wl-16055-g46160f5, but I'm not completely sure.

This is what dmesg shows:

[ 3416.627799] wlan0: No ProbeResp from current AP 00:1b:2f:XX:XX:XX -
assume out of range
[ 3416.628680] phy0: Removed STA 00:1b:2f:XX:XX:XX
[ 3416.667944] phy0: Destroyed STA 00:1b:2f:XX:XX:XX

(a bunch of "phy0: HW CONFIG: freq=....", I guess it's doing a scan)

[ 3419.012381] wlan0: authenticate with AP 00:1b:2f:XX:XX:XX
[ 3419.209948] wlan0: authenticate with AP 00:1b:2f:XX:XX:XX
[ 3419.409965] wlan0: authenticate with AP 00:1b:2f:XX:XX:XX
[ 3419.609927] wlan0: authentication with AP 00:1b:2f:XX:XX:XX timed out

Sometimes it gets really annoying because it disconnects 3 or 4 times
in less than a minute.
iwconfig reports a link quality of 25-35/100 and a fixed bitrate of 1
Mb/s, but under MacOS X the card works pretty fine: it never
disconnects and I get good transmission rates.

Regards,
Davide Pesavento
