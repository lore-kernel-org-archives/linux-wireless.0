Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62241 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2KKVal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 16:30:41 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so8158685iea.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 13:30:41 -0800 (PST)
MIME-Version: 1.0
From: Pedro Gs <simplew8@gmail.com>
Date: Sun, 11 Nov 2012 21:30:21 +0000
Message-ID: <CAKVccoWKaKAi8A0Yw_ffAX=VUFYc=QNyzB9bkZRTwDYgWFRNWA@mail.gmail.com> (sfid-20121111_223054_764999_48F78D81)
Subject: rtl8192ce stops working
To: Linux Wireless ML <linux-wireless@vger.kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

in the past i have reported that kernel wifi module rtl8192ce was
interfering with the keyboard and mouse, for example when writing
sometimes i got a letter repeated without pressing on it to have that
effect, the mouse moved alone.
To be able to have those keyboard and mouse behaviors i had to
disabled some module parameters, the ips and fwlps parameters.

Currently im running the distro Kubuntu which has kernel
3.5.0-17-generic #28-Ubuntu SMP, so i added into /etc/modprobe.d  the
file  rtl8192ce.conf which contains:

options rtl8192ce fwlps=0 ips=0

but what happens now is that the wifi module stops working properly,
passed sometime stops showing the wifi networks (only showing mine),
and to be able to have wifi networks (other than mine) i need to
reload the kernel wifi module rtl8192ce:
sudo rmmode rtl8192ce
sudo modprobe rto8192ce

and voila, i get again all wifi networks listed in network-manager.

If i stop changing the parameters values this doesn't happen anymore
but i get again the keyboard and mouse working badly as described
above.

Can i do anything to get this fixed?

regards,
Pedro
