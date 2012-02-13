Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:58226 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab2BMPHk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 10:07:40 -0500
Message-ID: <4F3926AD.3020405@01019freenet.de> (sfid-20120213_160743_951984_0BC2889E)
Date: Mon, 13 Feb 2012 16:05:17 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Florian Fainelli <florian@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, gwingerde@gmail.com,
	Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: Poor RT2880 performance
References: <4F390ED3.8010400@openwrt.org> <CAGXE3d90az_g3KyzPp-4NQoM2zmXaNSVo=7piM=q8EK9WdBp7A@mail.gmail.com>
In-Reply-To: <CAGXE3d90az_g3KyzPp-4NQoM2zmXaNSVo=7piM=q8EK9WdBp7A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa schrieb:
> Hi,
> 
> On Mon, Feb 13, 2012 at 2:23 PM, Florian Fainelli <florian@openwrt.org> wrote:
>> I am playing with a RT2880-F based AP, with a N connected station, in a
>> residential environment.
> 
> Mind to provide the RF and RT chipset identifications? rt2x00 should print them
> out during module load (at least when compiled with debugging options).
> 
>> I could not get more than 26Mbits/sec TCP performance using iperf on both
>> sides,

Just for my understanding: did you test iperf payload in both directions
parallel or serial?

What about the hardware of the STA?

> Did aggregation kick in? What rate was selected by the AP?

I set the 80211.n options like this in hostapd.conf:

ieee80211n=1
ht_capab=[HT40+][SHORT-GI-40][SHORT-GI-20][TX-STBC1][MAX-AMSDU-3839][RX-STBC12][SMPS-STATIC][GF]

It's vitally to enable 40MHz channels, above [HT40+].

But you should put your own values into the config. You get them from iw
list of the AP interface.

> 
>> changing to a busier channel even made the performance drop down to
>> 5Mbits/sec, and remained like this.
> 
> Andreas also reported some issues as soon as the environment gets noisy,
> not sure what the root cause for this is :(

Yes, the issues I saw came up with nl80211 based STA interface running
parallel to a ralink legacy driver based interface (the payload from
ath9k interface was practically knocked out (DOS-attack :-)) - the
ralink legacy driver based STA sent on briskly).


Kind regards,
Andreas
