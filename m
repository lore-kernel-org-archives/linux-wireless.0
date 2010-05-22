Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:34121 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932376Ab0EVBJ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 21:09:59 -0400
Message-ID: <4BF72EE5.7080108@dlasys.net>
Date: Fri, 21 May 2010 21:09:57 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: carl9170 1.0.6 carl9170_tx_superdesc
References: <4BDC001F.9050202@dlasys.net> <201005021452.01101.chunkeey@googlemail.com> <4BF6FC91.9060109@dlasys.net> <201005220055.02528.chunkeey@googlemail.com>
In-Reply-To: <201005220055.02528.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/21/2010 06:55 PM, Christian Lamparter wrote:
> On Friday 21 May 2010 23:35:13 David H. Lynch Jr. wrote:
>    
>> I need to track a new value for each tx frame only in the firmware.
>> It appears I should be adding it to carl9170_tx_superdesc.
>> But that structure seems to be used on both the Linux and firmware side,
>> and I have not been able to successfully add to it without breaking
>> something elsewhere either in the firmware or Linux driver or between them.
>>      
> there are two superdesc structures:
> 	carl9170_tx_superdesc and _carl9170_tx_superdesc.
>
> This is due to the bit-field packing bug which is present
> in all GCC version prior to 4.4.
>
> Now, for the firmware we have a special toolchain and
> a BUILD_BUG check, so no problem is there.
>
> But kernel driver&  userspace tools might be compiled by
> an older version.
>
> Therefore, if you want to introduce new fields, you have
> to update both structures accordingly.
>
> (And of course, always check that you're using your
>   custom firmware and driver.)
>    
     For the moment I have found another way of resolving the issue.
     I am not concerned that there are two versions of the structures 
under Linux.
     My problem was that it appears to add a field to the firmware I 
must also add it to linux.

     During a TX I am looking to track something in firmware, and then 
return it to Linux.
     If I have this correct the carl9170_tx_superframe is passed from 
Linux to the firmware and the carl9170_tx_status is passed back to Linux.

     I do not need the extra field in carl9170_tx_superframe in Linux. i 
do need it at several different points prior to having a 
carl9170_tx_status record, in the firmware. And then I need to return 
the value to Linux in the carl9170_tx_status field.

      I am gathering that whether I need or not that 
carl9170_tx_superframe must match perfectly between Linux and the 
firmware. And there is no other per packet data being managed in the 
firmware.

     My second problem is that even after adding it to both sides and 
adjusting for all the alignment and other issues, I end up with 
something that does not work.
      I am being careful to keep the driver and firmware aligned. I 
grasp that is an issue.


>    
>> 	Alternately I can create a private array to hold my data, but then I
>> need to be able to find items in it using a carl9170_tx_superframe
>> pointer. I am gathering that the cookie and queue number constitute a
>> unique identifier, but that seems like alot of work to avoid adding a
>> u16 to carl9170_tx_superdesc.
>>      
> It might not be visible at first glance, but carl9170_tx_superframe
> has two distinct header descriptors.
>   * ar9170_tx_hwdesc
>   * carl9170_tx_superdesc
>
> variables of those headers can not be mixed. This is because the
> layout of ar9170_tx_hwdesc is dictated by the hardware design.
>
> Therefore the queue number goes into ar9170_tx_hwdesc.mac.QoS,
> whereas the "cookie" is intended to be used by the firmware code.
> (In fact, carl9170_tx_superdesc is _hidden_ from the hardware POV)
>
>    
>> 	Any other ideas about tracking a u16 value for each tx frame only on
>> the firmware side without substantial complexity ?
>>      
> Erm, adding a single u16 is a bad idea. I'm pretty sure that the documents
> from your employer cover this subject in great detail since this is a
> well-known limitation.
>    
     Pardon my sensitivity, but I am a consultant. I have clients not 
employers.
     The parts of the AR9170 spec I have read do not address this, but I 
have not read everything thoroughly.
     My project deals almost exclusively with timing. And I am trying 
not to touch things I do not need to.


> What you could try - on the other hand - u32.
> even if you don't need the extra 2 bytes that come with this
> bigger storage class.
>    
         I may need to do that anyway. 25ns * 65K is 1.6ms before 
overflow, that is almost too short.

>
> BTW:
> Yes, the (CARL9170_TX_STATUS_NUM % 2) check can be safely disabled now.
> But let me run some experiments. Just to be on the safe side.
>    
     Thanks.

> Regards,
> 	Chr
>    


-- 
Dave Lynch 					  	    DLA Systems
Software Development:  				         Embedded Linux
717.587.7774 	       dhlii@dlasys.net 	  http://www.dlasys.net
Over 25 years' experience in platforms, languages, and technologies too numerous to list.

"Any intelligent fool can make things bigger and more complex... It takes a touch of genius - and a lot of courage to move in the opposite direction."
Albert Einstein

