Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:58619 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZBXSuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 13:50:19 -0500
Cc: Lorenzo Nava <navalorenx@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Message-Id: <9CC7CE2A-C80A-4620-B441-EAD6371710E1@ing.unibs.it> (sfid-20090224_195022_006124_F80B3665)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <49A43F8A.5000500@lwfinger.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: More data on open-source firmware crash
Date: Tue, 24 Feb 2009 19:50:15 +0100
References: <49A1A331.9080205@lwfinger.net> <80C13710-6BA9-4F14-95B5-82C3043CE93B@ing.unibs.it> <49A41F1D.9060300@lwfinger.net> <03E07CC7-A971-4EDD-9363-628B61E94A92@ing.unibs.it> <49A421ED.7000801@lwfinger.net> <7528B52E-1B77-4CA9-A17F-01E24FDF81DC@ing.unibs.it> <49A43F8A.5000500@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 24, 2009, at 7:42 PM, Larry Finger wrote:

> Francesco Gringoli wrote:
>>
>> On Feb 24, 2009, at 5:35 PM, Larry Finger wrote:
>>
>>> Francesco Gringoli wrote:
>>>> What about drop info from dmesg? Another try could be halve the dma
>>>> queue, I believe now it is 64 slots. Could you give a try setting  
>>>> it
>>>> to 32?
>>>
>>> The RX DMA queue was 64 and TX was 256. Both will be 32 in my next  
>>> run.
>>>
>>> I don't understand the "drop info from dmesg" part.
>> Sorry Larry,
>>
>> sometimes when I modify something, I can read
>>
>> [334415.451028] b43-phy244 debug: RX: Packet dropped
>>
>> in the dmesg because the received bytes were not correctly copied
>> between the "air-buffer" to the internal buffer and finally to the
>> rx-fifo along with the rxheader.
>>
>> Did you notice something similar?
>
> I hadn't noticed them before, but I do see one of these messages  
> just before
> some of my out-of-order cookies. There is no associated diagnostic  
> message, thus
> it must come from the status.rate_index test. I'll see if I can get  
> some info
> from there.
>
> Larry
>
Larry, take care that they are not due to massive usage of b43-fwdump.  
Sometime this utility forces the firmware to slow down and produce  
such messages. If you didn't use the utility and got that message  
anyway, we can try to investigate on this.

Cheers,
-FG


-------

Francesco Gringoli, PhD - Assistant Professor
Dept. of Electrical Engineering for Automation
University of Brescia
via Branze, 38
25123 Brescia
ITALY

Ph:  ++39.030.3715843
FAX: ++39.030.380014
WWW: http://www.ing.unibs.it/~gringoli




