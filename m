Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42390 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab2BMTSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 14:18:35 -0500
Received: by ghrr11 with SMTP id r11so2568437ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2012 11:18:34 -0800 (PST)
Message-ID: <4F3961FB.7020409@openwrt.org> (sfid-20120213_201839_276674_5FF7BFB5)
Date: Mon, 13 Feb 2012 20:18:19 +0100
From: Florian Fainelli <florian@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, gwingerde@gmail.com,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	Andreas Hartmann <andihartmann@freenet.de>
Subject: Re: Poor RT2880 performance
References: <4F390ED3.8010400@openwrt.org> <CAGXE3d90az_g3KyzPp-4NQoM2zmXaNSVo=7piM=q8EK9WdBp7A@mail.gmail.com>
In-Reply-To: <CAGXE3d90az_g3KyzPp-4NQoM2zmXaNSVo=7piM=q8EK9WdBp7A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 02/13/12 14:45, Helmut Schaa a écrit :
> Hi,
>
> On Mon, Feb 13, 2012 at 2:23 PM, Florian Fainelli<florian@openwrt.org>  wrote:
>> I am playing with a RT2880-F based AP, with a N connected station, in a
>> residential environment.
> Mind to provide the RF and RT chipset identifications? rt2x00 should print them
> out during module load (at least when compiled with debugging options).

Sure, here are the HW infos of the AP:
Ralink RT2880   id:1 rev:1 running at 266.66 MHz
phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 2860, rf: 0001, 
rev: 0101.

The station is an AR5418 ath9k card 2x2.

>
>> I could not get more than 26Mbits/sec TCP performance using iperf on both
>> sides,
> Did aggregation kick in? What rate was selected by the AP?

Does it print anything when it does? The station dump gives me:
Station 00:1d:7d:45:53:99 (on wlan0)
         inactive time:  12670 ms
         rx bytes:       44578225
         rx packets:     29117
         tx bytes:       1116274
         tx packets:     13560
         tx retries:     9148
         tx failed:      890
         signal:         -54 dBm
         signal avg:     -53 dBm
         tx bitrate:     117.0 MBit/s MCS 14
         rx bitrate:     130.0 MBit/s MCS 15
         authorized:     yes
         authenticated:  yes
         preamble:       short
         WMM/WME:        yes
         MFP:            no
         TDLS peer:      no

>
>> changing to a busier channel even made the performance drop down to
>> 5Mbits/sec, and remained like this.
> Andreas also reported some issues as soon as the environment gets noisy,
> not sure what the root cause for this is :(

The original firmware gives me roughly 75Mbits/sec in HT20 and 
89/Mbits/sec in HT40+. The CPU is 66% idle during the transfers.
--
Florian
