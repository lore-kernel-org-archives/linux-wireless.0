Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:46424 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3GGClf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jul 2013 22:41:35 -0400
Received: by mail-ob0-f180.google.com with SMTP id eh20so4296116obb.11
        for <linux-wireless@vger.kernel.org>; Sat, 06 Jul 2013 19:41:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKb7UvjVyZuOjuD3oFT_jxx5T=DNamHA_YiV_yGWcmePHHd-UQ@mail.gmail.com>
References: <CAKb7UvjVyZuOjuD3oFT_jxx5T=DNamHA_YiV_yGWcmePHHd-UQ@mail.gmail.com>
Date: Sat, 6 Jul 2013 22:41:34 -0400
Message-ID: <CAKb7UvgmokDWtst3pq=FjO9tbCkykMZREPLVtxRYnE_awT74-A@mail.gmail.com> (sfid-20130707_044152_514279_64E41762)
Subject: Re: Constant network assoc/disassoc loop with rtl8192cu usb adapter
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 4, 2013 at 1:35 AM, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
> Hello,
>
> I recently got a RTL8188CUS usb adapter (which uses the rtl8192cu
> driver). I'm having trouble getting it to stay associated:
>
> [601369.845916] wlan0: associated
> [601377.106440] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try
> to reconnect now
> [601383.867706] wlan0: associated
> [601391.120270] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try
> to reconnect now
> [601397.910678] wlan0: associated
> [601405.141764] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try
> to reconnect now
>
> and so on. A different usb adapter (Ralink RT2573) has no trouble
> associating to that AP (but it keeps hanging and the kernel isn't
> always able to reset it properly). The network in question is using
> WPA2-PSK.
>
> Is there some setting I could adjust so that it would wait longer
> before deciding that the AP is off? Or something else I can do?
>
> This is on a 3.10-rc6 kernel + the __queue_work warning fix patch at
> https://git.kernel.org/cgit/linux/kernel/git/linville/wireless-testing.git/patch/?id=1621c9466099faf21ad19738d54a7d1845a29b32.

In addition to the messages above, I also occasionally saw sequences of 3-6

rtlwifi:addbareq_rx():<100-1> sta is NULL

messages after an association timeout.

Here are a few things I tried:

(a) increasing the timeout to 20 seconds, from 6. Didn't help.
(b) printing each beacon frame (in rtl_beacon_statistic). This showed
some potentially interesting results... right after association, I see
beacons from various APs (including the right one). But after about 1
second, all the other APs die out, and I only see beacons from 2
related APs (foo and foo-guest, with nearly identical bssid's),
neither of which is the one I want. I think that they're stronger than
the AP I'm trying to connect to. Sometimes the "right" AP's beacons
come back, sometimes not.
(c) Realtek's driver (rtl8188C_8192C_usb_linux_v3.4.4_4749.20121105).
Eventually I got it to compile. It links just fine to the AP, no
wifi-related problems. (The driver hung the system on usb removal, but
that seems more related to poor coding.) So the AP isn't too far away,
and it's not a situation where there's too much noise for the hardware
to handle. Running a ping shows that there aren't any significant
connection drops.

Let me know if there are other things you think I should try. Happy to
test any patches/provide info.

  -ilia
