Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lager.deltatee.com ([207.54.116.66]:53614 "EHLO
	porter.deltatee.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755452Ab0GZVkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 17:40:33 -0400
Message-ID: <4C4E00CE.5050105@deltatee.com>
Date: Mon, 26 Jul 2010 15:40:30 -0600
From: Logan Gunthorpe <logang@deltatee.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Luciano Coelho <luciano.coelho@nokia.com>,
	"Levi, Shahar" <shahar_levi@ti.com>
Subject: Re: wl1271 with atmel-mci
References: <4C488EEA.5020505@deltatee.com>
In-Reply-To: <4C488EEA.5020505@deltatee.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Everyone,


> I've had the wl1271 working for the most part on an Atmel 
> micro-controller, but I've been fighting with a bug for the past couple 
> of days.
> 
> The problem happens whenever I try to transmit large packets of data 
> (using iperf, or nc, etc) the driver would hang and no longer be able to 
> send packets. tx_queue_len in the debugfs would then grow as I tried to 
> send packets but nothing would actually be sent to the device. At the 
> same time receiving packets would consistently work all of the time.
> 
> When this occurred I usually got the following messages:
> 
> atmel_mci atmel_mci.0: data CRC error
> wl1271: ERROR sdio write failed (-84) - addr 0x14fd8, 1076 bytes, 1

Firstly, I'd like to let anyone who's interested know that the problem I 
had above turned out to be a hardware issue. I tried two newly populated 
boards which both turned out not to exhibit this problem. I now have the 
wl1271 working on two AT91SAM9G45-EKES development kits.

Using iperf I have gathered some performance data. I am seeing between a 
wl1271 device and a host PC (connected via a dlink router):

PC to Device: ~23.0Mbit/s
Device to PC: ~21.7Mbit/s

When running in Ad-Hoc mode between two devices I am getting between 
about 15Mbit/s and 17Mbit/s.

Does anyone have any insight as to why the Ad-Hoc mode between two 
devices is noticeably slower? Can anything be done to improve this?


Thanks,

Logan


