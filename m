Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:50629 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYAZLf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 06:35:57 -0500
Received: by ug-out-1314.google.com with SMTP id z38so661974ugc.16
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2008 03:35:56 -0800 (PST)
Message-ID: <549e645c0801260335t56e18e75l6dd2c58b47e0257b@mail.gmail.com> (sfid-20080126_113602_073693_EB5B8C1A)
Date: Sat, 26 Jan 2008 12:35:56 +0100
From: "Henning Habighorst" <h.habighorst@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Questions regarding the rtl8180 driver (compared to zd1211rw driver)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I've tried to use the rtl8180 driver some time, but as it crashed
longer time ago more than often and I didn't get a successful
connection (only after a reboot) and the connection wasn't very
stable, I switched to the zd1211rw driver, which is much faster.

I notice a total different behaviour between those two drivers : With
the rtl8180 driver, I have a very weak signal level (usually around 20
%) and the bit rate and TX Power seems hard coded to me (I'm a very
basic developer... I've got really no clue what you guys are doing!)
The link quality is not shown too.

If I'm using zd1211rw it's totally different : The signal level is
changing... It has no "usual" level, but on traffic the signal level
gets higher ( What it should be like ... I guess?!) And the bit rate
is changing too (what makes sense in my opinion when signal level is
changing)...

As I am not sure what information you'll need or if this is a "known"
problem I would be happy for an answer, if I could help and if , how
;)

Henning

--> using latest compat-wireless Tarball (2.8-16-gec1eb52) and Linux
2.6.24 on an AMD 64 X2 Windsor CPU....

( Output of iwconfig :

RTL8180 :
wlan1     IEEE 802.11g  ESSID:"BlackIce"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:13:49:B9:25:30
          Bit Rate=48 Mb/s   Tx-Power=27 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption
key:------------------------------------------------------------
          Link Signal level=13/65
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

ZD1211RW (no traffic)
wlan0     IEEE 802.11g  ESSID:"BlackIce"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:13:49:B9:25:30
          Bit Rate=5.5 Mb/s   Tx-Power=0 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key:
-----------------------------------------------------------
          Link Quality=100/100  Signal level=30/100
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

ZD1211RW (some traffic)
wlan0     IEEE 802.11g  ESSID:"BlackIce"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:13:49:B9:25:30
          Bit Rate=24 Mb/s   Tx-Power=0 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption
key:---------------------------------------------------------------
          Link Quality=100/100  Signal level=32/100
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
)

Output of lsusb/  lspci :
Bus 002 Device 004: ID 0ace:1215 ZyDAS WLA-54L WiFi
01:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8185
IEEE 802.11a/b/g Wireless LAN Controller (rev 20)
