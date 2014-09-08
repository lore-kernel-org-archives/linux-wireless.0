Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56823 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbaIHQa0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 12:30:26 -0400
Received: by mail-we0-f174.google.com with SMTP id t60so1385781wes.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2014 09:30:24 -0700 (PDT)
Message-ID: <1410193824.10388.24.camel@umadbro> (sfid-20140908_183028_805767_E04AFCC8)
Subject: 802.11p rate control
From: Rostislav Lisovy <lisovy@gmail.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: burak.simsek@volkswagen.de, s.sander@nordsys.de,
	sojkam1@fel.cvut.cz, jan-niklas.meier@volkswagen.de,
	emmanuel.thierry@yogoko.fr, thierry.ernst@yogoko.fr,
	oyunaash@gmail.com, laszlo.virag@commsignia.com
Date: Mon, 08 Sep 2014 18:30:24 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear 802.11 experts;
Short introduction before the actual question:
Some of you have probably noticed my effort of bringing the 802.11p
support for the mainline Linux kernel. (Side note: I know that "802.11p"
is already part of the IEEE 802.11-2012 but calling it ".11p" makes it
easier to determine what am I actually talking about).
My main focus is on the ITS-G5 (ETSI EN 302 663 [1], ETSI TS 102 687
[2]), European car-to-x communication standard based on 802.11p. For
those who are further interested, my work might be found at
https://github.com/CTU-IIG/802.11p-linux/tree/its-g5_devel 

Back to the main purpose of this email. I am still unsure how to
implement the rate-control handling for the 802.11p. The indisputable
fact is that the mandatory rates each 802.11p compliant device has to
support are 3, 6, 12 Mbit/s (IEEE 802.11-2012 18.1.1) since we are using
the OFDM 10MHz channels (other OFDM datarates might be used as well).
The decision which datarate to use for TX should be done by some kind of
algorithm, probably running in the kernel. The question is how to do so
in a clean way.

The possible obstacles are:
* 802.11p will be used mainly for two independent C2X protocol stacks --
one is the European ETSI ITS-G5, the other one is the US WAVE (IEEE
1609). I assume that these two protocol stack implementations will
differ mainly in the user-space while the kernel part will be the same.
* ITS-G5 already speaks about the "default datarate" for different
channels ([1] 4.3, Table 2) -- i.e. 6 Mbit/s for channel no. 180; 12
Mbit/s for channel no. 178. This should be probably defined when
"joining the network" on a fixed channel.

The possible (first implementation) solution might be either to
implement some "dummy" rate control algorithm that will set a fixed
datarate only once (during "ocb join" command) or to use the Minstrel
while limiting the allowed datarate to be the lowest one; i.e.
    mand_rates = ieee80211_mandatory_rates(sband, scan_width);
    sta->sta.supp_rates[band] =
        find_first_bit(&mand_rates, sizeof(u32));

If I am not mistaken, it is not possible to live without an in-kernel
rate_control algorithm?
One interesting idea I got from one colleague is to implement the
algorithm logic in the user-space -- kernel would contain just a thin
shell controlled from the user-space (via netlink?). This is probably
not as insane as it may sound since the purpose of the rate-control
algorithm for 802.11p (at least for ITS-G5) is not to "maximize the
immediate throughput" but more like "shared medium congestion control",
which may require much slower frequency of a control loop.

I will appreciate your comments. 

Best regards;
Rostislav Lisovy

[1] http://www.etsi.org/deliver/etsi_en/302600_302699/302663/01.02.01_60/en_302663v010201p.pdf
[2] http://www.etsi.org/deliver/etsi_ts/102600_102699/102687/01.01.01_60/ts_102687v010101p.pdf


