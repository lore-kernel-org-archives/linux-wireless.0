Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60818 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285Ab2EOU2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 16:28:06 -0400
Received: by gglu4 with SMTP id u4so10281ggl.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 13:28:05 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 15 May 2012 13:28:04 -0700
Message-ID: <CAOcc+SB7Tr_AAAB4aQK_-8MWhKo7NQuap65FLd8omuou6XFctQ@mail.gmail.com> (sfid-20120515_222811_880072_F35515FE)
Subject: Significant amount of packet loss observed after creating second
 virtual interface on ath9k
From: Chih-Chieh Chou <ccchou@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

  I ran into a weird issue that I couldn't find any answers on the
Internet. My aim is to setup a wireless hotspot, sharing my existing
internet connection on the same single wireless interface card. The
following shows the step of doing it.

    iw phy phy0 interface add wlan1 type __ap
    iw phy phy0 interface add wlan2 type station

    ifconfig wlan1 hw ether 52:54:00:11:22:33
    ifconfig wlan1 192.168.77.1 netmask 255.255.255.0 up

    dnsmasq -C dnsmasq.conf    # start dnsmasq
    hostapd -d hostapd.conf -B   # start hostapd
    wpa_supplicant -i wlan2 -c wpa_supplicant.conf -B

    echo 1 > /proc/sys/net/ipv4/ip_forward
    # NAT rules
    iptables --table nat --append POSTROUTING --out-interface new0 -j MASQUERADE

  When I use a laptop connecting to the network broadcast by the
hotspot, there's no problem with it. I got an IP address assigned and
can ping the access point, here 192.168.77.1. However, I observed
significant amount of packet loss during pinging (I used ping -t
192.168.77.1). I also found that if I create only one virtual
interface on ath9k, it works pretty well (no packet loss from ping).
If I create one more virtual interface, there's about 10% packet loss
and 40% packet loss right after starting wpa_supplicant. Could anyone
have good insight to this issue?

Thanks and Best Regards,
C.C
