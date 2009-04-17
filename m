Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f211.google.com ([209.85.218.211]:50311 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbZDQUD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 16:03:59 -0400
Received: by bwz7 with SMTP id 7so312056bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2009 13:03:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2da21fe50903270727m7b7007ctaa846aea61902436@mail.gmail.com>
References: <2da21fe50903270727m7b7007ctaa846aea61902436@mail.gmail.com>
From: Davide Pesavento <davidepesa@gmail.com>
Date: Fri, 17 Apr 2009 21:57:30 +0200
Message-ID: <2da21fe50904171257v17ea8431h1979f0d004885600@mail.gmail.com> (sfid-20090417_220403_443847_A2C0E9C7)
Subject: Re: ath9k and power management
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 27, 2009 at 16:27, Davide Pesavento <davidepesa@gmail.com> wrote:
> Hello,
>
> I'm running a 2.6.29-wl kernel, using ath9k and wpa_supplicant 0.6.9
> (with -Dnl80211).
> Enabling power management when connected (i.e. 'iwconfig wlan0 power
> on'), causes the currently established connection to break and the
> machine is no longer able to reconnect to the AP. Right after enabling
> pm, dmesg says:
>
> [ 2625.513233] wlan0: beacon loss from AP 00:1b:2f:35:14:78 - sending
> probe request
> [ 2627.513210] wlan0: no probe response from AP 00:1b:2f:35:14:78 -
> disassociating
> [ 2627.514430] phy0: Removed STA 00:1b:2f:35:14:78
> [ 2627.543407] phy0: Destroyed STA 00:1b:2f:35:14:78
> [ 2776.444279] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [ 2776.659861] wlan0: deauthenticating by local choice (reason=3)
> [ 2776.831004] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>
> When I turn power management off again, wpa_supplicant is able to
> reconnect just fine.
> Is this a known bug? If ath9k doesn't support power management
> properly, wouldn't it be better to reject the userspace request right
> away?
>

This is still unfixed on latest git (2.6.30-rc2-wl). The symptoms are
exactly the same as reported above.

Regards,
Davide
