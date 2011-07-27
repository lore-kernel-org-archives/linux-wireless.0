Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54476 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab1G0UZX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 16:25:23 -0400
Received: by qyk9 with SMTP id 9so1167862qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jul 2011 13:25:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL114-W2204F3FA55EF4C0D20D0C58A350@phx.gbl>
References: <COL114-W9CEFD4E7F3803005186F98A4F0@phx.gbl> <COL114-W76260EA23039CA8000DB88A320@phx.gbl>
 <CAB=NE6Wcn3-GwqPJQDXOT0JCNnZgCs1E7HecWrXpc8LS+XRyDA@mail.gmail.com>
 <201107262031.11394.chunkeey@googlemail.com> <CAB=NE6WoGZfpGnNkdaLdtN+nC+aM1mxV4rkUCMarnuDonQeJeg@mail.gmail.com>
 <COL114-W2204F3FA55EF4C0D20D0C58A350@phx.gbl>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 27 Jul 2011 13:18:57 -0700
Message-ID: <CAB=NE6WCagRUrMynd2CoAAN_LtoVkaoCYxOLE1COKx9zXgCBuQ@mail.gmail.com> (sfid-20110727_222527_206018_1A77E348)
Subject: Re: problem on ACS
To: MingAnn Ng <devil_eddie01@hotmail.com>,
	Felix Fietkau <nbd@openwrt.org>
Cc: chunkeey@googlemail.com,
	wireless testing <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 26, 2011 at 7:25 PM, MingAnn Ng <devil_eddie01@hotmail.com> wrote:
> Hi all,
>
> I had git the latest push by Luis, and make a quick test with it. the result
> is as below:
>
> 2412 MHz: 20.000000
> 2417 MHz: 7378697629483820665.500000
> 2422 MHz: 6456360425798343085.000000
> 2427 MHz: 7378697629483820668.000000
> 2432 MHz: 5534023222112865508.000000
> 2437 MHz: 922337203685477605.000000
> 2442 MHz: 4611686018427387922.500000
> 2447 MHz: 2767011611056432762.500000
> 2452 MHz: 2767011611056432763.250000
> 2457 MHz: 2767011611056432762.500000
> 2462 MHz: 3689348814741910340.000000
> 2467 MHz: 7378697629483820664.000000
> 2472 MHz: 8301034833169298245.500000
> 5180 MHz: 8.700000
> 5200 MHz: 9.900000
> 5220 MHz: 10.900000
> 5240 MHz: 10.500000
> 5260 MHz: 10.800000
> 5280 MHz: 12.000000
> 5300 MHz: 11.900000
> 5320 MHz: 10.900000
> 5500 MHz: 6.800000
> 5520 MHz: 8.000000
> 5540 MHz: 6.700000
> 5560 MHz: 6.800000
> 5580 MHz: 6.900000
> 5600 MHz: 2.100000
> 5620 MHz: 5.900000
> 5640 MHz: 6.000000
> 5660 MHz: 6.700000
> 5680 MHz: 6.900000
> 5700 MHz: 6.600000
> Ideal freq: 5600 MHz
>
> The result is more convincing than the previous version without any -inf
> values.

Yay but yeah those really high values are a bit strange, can you try
compiling ACS with VERBOSE=1, you can do this as follows:


export CFLAGS=-DVERBOSE=1
make V=1

You should see DVERBOSE=1 in the cc lines.

As for the output, you will now see verbose details of each survey,
stuff that into a file and inspect it and see why the values for the
interference factor are so high. For example I get:


   10 surveys for 5320 MHz:
Survey 1 from wlan0:
        noise:                          -112 dBm
        channel active time:            30 ms
        channel busy time:              6 ms
        channel receive time:           0 ms
        channel transmit time:          0 ms
        interference factor:            3.000000
Survey 2 from wlan0:
        noise:                          -112 dBm
        channel active time:            13 ms
        channel busy time:              6 ms
        channel receive time:           0 ms
        channel transmit time:          0 ms
        interference factor:            4.000000
Survey 3 from wlan0:
        noise:                          -112 dBm
        channel active time:            13 ms
        channel busy time:              6 ms
        channel receive time:           0 ms
        channel transmit time:          0 ms
        interference factor:            4.000000
... etc...

> The above survey is made by the radio channel set to 2412MHz.
> When I do a survey when I'd set the channel to 5180MHz, The result is shown
> below:
>
> 2412 MHz: 17.000000
> 2417 MHz: 17.300000
> 2422 MHz: 15.200000
> 2427 MHz: 17.500000
> 2432 MHz: 17.800000
> 2437 MHz: 16.700000
> 2442 MHz: 15.800000
> 2447 MHz: 14.000000
> 2452 MHz: 15.500000
> 2457 MHz: 14.200000
> 2462 MHz: 14.100000
> 2467 MHz: 12.500000
> 2472 MHz: 15.500000
> 5180 MHz: 7.900000
> 5200 MHz: 9223372036854775814.000000
> 5220 MHz: 9223372036854775814.000000
> 5240 MHz: 9223372036854775815.000000
> 5260 MHz: 9223372036854775814.000000
> 5280 MHz: 7378697629483820653.500000
> 5300 MHz: 8301034833169298234.500000
> 5320 MHz: 7378697629483820653.500000
> 5500 MHz: 9223372036854775810.000000
> 5520 MHz: 9223372036854775809.000000
> 5540 MHz: 9223372036854775811.000000
> 5560 MHz: 9223372036854775809.000000
> 5580 MHz: 9223372036854775811.000000
> 5600 MHz: 9223372036854775811.000000
> 5620 MHz: 9223372036854775810.000000
> 5640 MHz: 9223372036854775811.000000
> 5660 MHz: 9223372036854775810.000000
> 5680 MHz: 9223372036854775811.000000
> 5700 MHz: 9223372036854775810.000000
> Ideal freq: 5180 MHz
>
> the result for 5GHz band showing a much higher interference factor than the
> previous scan with channel set to 2412MHz, and the factor value for 2.4GHz
> is much lower.

Interesting -- the only explanation I have for this is the way the
driver does calibration when on a channel, and this being affected
somehow. More review of the actual survey details for each channel
would help here. Try to inspect it and see why the values are so big.
The different results based on what channel you are set should be
corrected, just not sure yet how. If we use a passive scan I wonder if
we'd get more consistent results -- likely not given that calibration
would depend on your currently operating channel...

> Is this a normal outcome since this is a off-channel survey?

Nope, for example, when I do the same thing you did, first with the
card set to 2412 MHz:

2412 MHz: 11.100000
2417 MHz: 10.100000
2422 MHz: 10.000000
2427 MHz: 9.800000
2432 MHz: 10.000000
2437 MHz: 10.100000
2442 MHz: 8.800000
2447 MHz: 10.200000
2452 MHz: 9.000000
2457 MHz: 10.000000
2462 MHz: 9.600000
5180 MHz: 1.800000
5200 MHz: 1.700000
5220 MHz: 2.700000
5240 MHz: 2.700000
5260 MHz: 2.800000
5280 MHz: 3.900000
5300 MHz: 2.600000
5320 MHz: 3.800000
5745 MHz: -3.000000
5765 MHz: 0.300000
5785 MHz: 0.800000
5805 MHz: -0.200000
5825 MHz: -1.500000
Ideal freq: 5745 MHz

And then if I tune it to 5745 MHz:


2412 MHz: 11.200000
2417 MHz: 9.900000
2422 MHz: 9.900000
2427 MHz: 9.600000
2432 MHz: 10.100000
2437 MHz: 10.100000
2442 MHz: 9.000000
2447 MHz: 9.800000
2452 MHz: 8.900000
2457 MHz: 10.000000
2462 MHz: 10.000000
5180 MHz: 1.800000
5200 MHz: 1.900000
5220 MHz: 2.900000
5240 MHz: 2.800000
5260 MHz: 2.700000
5280 MHz: 3.600000
5300 MHz: 2.600000
5320 MHz: 3.800000
5745 MHz: -3.000000
5765 MHz: 0.800000
5785 MHz: 0.700000
5805 MHz: 0.800000
5825 MHz: -1.100000
Ideal freq: 5745 MHz

What 802.11 card do you have (dmesg | grep ath; and lspci output) ? I
have an AR9280. I also know Felix has been telling me he has some
enhancements to noise floor computation in his queue for ath9k, these
might help here too.

  Luis
