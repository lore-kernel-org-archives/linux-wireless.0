Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from masada.superduper.net ([85.119.82.91]:48641 "EHLO
	masada.superduper.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3ECVqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 17:46:50 -0400
Message-ID: <51842836.8090601@superduper.net> (sfid-20130503_234653_881193_E37FBCD0)
Date: Fri, 03 May 2013 14:12:22 -0700
From: Simon Barber <simon@superduper.net>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>
CC: radiotap@NetBSD.org, johannes@sipsolutions.net,
	Adrian Chadd <adrian@freebsd.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Standardisation - adding 2 bit STBC and Ness to MCS
References: <518127ED.9060900@rempel-privat.de>
In-Reply-To: <518127ED.9060900@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I did post example code as attachments to the suggested-fields page a 
few months ago. Click on 'attachments' to view them. There are 3:

1. Intel wlan driver patch
2. Kernel patch
3. Wireshark patch.

Simon


On 05/01/2013 07:34 AM, Oleksij Rempel wrote:
> Hallo all,
>
>
>> http://www.radiotap.org/suggested-fields/MCS%20extension%20for%20STBC%20and%20Ness
>>
>>
>> I have posted 3 patches on the proposal page (see Attachments):
>>
>> 1. A patch that applies to the Linux kernel v3.7-rc1 to collect the new
>> STBC and Ness parameters from a wireless driver, and add them into the
>> MCS radiotap field.
>> 2. A patch to the Intel wireless driver in the kernel to collect STBC
>> and Ness information.
>> 3. A patch to wireshark to display STBC and Ness information.
>>
>> With this I believe we have everything needed to start the 3 week
>> comment period.
>
> There is a bit more then 3 week now. I would like to have this approved :)
> Are there any thing needed to finish this?
>
> Beside, i have one question about how STBC work. According to differnet
> docs, i assume that:
> - STBC is done by sending, at least, two stream with same data in
> different order.
> - It means for me, that real use of STBC can be made only on MIMO hardware.
> - If 1x1 receiver indicates that it got STBC encoded frame, it dos not
> meant, it would be able to use redundant data from second stream.
> - There are fallowing STBC schemes: Alamouti’s
> STBC for 2 transmit antennas and orthogonal STBC for 3 and 4 transmit
> antennas.
>
> According to this information, what do we call 1,2 or 3 stream STBC?
> Since STBC should have minimal 2 stream, but in same time we have 1x1
> and 2x2 hardware which able to receive and decode STBC stream i assume:
>      - RX-STBC1 is for compatibility only. No data redundancy.
>      - RX-STBC12 - can be used Alamouti’s schema with 2 streams. Mostly
> used method.
>      - RX-STBC123 - is orthogonal schema and not widely used method.
> Since last method use wide spectrum to transmit data comparable to SISO
> stream, it makes almost no sense. But 3-stream method get optimal error
> corect in compare with 2 and 4 strea schemas.
>
> Do this assumptions correct?
>
> PS: My assumptions based on "MIMO Space-Time Block Coding (STBC):
> Simulations and Results"
