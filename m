Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46130 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab2GMNfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 09:35:32 -0400
Received: by eaak11 with SMTP id k11so1073062eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jul 2012 06:35:31 -0700 (PDT)
Message-ID: <5000241F.5050608@gmail.com> (sfid-20120713_153536_952107_AD987E52)
Date: Fri, 13 Jul 2012 15:35:27 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: lkml20120218@newton.leun.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: ath9k_htc: Issue with channel 52 and above (DFS?)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Leun wrote:

> ath9k_htc based card I see the same AP only if it operates on channel
> 36-48, I do NOT see it in iwlist scan results if it is on channel 52 to
> 140 - I again see it when it is on 149 or above.

This "Virgin Media" device, aka Netgear WNDA3200, is selling with a
world roaming regulatory domain = 0x65.

[ 1547.403743] ath: EEPROM regdomain: 0x65
[ 1547.403745] ath: EEPROM indicates we should expect a direct regpair map
[ 1547.403748] ath: Country alpha2 being used: 00
[ 1547.403750] ath: Regpair used: 0x65

And it's restricted *by the driver* to:

                 Frequencies:
                         * 5180 MHz [36] (30.0 dBm) (passive scanning, no IBSS)
                         * 5200 MHz [40] (30.0 dBm) (passive scanning, no IBSS)
                         * 5220 MHz [44] (30.0 dBm) (passive scanning, no IBSS)
                         * 5240 MHz [48] (30.0 dBm) (passive scanning, no IBSS)
                         * 5260 MHz [52] (30.0 dBm) (passive scanning, no IBSS, radar detection)
                         * 5280 MHz [56] (30.0 dBm) (passive scanning, no IBSS, radar detection)
                         * 5300 MHz [60] (30.0 dBm) (passive scanning, no IBSS, radar detection)
                         * 5320 MHz [64] (30.0 dBm) (passive scanning, no IBSS, radar detection)
                         * 5500 MHz [100] (disabled)
                         * 5520 MHz [104] (disabled)
                         * 5540 MHz [108] (disabled)
                         * 5560 MHz [112] (disabled)
                         * 5580 MHz [116] (disabled)
                         * 5600 MHz [120] (disabled)
                         * 5620 MHz [124] (disabled)
                         * 5640 MHz [128] (disabled)
                         * 5660 MHz [132] (disabled)
                         * 5680 MHz [136] (disabled)
                         * 5700 MHz [140] (disabled)
                         * 5745 MHz [149] (30.0 dBm) (passive scanning, no IBSS)
                         * 5765 MHz [153] (30.0 dBm) (passive scanning, no IBSS)
                         * 5785 MHz [157] (30.0 dBm) (passive scanning, no IBSS)
                         * 5805 MHz [161] (30.0 dBm) (passive scanning, no IBSS)
                         * 5825 MHz [165] (30.0 dBm) (passive scanning, no IBSS)
