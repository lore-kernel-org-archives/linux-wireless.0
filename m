Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33749 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab1KSOUd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 09:20:33 -0500
Received: by iage36 with SMTP id e36so4950702iag.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 06:20:32 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 19 Nov 2011 22:20:30 +0800
Message-ID: <CAHW5WCL2V=wh43YYbiMo+rnh=-g4fobKEZHrCLvW03Q73=gzYA@mail.gmail.com> (sfid-20111119_152036_858107_D65FFE9C)
Subject: Wireless stalled after a few minutes with Linux Kernel 3.1
From: Haohui Liao <liaohaohui@gmail.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Linux wifi developers,

I am using ArchLinux with Linux kernel 3.0.7.  I find that sometimes
the wifi connection will suddenly just disconnect itself but it will
quickly resume.  Some said on the Internet that this is due to
surrounding interference, is this normal?

When I upgraded to Linux kernel 3.1, I have even worst experience, the
wifi will stall a few minutes after connection and only killing
wpa_supplicant and running it all over again will I be able to
reconnect to the wifi.  The following are my hardware and software
status:

oftware: Linux-3.1-4 & wpa_supplicant v0.7.3
Closely related but not the same problem (my system doesn't have have
the bcma as mentioned in the url):
https://bbs.archlinux.org/viewtopic.php?pid=1014217
Observation: No such network stall with linux-3.0.7-1.

I didn't encounter core dump problem with kernel 3.1. However, after
connecting for a few seconds or minutes, the connection with stall and
I can't assess Internet. I check my dmesg, it gave the following info:

[ 45.966602] wlan0: direct probe to f4:3f:61:06:22:21 (try 1/3)
[ 45.969213] wlan0: direct probe responded
[ 45.998789] wlan0: authenticate with f4:3f:61:06:22:21 (try 1)
[ 46.001234] wlan0: authenticated
[ 46.001270] wlan0: associate with f4:3f:61:06:22:21 (try 1)
[ 46.004102] wlan0: RX AssocResp from f4:3f:61:06:22:21 (capab=0x411
status=0 aid=1)
[ 46.004107] wlan0: associated
[ 93.007527] usb 1-1.3: USB disconnect, device number 3
[ 95.654157] NET: Registered protocol family 10
[ 106.263062] wlan0: no IPv6 routers present

Does this mean that the IPv6 in kernel 3.1 is affecting the wifi
connection?  Please advice.


Best Regards,
Liao Haohui
