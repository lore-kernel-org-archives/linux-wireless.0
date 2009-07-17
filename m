Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:44596 "EHLO
	postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934122AbZGQGhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 02:37:17 -0400
Received: from [10.0.1.10] (dslb-084-063-085-116.pools.arcor-ip.net [84.63.85.116])
	by postfix.iai.uni-bonn.de (Postfix) with ESMTP id B42485C837
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 08:37:15 +0200 (MEST)
	(envelope-from schneid5@cs.uni-bonn.de)
	(envelope-to linux-wireless@vger.kernel.org) (1)
	(internal use: ta=1, tu=1, te=1, am=P, au=schneid5)
Message-Id: <F18A4B8D-C326-4511-84A6-D3E38CB3E7E4@cs.uni-bonn.de>
From: Tim Schneider <schneid5@cs.uni-bonn.de>
To: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A5B211D.3040905@gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: Reading the RSSI from a Kernel Module
Date: Fri, 17 Jul 2009 08:37:14 +0200
References: <0D620DB9-0DF4-41BB-8686-5BC910F88C79@cs.uni-bonn.de> <4A5ADB52.3080401@gmail.com> <2E605895-C629-47C5-8DF8-DF012A3749EB@cs.uni-bonn.de> <4A5B211D.3040905@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I did some research on the subject, and it seems that you are right.  
The RSSI Value can only be read at the receiving end. This does make a  
lot of sense, but I read a paper about the Algorithm I am trying to  
implement, and the Author stated it would be possible to read the RSSI- 
Value at the senders end. Since the author is a professor at a German  
university, I figured he knew what he was talking about. I reworked my  
way through the Paper and realized, that there is another thing that  
you can't just read at the senders end. He uses the hopcount of the  
connection for his calculations. That's an Information that is  
actually impossible to get without the support of the routing-layer.  
Since I need to modify the routing-layer anyways now, I'll just modify  
it in a way, so that I can read the RSSI-Information of the first hop  
too.

Thank you for your help.

Tim Schneider

Am 13.07.2009 um 13:57 schrieb Richard Farina:

> Tim Schneider wrote:
>>
>> Am 13.07.2009 um 08:59 schrieb Richard Farina:
>>> I don't mean to make this a flame so please do not take it that  
>>> way.  How exactly do you expect to get the RECEIVED Signal  
>>> Strength indication for a packet which you are SENDING? If you  
>>> send it, you don't receive it...
>>>
>>> Just my 0.02
>>>
>>> -Rick Farina
>>
>> Hi Rick,
>>
>> as far, as I understood, the RSSI-Mechanism also displays the  
>> signal strength of the just sent package. I figured there was some  
>> way the MAC-Layer transported that information, but you're right, I  
>> could be mistaken. Anyways, since I'm trying to implement a TCP  
>> Algorithm, i definitely have a  two-way connection. Assuming, that  
>> the route back is going to be the same as it was on the way there  
>> (which basically should be true, based on the Routing algorithms  
>> we're using in our wireless mesh network), I could just use the  
>> RSSI Value of the received ACK.
>>
> Any RSSI on a sent packet will be a calculated number not an  
> observed number and as such it will be completely pointless for any  
> kind of rate control algorithm.  Assuming that the card could  
> actually receive the packets it is sending (which it can't) then you  
> would be observing a 24dBm signal (for instance) with 0 patch loss  
> and your RSSI would be at or above max.  Realistically you can  
> assume that every packet you sent has a max RSSI on your end because  
> you are the one transmitting it.  Now, if you want to know what the  
> RSSI on the receiver side is that is a completely different  
> question, one which you cannot answer at all. When you send a packet  
> you do not have the good fortune to know what RSSI the receiver  
> got.  You can roughly assume based on your RSSI when you get an ACK,  
> but honestly that isn't even close to correct because every packet  
> has a very unique experience in the air and you cannot assume things  
> like the same tx power and rx sensitivity will be the same on both  
> ends.  There is some 802.11 protocol (the letter eludes me at  
> present) which is in draft form which adds information to packets so  
> that both ends know each other's RSSI, but I have never seen it  
> implemented anywhere yet.
>
> I advise you keep the discussion on list as I am by no means an  
> expert and many people much better at this than I may respond.
>
> -Rick Farina
>> Regards,
>>
>> Tim Schneider
>>
>>
>

