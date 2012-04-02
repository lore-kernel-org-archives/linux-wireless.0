Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:55551 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2DBAK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2012 20:10:26 -0400
Received: by qafi31 with SMTP id i31so2246804qaf.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Apr 2012 17:10:25 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: wl1271 NVS file loading
In-Reply-To: <877gxz6n9i.fsf@gmail.com>
References: <877gxz6n9i.fsf@gmail.com>User-Agent: Notmuch/0.12+70~g9ceacb2 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sun, 01 Apr 2012 20:10:23 -0400
Message-ID: <87pqbrj8nk.fsf@gmail.com> (sfid-20120402_021029_290191_10DF7FD8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Gamari <bgamari.foss@gmail.com> writes:

> Hello all,
>
> I'm running a PandaBoard with Linaro 12.03 and a patched 3.3
> kernel. While wl1271 works perfectly with the Linaro kernel, it fails to
> load in the case of my patched kernel with,
>
>      wl12xx: ERROR could not get nvs file ti-connectivity/wl1271-nvs.bin: -2
>
> What is even more perplexing is the fact that the file in question
> clearly exists,
>
>         $ ls /lib/firmware/ti-connectivity/*-nvs.bin -l
>         -rw-r--r-- 1 root root  912 2012-03-24 16:28 /lib/firmware/ti-connectivity/wl1271-nvs.bin
>         -rw-r--r-- 1 root root  912 2012-03-24 16:28 /lib/firmware/ti-connectivity/wl127x-nvs.bin
>         -rw-r--r-- 1 root root 1113 2012-03-24 16:28 /lib/firmware/ti-connectivity/wl128x-nvs.bin
>         lrwxrwxrwx 1 root root   14 2012-01-24 13:10 /lib/firmware/ti-connectivity/wl12xx-nvs.bin -> wl127x-nvs.bin
>
> It seems that there is no easy way to troubleshoot udev's
> /lib/udev/firmware script, so I have really no way of tracking this down
> any further. Any ideas what might be going on here?
>
It turns out I had neglected to compile wl1271 as a module and the
firmware hadn't made it into the initrd.  I apologize for the noise.

Cheers,

- Ben

