Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33829 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960AbcC2U3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 16:29:21 -0400
Received: by mail-io0-f173.google.com with SMTP id e3so40407944ioa.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2016 13:29:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <342448442.1267207.1459225345803.JavaMail.yahoo@mail.yahoo.com>
References: <CAJ-VmokSovVud9yiUoHcCwp+fQv4rVMyAHLOVMau4Egpk3PGUQ@mail.gmail.com>
	<342448442.1267207.1459225345803.JavaMail.yahoo@mail.yahoo.com>
Date: Tue, 29 Mar 2016 13:29:20 -0700
Message-ID: <CAJ-VmomakNNn2oUQ+HfPrA=d5QXkAfnLixOBF5twX9yL3bRetA@mail.gmail.com> (sfid-20160329_222936_349371_5C05E76E)
Subject: Re: Bonjour mDNS broacast can be lost during BT-WLAN coexistence schemes?
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Ath9k-devel <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 March 2016 at 21:22, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
> Hello Adrian,
>       Thanks for your response. Currently with 2-wire coexistence, BT has
> higher priority when compared to WiFi. You had shared the following
> different bitfields that can be configured with different weights:
>
> WLAN:-
> wait_beacon | qcu_priority | rx_clear | wlan level
>
> BT:-
> bt_priority | bt freq | bt_tx_rx | bt_level
>
> I have the following queries, please help:
> 1.  wait_beacon:- WLAN client is waiting for a beacon from AP, this bit will
> be set. If the weights during this state is kept the highest, then even if
> BT wants to use the medium (BT_ACTIVE = 1), WLAN will always attempt to
> catch the beacon. Am I correct in my understanding?

Right. The idea is that the STA wants to hear a beacon, so if it's
important to do this ,you want to have WLAN stomp BT.

> 2. What happens if BT wants to transmit during this time when wait_beacon =
> TRUE; will the BT transmission be suppressed?

If you set the weight appropriately then yeah, WLAN stomps BT.

> 3. Regarding "bt_tx_rx". As I understand, bt_tx_rx = 1 when BT is
> transmitting and bt_tx_rx = 0 when BT is receiving; am I correct? How can BT
> module communicate if it will be transmitting or receiving to WLAN module?
> Because BT_PRIORITY will only indicate High or Low priority.

I thought bt_tx_rx is "bt is active", not "bt is tx'ing." I'd have to
check the PHY docs.

> 4. Currently the WLAN_ACTIVE line indicates only Tx activity from WLAN. Is
> there any way to indicate only Rx activities (E.g. Beacon reception etc) ?

On two/three-wire coex, no, I don't think so. The whole point is that
you just need to know "is the BT wanting to do stuff", "is the wlan
wanting to do stuff" and "who wins".
The wlan chip is the arbiter of who wins, it has the weights
programmed in to figure out what to do when.

> 5.  Regarding your comment on dynamically changing weights. AR9287 and the
> BT chipsets are separate and connected to a Host controller running linux.

> As for different states of BT, if there is a need for different weights, I
> do not think at runtime the weights can be changed (by sending a command
> from BT to Host and then weight change from Host to WLAN)as we might not be
> able to meet the short timings. WHat is your opinion on this?

No, the BT doesn't get to send the host commands like that. The driver
layer (ath9k) could be extended to include smarts about traffic
patterns and which BT profiles are active, so you can tune the weights
based on it.

The ath9k driver can also do things to "tune" how much of the channel
it uses - eg, by using the quiet time timers to control TX duty cycle
so BT has more of a chance to work.

The later chips (MCI?) implement a control protocol between the wlan
side and the bt side. I haven't yet ported that functionality to
freebsd so I don't have any operational experience with that!


-adrian
