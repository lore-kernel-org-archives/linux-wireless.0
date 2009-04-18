Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:42280 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbZDROCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 10:02:15 -0400
Received: by ewy24 with SMTP id 24so570143ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 18 Apr 2009 07:02:14 -0700 (PDT)
Message-ID: <49E9DD64.7000902@tuffmail.co.uk> (sfid-20090418_160219_548696_78545365)
Date: Sat, 18 Apr 2009 15:02:12 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Rfkill rewrite: eeepc-laptop resume
References: <49DCA88E.6060400@tuffmail.co.uk>	 (sfid-20090408_153722_059382_FB44D658) <1239204090.16477.1.camel@johannes.local>	 <49DCDD2E.80705@tuffmail.co.uk>  <49E38BBC.5010708@tuffmail.co.uk>	 (sfid-20090413_205524_915082_56358705) <1239741968.4205.1.camel@johannes.local>	 <49E98C86.2040308@tuffmail.co.uk>	 (sfid-20090418_101208_980691_83127E2F) <1240043283.5792.0.camel@johannes.local>	 <49E9A0C7.8040602@tuffmail.co.uk>	 (sfid-20090418_114338_695917_3CBF9024) <1240057470.4755.7.camel@johannes.local>	 <49E9D5AE.50509@tuffmail.co.uk> (sfid-20090418_152951_979624_DE0ADF1D) <1240061621.4755.35.camel@johannes.local>
In-Reply-To: <1240061621.4755.35.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2009-04-18 at 14:29 +0100, Alan Jenkins wrote:
>
>   
>> API nit:
>>
>>  * This function tells the rfkill core that the device is capable of
>>  * remembering soft blocks (which it is notified of via the set_block
>>  * method) -- this means that the driver may ignore the return value
>>  * from rfkill_set_hw_state().
>>
>> Doesn't this conflict with the declaration of rfkill_set_sw_state() as
>> __must_check?
>>     
>
> Yeah, in a way it does, but I figure it's rare enough that those who
> really can ignore it can write
> 	(void) rfkill_set_sw_state(...)
>
> Don't really have a strong opinion, it just seemed the mistake in the
> other direction would be more common.
>   
Oops... I meant to write rfkill_set_hw_state(), I think you copied me.  Ok.

So then why is the _sw_ variant marked __must_check?  That looks like a
mistake.  I don't see what I can sensibly do with the return value. 
Unless you want EPO to veto a firmware-initiated enable?

Thanks
Alan
