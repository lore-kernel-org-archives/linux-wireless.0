Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:36485 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082Ab2DBIyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 04:54:05 -0400
Received: by bkuw11 with SMTP id w11so2708743bku.37
        for <linux-wireless@vger.kernel.org>; Mon, 02 Apr 2012 01:54:02 -0700 (PDT)
Message-ID: <1333356840.16990.29.camel@cumari> (sfid-20120402_105408_891718_12FBB0A5)
Subject: Re: wl1271 NVS file loading
From: Luciano Coelho <coelho@ti.com>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 02 Apr 2012 11:54:00 +0300
In-Reply-To: <87pqbrj8nk.fsf@gmail.com>
References: <877gxz6n9i.fsf@gmail.com>
	User-Agent: Notmuch/0.12+70~g9ceacb2 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu) <87pqbrj8nk.fsf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,


On Sun, 2012-04-01 at 20:10 -0400, Ben Gamari wrote: 
> Ben Gamari <bgamari.foss@gmail.com> writes:
> > I'm running a PandaBoard with Linaro 12.03 and a patched 3.3
> > kernel. While wl1271 works perfectly with the Linaro kernel, it fails to
> > load in the case of my patched kernel with,
> >
> >      wl12xx: ERROR could not get nvs file ti-connectivity/wl1271-nvs.bin: -2
> >
> > What is even more perplexing is the fact that the file in question
> > clearly exists,
> >
> >         $ ls /lib/firmware/ti-connectivity/*-nvs.bin -l
> >         -rw-r--r-- 1 root root  912 2012-03-24 16:28 /lib/firmware/ti-connectivity/wl1271-nvs.bin
> >         -rw-r--r-- 1 root root  912 2012-03-24 16:28 /lib/firmware/ti-connectivity/wl127x-nvs.bin
> >         -rw-r--r-- 1 root root 1113 2012-03-24 16:28 /lib/firmware/ti-connectivity/wl128x-nvs.bin
> >         lrwxrwxrwx 1 root root   14 2012-01-24 13:10 /lib/firmware/ti-connectivity/wl12xx-nvs.bin -> wl127x-nvs.bin
> >
> > It seems that there is no easy way to troubleshoot udev's
> > /lib/udev/firmware script, so I have really no way of tracking this down
> > any further. Any ideas what might be going on here?
> >
> It turns out I had neglected to compile wl1271 as a module and the
> firmware hadn't made it into the initrd.  I apologize for the noise.

I'm glad you managed to work around this bug.  We need to fix this
according to some recent changes in the udev code.  The change should be
simple and we just need to wait until the firmware is available if we
try to load it and it's not ready yet.

This fix will be queued up for 3.5.

-- 
Cheers,
Luca.

