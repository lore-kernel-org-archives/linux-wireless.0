Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44744 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab1DNJPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 05:15:14 -0400
Received: by wya21 with SMTP id 21so1203734wya.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 02:15:12 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 Apr 2011 11:15:12 +0200
Message-ID: <BANLkTimnQ92mgOzXMWXuF54tUs+M1ZbR1A@mail.gmail.com>
Subject: iwlagn / wpa_supplicant issue
From: Fabio Coatti <fabio.coatti@gmail.com>
To: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
sorry for crossposting but I'm not sure where the problem, if any,
could possibly be.

Basically, I'm facing a weird issue with wpa_supplicant 0.7.3 / 0.8
snapshot compiled 06/04/2011 , here the
description and the environment:

wpa supplicant 0.7.3 (gentoo package wpa_supplicant-0.7.3-r1)
linux 2.6.36.1

Tested also with wpa_supplicant 0.8 snapshot and kernels 2.6.37 - 2.6.38.2
hardware: HP elitebook 8440p
iwlagn 0000:44:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
iwlagn 0000:44:00.0: loaded firmware version 9.221.4.1 build 25532

Description:
basically, when wpa_supplicant starts it is unable to speak with hardware, no
commands have effect (i.e. scan) and the only message I get is the
usual
ADDRCONF(NETDEV_UP): wlan0: link is not ready

(of course rfkill is off)

the scan window (wpa_gui) or scan result (wpa_cli) is empty, no matter
how many scans I request.

but if I issue a

iwlist wlan0 scan

I get all networks active in my area and after some second all
networks appears on wpa_gui and suddenly wpa_supplicant completes the
authentication and I'm able to get the ip address.

I don't know if the problem is wpa not issuing the right commands or
drivers/kernel acting in a strange way or something else, my knowledge
on this is really low.

I've tried to debug this issue without success and also googling
didn't helped me; I will be grateful if someone gives me some hint, at
least where to look; of course I'm available to do any test/debug that
could be needed.

Thanks,


-- 
Fabio
