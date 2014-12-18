Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35032 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaLRQVG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 11:21:06 -0500
Received: by mail-ig0-f176.google.com with SMTP id l13so1212176iga.15
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 08:21:05 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 18 Dec 2014 17:21:05 +0100
Message-ID: <CAGXE3d8Uv01qjfvRQkMr1w_5wB6XKpC7d2VOR3UG0DMPHk6r9A@mail.gmail.com> (sfid-20141218_172138_179004_778AEDF0)
Subject: DFS CAC time
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Using ath10k I get the following when checking the CAC times for an
ETSI regulatory domain:

iw list | grep CAC -B 2
* 5260 MHz [52] (20.0 dBm) (radar detection)
  DFS state: available (for 342 sec)
  DFS CAC time: 60000 ms
* 5280 MHz [56] (20.0 dBm) (radar detection)
  DFS state: available (for 342 sec)
  DFS CAC time: 60000 ms
* 5300 MHz [60] (20.0 dBm) (radar detection)
  DFS state: available (for 342 sec)
  DFS CAC time: 60000 ms
* 5320 MHz [64] (20.0 dBm) (radar detection)
  DFS state: available (for 342 sec)
  DFS CAC time: 60000 ms
* 5500 MHz [100] (27.0 dBm) (radar detection)
  DFS state: usable (for 408 sec)
  DFS CAC time: 60000 ms
* 5520 MHz [104] (27.0 dBm) (radar detection)
  DFS state: usable (for 408 sec)
  DFS CAC time: 60000 ms
* 5540 MHz [108] (27.0 dBm) (radar detection)
  DFS state: usable (for 408 sec)
  DFS CAC time: 60000 ms
* 5560 MHz [112] (27.0 dBm) (radar detection)
  DFS state: usable (for 408 sec)
  DFS CAC time: 60000 ms
* 5580 MHz [116] (27.0 dBm) (radar detection)
  DFS state: usable (for 408 sec)
  DFS CAC time: 60000 ms
* 5600 MHz [120] (27.0 dBm) (radar detection)
  DFS state: usable (for 408 sec)
  DFS CAC time: 60000 ms
* 5620 MHz [124] (27.0 dBm) (radar detection)
  DFS state: usable (for 408 sec)
  DFS CAC time: 60000 ms
* 5640 MHz [128] (27.0 dBm) (radar detection)
  DFS state: usable (for 408 sec)
  DFS CAC time: 60000 ms
* 5660 MHz [132] (27.0 dBm) (radar detection)
  DFS state: usable (for 408 sec)
  DFS CAC time: 60000 ms
* 5680 MHz [136] (27.0 dBm) (radar detection)
  DFS state: usable (for 408 sec)
  DFS CAC time: 60000 ms
* 5700 MHz [140] (27.0 dBm) (radar detection)
  DFS state: usable (for 408 sec)
  DFS CAC time: 60000 ms

So, every channel has a CAC time of 60 seconds.

Checking version 1.7.2 of the ETSI regulation indicates that we might
need some modifications to cfg80211:

>From [1] page 79:

"NOTE 1: For channels whose nominal bandwidth falls completely or
partly within the
band 5 600 MHz to 5 650 MHz, the Channel Availability Check Time shall be
10 minutes.
NOTE 2: For channels whose nominal bandwidth falls completely or
partly within the
band 5 600 MHz to 5 650 MHz, the Off-Channel CAC Time shall be within the
range 1 hour to 24 hours."

So, for these channels we should select a longer initial CAC time.

Is anyone aware of this issue?

Thanks,
Helmut


[1] http://www.etsi.org/deliver/etsi_en/301800_301899/301893/01.07.02_20/en_301893v010702a.pdf
