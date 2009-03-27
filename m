Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61539 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZC0O1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 10:27:41 -0400
Received: by fxm2 with SMTP id 2so1049162fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 07:27:38 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 27 Mar 2009 15:27:22 +0100
Message-ID: <2da21fe50903270727m7b7007ctaa846aea61902436@mail.gmail.com> (sfid-20090327_152743_608753_B932A0E5)
Subject: ath9k and power management
From: Davide Pesavento <davidepesa@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm running a 2.6.29-wl kernel, using ath9k and wpa_supplicant 0.6.9
(with -Dnl80211).
Enabling power management when connected (i.e. 'iwconfig wlan0 power
on'), causes the currently established connection to break and the
machine is no longer able to reconnect to the AP. Right after enabling
pm, dmesg says:

[ 2625.513233] wlan0: beacon loss from AP 00:1b:2f:35:14:78 - sending
probe request
[ 2627.513210] wlan0: no probe response from AP 00:1b:2f:35:14:78 -
disassociating
[ 2627.514430] phy0: Removed STA 00:1b:2f:35:14:78
[ 2627.543407] phy0: Destroyed STA 00:1b:2f:35:14:78
[ 2776.444279] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 2776.659861] wlan0: deauthenticating by local choice (reason=3)
[ 2776.831004] ADDRCONF(NETDEV_UP): wlan0: link is not ready

When I turn power management off again, wpa_supplicant is able to
reconnect just fine.
Is this a known bug? If ath9k doesn't support power management
properly, wouldn't it be better to reject the userspace request right
away?

Thanks,
Davide
