Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:33115 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZDRCsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 22:48:06 -0400
Received: by qw-out-2122.google.com with SMTP id 5so367384qwd.37
        for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2009 19:48:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2da21fe50904171257v17ea8431h1979f0d004885600@mail.gmail.com>
References: <2da21fe50903270727m7b7007ctaa846aea61902436@mail.gmail.com>
	 <2da21fe50904171257v17ea8431h1979f0d004885600@mail.gmail.com>
Date: Sat, 18 Apr 2009 08:18:04 +0530
Message-ID: <8e92b4100904171948g5d961578ne46cbf1a135bfdc7@mail.gmail.com> (sfid-20090418_044814_113921_8B690D8B)
Subject: Re: ath9k and power management
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 18, 2009 at 1:27 AM, Davide Pesavento <davidepesa@gmail.com> wrote:
> On Fri, Mar 27, 2009 at 16:27, Davide Pesavento <davidepesa@gmail.com> wrote:
>> Hello,
>>
>> I'm running a 2.6.29-wl kernel, using ath9k and wpa_supplicant 0.6.9
>> (with -Dnl80211).
>> Enabling power management when connected (i.e. 'iwconfig wlan0 power
>> on'), causes the currently established connection to break and the
>> machine is no longer able to reconnect to the AP. Right after enabling
>> pm, dmesg says:
>>
>> [ 2625.513233] wlan0: beacon loss from AP 00:1b:2f:35:14:78 - sending
>> probe request
>> [ 2627.513210] wlan0: no probe response from AP 00:1b:2f:35:14:78 -
>> disassociating
>> [ 2627.514430] phy0: Removed STA 00:1b:2f:35:14:78
>> [ 2627.543407] phy0: Destroyed STA 00:1b:2f:35:14:78
>> [ 2776.444279] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [ 2776.659861] wlan0: deauthenticating by local choice (reason=3)
>> [ 2776.831004] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>>
>> When I turn power management off again, wpa_supplicant is able to
>> reconnect just fine.
>> Is this a known bug? If ath9k doesn't support power management
>> properly, wouldn't it be better to reject the userspace request right
>> away?
>>
>
> This is still unfixed on latest git (2.6.30-rc2-wl). The symptoms are
> exactly the same as reported above.

This is the power save mechanism used in ath9k:
An interrupt is triggered just 4ms before the target beacon time
so that the chip can wake up and receive the beacons. In all the
latest chipsets like AR92XX, this is working fine.I wonder why
AR54XX has some problems related to that.
A quick look into the debug logs shows me that this wake up interrupt
(TIM_TIMER) stops triggering after some time which leads to beacon
loss and disconnection.
Although there is an option of autosleep(in latest versions) where hw can
wakeup automatically and receive beacon instead of a sw trigger call,
the hw may sleep for a longer duration(sometimes)  and we may need to
have some timer mechanism to verify if the hw is hung or not.
I did not have much time to look into this somewhat older chipsets and
I will try to debug more if I manage to get some free time.

Thanks
Vivek
