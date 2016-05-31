Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35786 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbcEaSAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 14:00:08 -0400
Received: by mail-wm0-f54.google.com with SMTP id a136so145192228wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2016 11:00:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <wrfjwpmagtgd.fsf@redhat.com>
References: <1463594249-19524-1-git-send-email-dlenski@gmail.com>
 <wrfjinyayf2i.fsf@redhat.com> <wrfjwpmagtgd.fsf@redhat.com>
From: Daniel Lenski <dlenski@gmail.com>
Date: Tue, 31 May 2016 10:59:27 -0700
Message-ID: <CAOw_LSEHTM47ro=W_DBWSpX1SJ9YR+EvJQ+6qja-XvHH1JToiQ@mail.gmail.com> (sfid-20160531_200013_038658_4CA8588F)
Subject: Re: [PATCH] rtl8xxxu: increase polling timeout for firmware startup
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 31, 2016 at 8:04 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Given your follow-on discoveries, do you still want me to apply the poll
> timeout patch, or should we wait until we nail down the reset code issue
> first?

No, I don't think the timeout patch is worth appying. I believe it
was just dumb luck that it worked when I initially tested it,
because I did not understand how to reproducibly generate the
incomplete-reset condition then.

One the other hand, the power-cycle-and-retry approach has been 100%
reliable for me. It has never failed to bring up the device in the
last 8-10 days and probably a few dozen reboots.

The patch for this could be applied as-is and I expect it will fix the
issue for other users who've reported it, though I understand that
you're interested in identifying the root cause issue with the reset
sequence as well.

-Dan

ps- Just checked my dmesg. Sure enough, worked on the second try today too:

[    7.802484] usb 1-1.4: RTL8723AU rev B (TSMC) 1T1R, TX queues 2,
WiFi=1, BT=1, GPS=0, HI PA=0
[    7.802485] usb 1-1.4: RTL8723AU MAC: 20:16:d8:ce:5e:29
[    7.802487] usb 1-1.4: rtl8xxxu: Loading firmware
rtlwifi/rtl8723aufw_B_NoBT.bin
[    7.820331] usb 1-1.4: Firmware revision 31.0 (signature 0x2302)
[    7.913493] usb 1-1.4: Firmware checksum poll completed after 0 loops
[    9.381455] usb 1-1.4: Firmware failed to start after 5000 loops
[    9.381460] usb 1-1.4: Failed to init device, will retry 5 more times.
[    9.969912] usb 1-1.4: Firmware checksum poll completed after 0 loops
[    9.976034] usb 1-1.4: Firmware started after 23 loops
[   10.417327] usb 1-1.4: Enabling HT_20_40 on the 2.4GHz band
