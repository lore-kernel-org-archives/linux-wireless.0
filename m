Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:38828 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbZGML5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 07:57:25 -0400
Received: by qyk30 with SMTP id 30so597817qyk.33
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 04:57:23 -0700 (PDT)
Message-ID: <4A5B211D.3040905@gmail.com>
Date: Mon, 13 Jul 2009 07:57:17 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Tim Schneider <schneid5@cs.uni-bonn.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Reading the RSSI from a Kernel Module
References: <0D620DB9-0DF4-41BB-8686-5BC910F88C79@cs.uni-bonn.de> <4A5ADB52.3080401@gmail.com> <2E605895-C629-47C5-8DF8-DF012A3749EB@cs.uni-bonn.de>
In-Reply-To: <2E605895-C629-47C5-8DF8-DF012A3749EB@cs.uni-bonn.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Schneider wrote:
>
> Am 13.07.2009 um 08:59 schrieb Richard Farina:
>> I don't mean to make this a flame so please do not take it that way.  
>> How exactly do you expect to get the RECEIVED Signal Strength 
>> indication for a packet which you are SENDING? If you send it, you 
>> don't receive it...
>>
>> Just my 0.02
>>
>> -Rick Farina
>
> Hi Rick,
>
> as far, as I understood, the RSSI-Mechanism also displays the signal 
> strength of the just sent package. I figured there was some way the 
> MAC-Layer transported that information, but you're right, I could be 
> mistaken. Anyways, since I'm trying to implement a TCP Algorithm, i 
> definitely have a  two-way connection. Assuming, that the route back 
> is going to be the same as it was on the way there (which basically 
> should be true, based on the Routing algorithms we're using in our 
> wireless mesh network), I could just use the RSSI Value of the 
> received ACK.
>
Any RSSI on a sent packet will be a calculated number not an observed 
number and as such it will be completely pointless for any kind of rate 
control algorithm.  Assuming that the card could actually receive the 
packets it is sending (which it can't) then you would be observing a 
24dBm signal (for instance) with 0 patch loss and your RSSI would be at 
or above max.  Realistically you can assume that every packet you sent 
has a max RSSI on your end because you are the one transmitting it.  
Now, if you want to know what the RSSI on the receiver side is that is a 
completely different question, one which you cannot answer at all. When 
you send a packet you do not have the good fortune to know what RSSI the 
receiver got.  You can roughly assume based on your RSSI when you get an 
ACK, but honestly that isn't even close to correct because every packet 
has a very unique experience in the air and you cannot assume things 
like the same tx power and rx sensitivity will be the same on both 
ends.  There is some 802.11 protocol (the letter eludes me at present) 
which is in draft form which adds information to packets so that both 
ends know each other's RSSI, but I have never seen it implemented 
anywhere yet.

I advise you keep the discussion on list as I am by no means an expert 
and many people much better at this than I may respond.

-Rick Farina
> Regards,
>
> Tim Schneider
>
>

