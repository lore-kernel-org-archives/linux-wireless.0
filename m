Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58271 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab1IGQUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 12:20:34 -0400
Received: by mail-qy0-f181.google.com with SMTP id 34so4606902qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 09:20:34 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 7 Sep 2011 14:32:59 +0100
Message-ID: <CADPsn1bsUJqcuwZrW+e92aGms+t+TKRasnGb=ujzzgvz+S1Maw@mail.gmail.com> (sfid-20110907_182044_384290_51AEC9E4)
Subject: Question: ath6kl (driver/net/wireless/ath/ath6kl) with debug_mask value
From: Sangwook Lee <sangwook.lee@linaro.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I am running ath6kl-cleanup git.
If I add debug_mask values with ath6kl.ko as like followings, I get
the success full results,
but without this, "iwlist wlan0 scan" fails.

ath6kl: hw 2.0 fw 3.1.1.149

1) SCAN success with debug values: ( 0xc44,c40,40)
$ insmod ath.ko
$ insmod ath6kl.ko debug_mask=0x40
$ ifconfig wlan0 up
$ iwlist wlan0 scan

2) SCAN failure
$ insmod ath.ko
$ insmod ath6kl.ko
$ ifconfig wlan0 up
$ iwlist wlan0 scan
With this case, there is no coming event "WMI_SCAN_COMPLETE_EVENTID".
After receiving  "ath6kl: WMI_EXTENSION_EVENTID"
iwlist shows error message:
      wlan0     Failed to read scan data : Resource temporarily unavailable


Thanks
Sangwook
