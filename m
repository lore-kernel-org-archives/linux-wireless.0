Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:60093 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab0EOJYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 May 2010 05:24:51 -0400
Message-ID: <4BEE684F.2070707@create-net.org>
Date: Sat, 15 May 2010 11:24:31 +0200
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: linux-wireless@vger.kernel.org
Subject: Re: Strange ACK Behaviour with ath9k
References: <4BEC2318.5050701@create-net.org> <AANLkTimnzAJd9Y02m8OBVLHphL5pbFw56M2LfB1L5oKz@mail.gmail.com>
In-Reply-To: <AANLkTimnzAJd9Y02m8OBVLHphL5pbFw56M2LfB1L5oKz@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

at both ends of the communications I get the hwaddr from the iwconfig
command and I pass the output to my software. In fact the other host
acks the frame carrying the echo request message and generates the
corresponding echo reply whose frame is actually acked by the recipient
the point is that they keep resending the frames until the max data retries
is reached.

On 05/14/2010 01:15 AM, Björn Smedman wrote:
> Hi Roberto,
>
> When I've seen this it has been caused by a mismatch between the
> addresses in the injected frame and that configured in the hardware.
> The transmitting radio doesn't understand it is the intended recipient
> of the ack and continues retrying.
>
> /Björn
>
> On Thu, May 13, 2010 at 6:04 PM, Roberto Riggio
> <roberto.riggio@create-net.org>  wrote:
>    
>> Hi,
>>
>> I'm having a very strange behaviour between two sr71a (ath9k) cards
>> operating in monitor mode. I'm using the following patch to specify
>> the transmission rate frame by frame:
>>
>> http://thread.gmane.org/gmane.linux.kernel.wireless.general/47441
>>
>>
>> However if I try to send some traffic between the two nodes with both
>> interfaces operating in monitor mode I can see from a third machine
>> using wireshark that albeit the frame is sent and the corresponding
>> ack generated, the originator seems to ignore the ACK and keepts
>> retransmitting the frame. This is happening on both ends of the
>> communication (i'm ping one node from the other).
>>
>> As a matter of fact i thought that ACK are handled directly by the
>> firmware. Any hints?
>>
>> R.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>      
>
>
>    

