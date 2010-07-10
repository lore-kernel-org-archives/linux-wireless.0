Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37996 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0GJScW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jul 2010 14:32:22 -0400
Received: by qyk38 with SMTP id 38so3695046qyk.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jul 2010 11:32:21 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 10 Jul 2010 19:32:20 +0100
Message-ID: <AANLkTilq_VFbOPHmMuf1EFmewc_WBBpgvW0t7ogZdbdl@mail.gmail.com>
Subject: Issues with ath9k dropping connectivity - now no connectivity
From: Norman Henderson <norm.audrey@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm a bit new to all of this - here's the short story. I would
appreciate any help available!

I was building a WAP using a PC Engines ALIX board (AMD Geode LX800),
DNMA92 wireless card (Atheros 92xx) and Voyage Linux (based on Debian
Lenny, 2.6.30 kernel with hostapd 0.6.9 and libnl1.1). It was all
working but, the wireless card would drop connectivity for no apparent
reason after an undetermined time (minutes to hours). Stations (Win or
cellphone) would no longer see it at all, as if it was no longer
transmitting.

The Voyage maintainer advised that ath9k isn't that stable at 2.6.30.
So, I upgraded the kernel to 2.6.32 using the Debian Lenny backport. I
then installed the "stable" compat-wireless, 2.6.32.16.

Hostapd appears to start OK. However, the wireless SSID is only
visible to the Windows clients for a short time - seconds/minutes -
and they aren't able to connect. There were no errors in the hostapd
startup and it does its key rotations periodically. All that's logged
from hostapd -dd during the actual time that the Win clients can see
it and are trying to connect is:
1278785975.350851: STA 00:13:02:be:7b:f9 sent probe request for broadcast SSID
1278785975.353034: MGMT (TX callback) ACK
1278785975.353073: mgmt::proberesp cb
(repeated a few times)

The Win7 station used to connect automatically but now doesn't and
when I click "connect" it fails and shortly thereafter the SSID
disappears from the list.

Nothing in /var/log. iw phy phy0 info and iw dev wlan0 info appear to
report sensible info as does iwconfig.

During boot I do get messages about "VIA Padlock Hash Engine not detected" and
modprobe: FATAL: Error inserting padlock_sha
(/lib/modules/2.6.32-bpo.5-686/kern...): No such device
>From googling it's not clear to me at least whether this is relevant.

Suggestions? What further diagnostics could I do?

Thanks,
Norm Henderson
