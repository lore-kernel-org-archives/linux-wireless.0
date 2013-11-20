Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:41112 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3KTS7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 13:59:46 -0500
Received: by mail-la0-f44.google.com with SMTP id ep20so7812679lab.31
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 10:59:45 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 20 Nov 2013 19:59:45 +0100
Message-ID: <CAEk6gTD66duJkKrWNh_5e+3XdfD82JUaBW2zimj-ncSXZYQqvA@mail.gmail.com> (sfid-20131120_195959_075940_7A7F23F6)
Subject: ath6kl AP in 802.11n not possible: ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE
 not set in (latest) linux-firmware
From: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
To: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com,
	kvalo@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	raychen@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
I have spend several days debugging ath6kl driver to work well in AP
mode for 802.11n (i.e. when ieee80211n=1 in hostapd.conf). With this
setting hostapd was constantly failing with: nl80211: Failed to set
channel (freq=2442): -22 (Invalid argument), please refer to the
http://www.spinics.net/lists/linux-wireless/msg113987.html

I am using AR9374 based USB dongle, UB134 reference design (AR6004
firmware, i.e. hw1.3,
http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/tree/ath6k/AR6004/hw1.3).
On fw load driver outputs the message: ath6kl: ar6004 hw 1.3 usb fw
3.5.0.2356 api 3.

Ftrace in the kernel lead me to the cfg80211_chandef_usable()
(http://lxr.free-electrons.com/source/net/wireless/chan.c#L47), which
was failing on the checks of ht_cap->ht_supported. For some reasons
these were FALSE, even that they should be present. Further inspection
leads to ath6kl_cfg80211_init(), and especially this check of
ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE:
https://github.com/kvalo/ath/blob/master/drivers/net/wireless/ath/ath6kl/cfg80211.c#L3767
which fails, and thus HT is not supported anymore, breaking hostapd
and making it impossible to put the dongle in the AP 802.11n mode.
Previous to this check, ht was set to TRUE on WMI_11AGN_CAP case
(https://github.com/kvalo/ath/blob/master/drivers/net/wireless/ath/ath6kl/cfg80211.c#L3750),
which I verified with printk.

Googling aroud led me to these patches:
http://permalink.gmane.org/gmane.linux.kernel.wireless.general/89741
http://www.spinics.net/lists/linux-wireless/msg87931.html

Commenting out these checks I was able to put the dongle in both
802.11gn and 802.11an in AP mode without encryption and with WPAm but
not without WPA2 (probably because of 4-way handshaking mentioned in
the comments).

Can we characterize this behavior like a bug in the firmware, or is
this limitation is intentional (which I doubt)?


Bug summary: ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE not set in latest
linux-firmware, AP mode in 802.11n not possible, breaks hostapd when
ieee80211n=1
ATH chipset: AR9374 based USB dongle, UB134 reference design
FW: ar6004 hw 1.3 usb fw 3.5.0.2356 api 3
hostpad: latest stable, hostapd-2.0
linux-firmware: latest from the
http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git
(git hash 7d0c7a8cfd78388d90cc784a185b19dcbdbce824)


Best regards,
Drasko
