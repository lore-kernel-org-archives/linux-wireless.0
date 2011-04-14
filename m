Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34455 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab1DNJec convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 05:34:32 -0400
Received: by qwk3 with SMTP id 3so770271qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 02:34:31 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <BANLkTimnQ92mgOzXMWXuF54tUs+M1ZbR1A@mail.gmail.com>
References: <BANLkTimnQ92mgOzXMWXuF54tUs+M1ZbR1A@mail.gmail.com>
Date: Thu, 14 Apr 2011 11:34:31 +0200
Message-ID: <BANLkTin9KAQtYg0qWOPxw2HVq4MeXdhY3Q@mail.gmail.com>
Subject: Re: iwlagn / wpa_supplicant issue
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for the top-post:

Not sure if I have the same problem like you.
I was not lucky with the wpasupplicant (0.7.3-X) packaged in
Debian/sid, I downgraded to (0.6.10-2.1).

IIRC last time I investigated the issue:
Replacing /etc/wpa_supplicant/functions.sh file from 0.7.x package
with the one from 0.6.x helped.
So... it could be a packaging problem?

( BTW, I am running systemd and resolvconf package and using a /e/n/i
with static-IPADDR setup, might be related to them, too. Busy with
other stuff and need a stable "working" Internet connection. And NO, I
did not write a bug-report. )

- Sedat -

On Thu, Apr 14, 2011 at 11:15 AM, Fabio Coatti <fabio.coatti@gmail.com> wrote:
> Hi all,
> sorry for crossposting but I'm not sure where the problem, if any,
> could possibly be.
>
> Basically, I'm facing a weird issue with wpa_supplicant 0.7.3 / 0.8
> snapshot compiled 06/04/2011 , here the
> description and the environment:
>
> wpa supplicant 0.7.3 (gentoo package wpa_supplicant-0.7.3-r1)
> linux 2.6.36.1
>
> Tested also with wpa_supplicant 0.8 snapshot and kernels 2.6.37 - 2.6.38.2
> hardware: HP elitebook 8440p
> iwlagn 0000:44:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
> iwlagn 0000:44:00.0: loaded firmware version 9.221.4.1 build 25532
>
> Description:
> basically, when wpa_supplicant starts it is unable to speak with hardware, no
> commands have effect (i.e. scan) and the only message I get is the
> usual
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
>
> (of course rfkill is off)
>
> the scan window (wpa_gui) or scan result (wpa_cli) is empty, no matter
> how many scans I request.
>
> but if I issue a
>
> iwlist wlan0 scan
>
> I get all networks active in my area and after some second all
> networks appears on wpa_gui and suddenly wpa_supplicant completes the
> authentication and I'm able to get the ip address.
>
> I don't know if the problem is wpa not issuing the right commands or
> drivers/kernel acting in a strange way or something else, my knowledge
> on this is really low.
>
> I've tried to debug this issue without success and also googling
> didn't helped me; I will be grateful if someone gives me some hint, at
> least where to look; of course I'm available to do any test/debug that
> could be needed.
>
> Thanks,
>
>
> --
> Fabio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
