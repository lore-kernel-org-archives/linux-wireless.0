Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36271 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1LYUu3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Dec 2011 15:50:29 -0500
Received: by eekc4 with SMTP id c4so10703612eek.19
        for <linux-wireless@vger.kernel.org>; Sun, 25 Dec 2011 12:50:28 -0800 (PST)
MIME-Version: 1.0
Reply-To: kay.smarczewski@googlemail.com
Date: Sun, 25 Dec 2011 21:50:28 +0100
Message-ID: <CA+Q4m4-7zJ+p6xtbC_O5iGVsUaX3FrdO2Q0-At4coeZSumUpMQ@mail.gmail.com> (sfid-20111225_215048_940025_B018345F)
Subject: AR5002G connected, but network unreachable
From: Kay Smarczewski <kay.smarczewski@googlemail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

sorry, if I use the false mailing list.

I have an Atheros wifi card in an Acer Aspire 5104 WLMI laptop. The lspci says:
06:02.0 Ethernet controller: Atheros Communications Inc. AR2413/AR2414
Wireless Network Adapter [AR5002G(S) 802.11bg] (rev 01)

I can connect to my wifi:
iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wlan0     IEEE 802.11bg  ESSID:"mynet"
          Mode:Managed  Frequency:2.437 GHz  Access Point: A1:A1:A1:A1:A1:A1
          Bit Rate=1 Mb/s   Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=70/70  Signal level=-31 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

but I am not able to get something out:
ping 192.168.0.1
connect: Network is unreachable

lsmod|grep ath says:
ath5k               129412  0
ath                   21370    1 ath5k
mac80211       183093  1 ath5k
cfg80211         132703  3 ath5k,ath,mac80211


If I comile an older version of the original madwifi driver for an 2.6
kernel everything will work fine. Newer versions give the same
behaviour like ath5k.
I have already tried rmmod and modprobe with the ath5k driver without success.

Other data of my system:
uname -a
Linux localhost.localdomain 3.1.0-1-amd64 #1 SMP Sun Dec 11 20:36:41
UTC 2011 x86_64 GNU/Linux
wireless-tools                       30~pre9-8

rfkill list wlan
0: acer-wireless: Wireless LAN
        Soft blocked: no
        Hard blocked: no
2: phy1: Wireless LAN
        Soft blocked: no
        Hard blocked: no


Do you have any ideas to get the card working again?


Best regards

Kay
