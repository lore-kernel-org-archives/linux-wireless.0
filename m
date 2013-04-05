Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44544 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162778Ab3DEWgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 18:36:25 -0400
Received: by mail-wi0-f174.google.com with SMTP id hj8so1041535wib.7
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2013 15:36:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=uvZbUtKE5Pk=saipVLRfmrU6jQeEvCg2kULP6F+d6cg@mail.gmail.com>
References: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com>
	<515A0847.7000306@gmail.com>
	<1365088789.89181.YahooMailNeo@web193504.mail.sg3.yahoo.com>
	<CAJ-VmoksRR8Xd4wEM_obENyP1mFqbgKDm+DEjLS=W8WAPBPLRg@mail.gmail.com>
	<1365131280.68622.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<CAJ-VmokqjXqkJEN1cwgsOcJ7p8cvCsRxUG8Qc9gE8fWXaq+E0g@mail.gmail.com>
	<1365148844.61162.YahooMailNeo@web193503.mail.sg3.yahoo.com>
	<CAJ-VmonhbW06GU30S9oKYTEvbum2WbY63Y07tvS=ZQJcB6o+Dg@mail.gmail.com>
	<1365152761.13005.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<20830.46610.23754.783231@gargle.gargle.HOWL>
	<1365175482.75704.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<CAJ-VmomFi1fq6GY2dCpJCGN-sfmaH+FEu0V1nCjc7MymT6f3Rg@mail.gmail.com>
	<CAJ-Vmo=uvZbUtKE5Pk=saipVLRfmrU6jQeEvCg2kULP6F+d6cg@mail.gmail.com>
Date: Fri, 5 Apr 2013 15:36:24 -0700
Message-ID: <CAJ-VmomYF3ziqhykXMK5U+SJPYiNWmijdf0VhKDK33BVbSKNrQ@mail.gmail.com> (sfid-20130406_003636_645106_A26BCD17)
Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Right.

So the weight table for Kite/Kiwi:

wait_beacon | qcu_priority | rx_clear | wlan level
0 | 0 | 0 | wlan_weight[0:1]
0 | 0 | 1 | wlan_weight[3:2]
0 | 1 | 0 | wlan_weight[5:4]
0 | 1 | 1 | wlan_weight[7:6]
1 | 0 | 0 | wlan_weight[9:8]
1 | 0 | 1 | wlan_weight[11:10]
1 | 1 | 0 | wlan_weight[13:12]
1 | 1 | 1 | wlan_weight[15:14]

bt_priority | bt freq | bt_tx_rx | bt_level
0 | 0 | 0 | bt_weight[0:1]
0 | 0 | 1 | bt_weight[3:2]
0 | 1 | 0 | bt_weight[5:4]
0 | 1 | 1 | bt_weight[7:6]
1 | 0 | 0 | bt_weight[9:8]
1 | 0 | 1 | bt_weight[11:10]
1 | 1 | 0 | bt_weight[13:12]
1 | 1 | 1 | bt_weight[15:14]

wait_beacon is whether we're waiting for a beacon in STA mode. No idea
how this works in hostap mode, but see below.
qcu_priority is whether it's a low or high queue priority.  Any queue
above the "queue threshold" value in one of the BT config registers
(see the source) is a high priority queue and is 1 here.
rx_clear is whether we're busy

bt_priority - the bt priority line
bt_freq - no idea
bt_tx_rx - whether the BT module is transmitting (3 wire only I guess,
irrelevant for 2 wire)

I hope that's enough to get started on what you're trying to achieve.
Please share your results!



Adrian
