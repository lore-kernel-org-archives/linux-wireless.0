Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:59397 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZEHOQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 10:16:45 -0400
Message-ID: <4A043EDC.4000307@shockfish.com>
Date: Fri, 08 May 2009 16:17:00 +0200
From: Alexandre Becholey <alexandre@shockfish.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [rt73usb] Master Mode almost done; problem with ARP
References: <4A03F67B.1000101@shockfish.com> <1241774214.1567.34.camel@johannes.local>
In-Reply-To: <1241774214.1567.34.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2009-05-08 at 11:08 +0200, Alexandre Becholey wrote:
>
>   
>> And what I can't do:
>> - Computers on the LAN can't ping the stations (Destination Host 
>> Unreachable)
>> - AP can't ping the stations
>>
>> I ran wireshark on a computer on the LAN, on the AP (here I used tcpdump 
>> on all interfaces because I don't have the possibility to have X) and on 
>> a stations. I would say that's a problem with ARP packets.
>>     
>
> Here's a similar bug -- the debugging I did there you should do here.
>
> http://bugzilla.kernel.org/show_bug.cgi?id=13237
>
> johannes
>   
I said something wrong: from any stations, I can't ssh the AP (it works 
only if from the station pings the AP during the ssh). I made a few 
other observations:

I start a ping from a LAN computer to a futur associated station (all IP 
are fix). When the station finished the association, the ping works for 
20 sec (it seems to correspond to the time an entry stays in the ARP 
table) and then Destination Host Unreachable.
As soon as I start a ping from the station to the LAN computer, the LAN 
computer's ping receive the responses, but when I stop the ping from the 
station, the LAN computer's ping don't receive the respond any more even 
if I stop it before 20sec are elapsed... I think it's more than just a 
problem with the ARP table.


I looked at the patch given in the bug you gave me, the ralink driver 
seems do the things correctly.

Alexandre
