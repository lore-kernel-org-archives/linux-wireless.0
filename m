Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57784 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab1HJWsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 18:48:47 -0400
Received: by wyg24 with SMTP id 24so1045212wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 15:48:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6264DDFA6754194CAB6452BFF5202C330F5F2115@SXGM-401.fg.rbc.com>
References: <6264DDFA6754194CAB6452BFF5202C330F5F2115@SXGM-401.fg.rbc.com>
Date: Wed, 10 Aug 2011 18:48:45 -0400
Message-ID: <CAPoLzpe0OYq677NooOY5F7PyvbNobOXXCuSnoaF7ZVc0cJkjAw@mail.gmail.com> (sfid-20110811_004850_410391_43BBE076)
Subject: Fwd:
From: Pedram Navid <pedram.navid@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'd like to report a bug I have not been able to find elsewhere. I am on
a fresh Arch install with linux 3.0.1-1, using the brcmsmac module.
Initially, the wireless works for a few days. At some point, it will
stop, outputing the following error repeatedly:

Aug  7 09:55:27 localhost kernel: [  825.796697] ieee80211 phy0: wl0:
fifo 0: descriptor error
Aug  7 09:55:27 localhost kernel: [  825.796713] ieee80211 phy0: wl0:
fatal error, re-initializing

I can rmmod brcmsmac, reboot, shutdown, give it a few days, and start
over and it will sometimes work. Other times, it will persist with the
fifo errors. Please let me know you need additional log files. I had
this problem since 2.6.38 and reinstalled Arch twice, thinking it was
something with my setup that was done incorrectly but haven't been
able to figure it out. I can't find another case of this error on the
internet.

#    lspci -vnn | grep 14e4
05:00.0 Network controller [0280]: Broadcom Corporation
802.11b/g/n Wireless LAN Controller [14e4:4727] (rev 01)
       Subsystem: Broadcom Corporation Device [14e4:0510]

 #  lsmod  | grep brc
brcmsmac              594624  0
brcmutil                6563  1 brcmsmac
mac80211              215605  1 brcmsmac
cfg80211              160516  2 brcmsmac,mac80211
crc_ccitt               1331  1 brcmsmac

Thank you
Pedram
