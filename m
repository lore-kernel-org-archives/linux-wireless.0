Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp107.plus.mail.re1.yahoo.com ([69.147.102.70]:20467 "HELO
	smtp107.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934488Ab0BYXhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 18:37:23 -0500
Message-ID: <4B8709AF.70001@yahoo.com>
Date: Fri, 26 Feb 2010 00:37:19 +0100
From: Alban Browaeys <prahal@yahoo.com>
Reply-To: prahal@yahoo.com
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: Pavel Roskin <proski@gnu.org>,
	John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/2] rt2x00 : hw support txdone implementation. (without
 fallback change)
References: <4B85FA66.2020503@yahoo.com> <1267120092.25296.31.camel@mj> <4B86D0BD.3000803@yahoo.com> <201002252146.22846.IvDoorn@gmail.com>
In-Reply-To: <201002252146.22846.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25/02/2010 21:46, Ivo van Doorn wrote:
> Hi,
>
> Overall this patch has great similarities to something which Josef (CC added)
> has posted earlier. The patch in question was not merged due to some issues,
> but he is working on an updated. You might want to synchronize your work
> with him. :)
>
>    
The patch :
http://article.gmane.org/gmane.linux.kernel.wireless.general/46713

if so it has nothing in common. The patch from benoit papillault you 
rejected a year ago due to
another part of the patch that was modifying the meaning of the fallback 
flag si the one I am reworking.
I just removed this fallback part.

Also it relies on DMA<number> interrupt which are triggered even if the 
packet is rejected
by the hw engine. Only tx_sta_fifo triggered tells the thing was sent in 
the end.
So it ignores the errors from the hw, tells success always to mac layer and
  remove any sanity check about the packet descriptor.

With this one there is no way to tell success, failure, fallback or else.
A DMA<number> interrupt without TX_STA_FIFO to follow it means an 
incorrect txdesc.
Uses to be padding issues. COuld also be wrong headroom calculation in 
write_tx_desc.


If we handle txdone in DMA<number> interrupts we are killing any chances 
to get status (success, failure).


The other TBTT fix is indeed a great step in the right direction (I 
ignored beacons issues for a long time
as  not top priority and as I knew few about it but it is a great fix :
http://article.gmane.org/gmane.linux.kernel.wireless.general/42949

Both of those patches were not sent to the rt2x00 ML so I missed them.


>>>> +	for (i=0; i<256; i++) {
>>>>
>>>>          
>>> checkpatch.pl complains about spacing.  There should be spaces around
>>> "=" and"<"
>>>        
> Also I prefer the:
> 	while (!rt2x00queue_empty(queue)) {
>
> version from Josef's patch.
>    

Note that this one construct requires to use DMA<number> interrupt to 
call txdone.
I should not go this way knowing that it prevents any success/failure 
status handling.
Also I found a year ago that emptying the queue at each packet 
processing is killing packets.
We tag as unsuccessfull packets that have not yet been acknowledged by a 
tx sta fifo status (as dma<number> interrupts
and adhoc tx sta fifo interrupt are not synchronized).


>>>> +		rt2x00_desc_read(txwi, 1,&word);
>>>> +		tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
>>>> +		tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
>>>> +		tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
>>>> +
>>>> +		if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid))
>>>> +			WARNING(rt2x00dev, "invalid TX_STA_FIFO content\n");
>>>>
>>>>          
>>> Can we make this sanity check optional?
>>>
>>>
>>>        
>> Is this a showstopper ? Do you mean only enabling this message telling
>> something totally
>> unexpected happened in debug mode ? The sanity of the queue is pretty
>> critical for operation.
>>      
> I don't think this should be a showstopper, in fact how often would this error be printed?
> Is it regularly, like the rt61pci bug where not all TX done events were raised, or is it really
> a very rare case?
>
>    

It should never happens except while hacking the driver and making 
mistake in the descriptor writing or such.
Which well happens in the development process . Or for testers.


BR
Alban
