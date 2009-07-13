Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f185.google.com ([209.85.216.185]:35418 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZGMIGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 04:06:53 -0400
Received: by pxi15 with SMTP id 15so436494pxi.33
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 01:06:52 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 Jul 2009 15:59:32 +0800
Message-ID: <a7e4b4120907130059i30fd78a2r36aa645d8eb8f2f2@mail.gmail.com>
Subject: Problem of zd1211 firmware in the 2.6.23 kernel arm board
From: liu jianwei <ljw725@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear All,
 I am using zd1211rw in the linux 2.6.23 kernel in the S3C2410 arm
board, but now I have this firmware problem:

usb 1-2: Could not load firmware file zd1211/zd1211b_ub. Error number -2
zd1211rw 1-2:1.0: couldn't load firmware. Error number -2
ifconfig: SIOCSIFFLAGS: No such file or directory

I have tried udev
adding
 SUBSYSTEM=="firmware", ACTION=="add", RUN+="/lib/udev/firmware.sh"
to the  55-lfs.rules under "/etc/udev/rules.d/"
but this  55-lfs.rules did not exist originally, we copy it from the
udev website.
(It is copied to the bottom.)


but it doesn't work. And it seems the firmare.sh file was not excuted.
(because err "sth" in it does not print out)
Do anyone know how to fix this in the 2.6.23 version kernel. I saw
some one make it work very easily in the later version kernel like
2.6.28. but we can not use those versions.

Thanks for any reply and hint!

Best wishes,
Jianwei




#################################################33
# /etc/udev/rules.d/55-lfs.rules: Rule definitions for LFS.

# Core kernel devices

# override both of these
KERNEL=="random",   MODE="0444"
KERNEL=="urandom",  MODE="0444"

KERNEL=="aio",      MODE="0444"
KERNEL=="kmsg",     MODE="0600"
KERNEL=="rtc",      MODE="0666"

# Comms devices

KERNEL=="rfcomm[0-9]*",     GROUP="uucp"
KERNEL=="ippp[0-9]*",       GROUP="uucp"
KERNEL=="isdn[0-9]*",       GROUP="uucp"
KERNEL=="isdnctrl[0-9]*",   GROUP="uucp"
KERNEL=="capi",             NAME="capi20",  SYMLINK+="isdn/capi20"
KERNEL=="capi?*",           NAME="capi/%n", GROUP="uucp"
KERNEL=="dcbri[0-9]*",      GROUP="uucp"

# ALSA devices go in their own subdirectory

KERNEL=="controlC[0-9]*",        GROUP="audio",  NAME="snd/%k"
KERNEL=="hwC[0-9]*D[0-9]*",      GROUP="audio",  NAME="snd/%k"
KERNEL=="pcmC[0-9]*D[0-9]*[cp]", GROUP="audio",  NAME="snd/%k"
KERNEL=="midiC[0-9]*D[0-9]*",    GROUP="audio",  NAME="snd/%k"
KERNEL=="timer",                 GROUP="audio",  NAME="snd/%k"
KERNEL=="seq",                   GROUP="audio",  NAME="snd/%k"

# Sound devices

KERNEL=="admmidi*",     GROUP="audio"
KERNEL=="adsp*",        GROUP="audio"
KERNEL=="aload*",       GROUP="audio"
KERNEL=="amidi*",       GROUP="audio"
KERNEL=="amixer*",      GROUP="audio"
KERNEL=="audio*",       GROUP="audio"
KERNEL=="dmfm*",        GROUP="audio"
KERNEL=="dmmidi*",      GROUP="audio"
KERNEL=="dsp*",         GROUP="audio"
KERNEL=="midi*",        GROUP="audio"
KERNEL=="mixer*",       GROUP="audio"
KERNEL=="music",        GROUP="audio"
KERNEL=="sequencer*",   GROUP="audio"

# Input devices

# override MODE on these four
KERNEL=="mice",     MODE="0644",    SYMLINK+="mouse"
KERNEL=="mouse*",   MODE="0644"
KERNEL=="event*",   MODE="0644"
KERNEL=="ts*",      MODE="0644"

KERNEL=="psaux",    MODE="0644"
KERNEL=="js",       MODE="0644"
KERNEL=="djs",      MODE="0644"

# USB devices go in their own subdirectory

KERNEL=="hiddev*",          NAME="usb/%k"
KERNEL=="legousbtower*",    NAME="usb/%k"
KERNEL=="dabusb*",          NAME="usb/%k"
SUBSYSTEMS=="usb", KERNEL=="lp[0-9]*", NAME="usb/%k"
#SUBSYSTEMS=="firmware", ACTION="add",RUN+="/lib/udev/firmware.sh"

SUBSYSTEM=="firmware", ACTION="add",RUN+="firmware.agent"

# DRI devices are managed by the X server, so prevent udev from creating them

KERNEL=="card*",    OPTIONS+="ignore_device"

# Video devices

KERNEL=="fb[0-9]*",     GROUP="video"
KERNEL=="video[0-9]*",  GROUP="video"
KERNEL=="radio[0-9]*",  GROUP="video"
KERNEL=="vbi[0-9]*",    GROUP="video"
KERNEL=="vtx[0-9]*",    GROUP="video"

# DVB devices

SUBSYSTEM=="dvb", GROUP="video"

# Storage/memory devices

# override: make group-writable
SUBSYSTEM=="block", MODE="0660"

# dmsetup and lvm2 related programs create devicemapper devices so we prevent
# udev from creating them

KERNEL=="dm-*",             OPTIONS+="ignore_device"

# Tape devices

# override all these
KERNEL=="ht[0-9]*",     GROUP="tape"
KERNEL=="nht[0-9]*",    GROUP="tape"
KERNEL=="pt[0-9]*",     GROUP="tape"
KERNEL=="npt[0-9]*",    GROUP="tape"
KERNEL=="st[0-9]*",     GROUP="tape"
KERNEL=="nst[0-9]*",    GROUP="tape"

# Override floppy devices
KERNEL=="fd[0-9]",    GROUP="floppy"
KERNEL=="fd[0-9]", ACTION=="add", ATTRS{cmos}=="?*",
RUN+="create_floppy_devices -c -t $attr{cmos} -m %M -M 0660 -G floppy
$root/%k"
