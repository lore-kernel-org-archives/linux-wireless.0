Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c.6b.1343.static.theplanet.com ([67.19.107.12]:32834 "EHLO
	mail.bitnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbZDUL4K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 07:56:10 -0400
Received: from [192.168.10.247] (unknown [79.132.226.168])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.bitnet.be (Postfix) with ESMTP id E11DB2980DC
	for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2009 06:55:48 -0500 (CDT)
Message-ID: <49EDB474.2020809@bitnet.be> (sfid-20090421_135628_911427_CDE9874A)
Date: Tue, 21 Apr 2009 13:56:36 +0200
From: Hans Maes <Hans@bitnet.be>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: how to set antenna iw + ath5k
References: <49E71982.5050204@bitnet.be> <40f31dec0904160611l58500309wa1ba92fe3aeff843@mail.gmail.com>
In-Reply-To: <40f31dec0904160611l58500309wa1ba92fe3aeff843@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Nick Kossifidis wrote:
> 2009/4/16 Hans Maes <Hans@bitnet.be>:
>   
>> Hello,
>>
>> I'm not sure this is the correct place to ask my question, but I've been
>> searching on google for ages now and can't seem to find an answer so I'm
>> asking it here.
>> If not, please yell at me and tell me where to go whine instead ;-)
>>
>> I'm using CM11 a/b/g cards with the Atheros AR5414A Chip, which have 2
>> antenna connectors.
>> I only have 1 antenna connected to the MAIN connector.
>> Running a self compiled 2.6.29 kernel on a few debian lenny boxes with ath5k
>> module for the wireless cards, set up in mesh mode.
>> Seems to work fine on the test bench, but behaves rather poorly in
>> production environment.
>> Everything related to the mesh network setup seems to work, but I have about
>> 40% - 60% packet loss on the entire netwerk (about 15 nodes)
>>
>> I'm guessing this has something to do with the antenna diversity setting.
>>
>> Can anybody tell me how to tell the ath5k module to disable antenna
>> diversity and only use the MAIN antenna ?
>>
>> If this is a RTFM thingie, then I apologize, I just can't seem to find it
>> anywhere.
>>
>> Please reply to my personal e-mail address as well, I'm not subscribed to
>> the list.
>>
>> Thanks for your help.
>>
>> Regards,
>>
>> Hans
>>     
>
> After this patch...
> https://lists.ath5k.org/pipermail/ath5k-devel/2009-April/002264.html
>
> It's possible to tell the driver to use one fixed antenna (in your
> case its fixed antenna A). Just change...
> ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_DEFAULT);
>
> with
> ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_FIXED_A);
>   
Seems like a quite recent patch ;-)

I've been reading up on how to patch the source myself, but I'm not sure 
I'll succeed without breaking things.
I can manage pulling the git repository and compiling the ath5k module, 
but I'm no expert at patching stuff.

Any pointers where to look for a simple howto on 'the proper way' to 
apply these patches ?
Any idea when this patch would make it into the git repository ?
> we will have a better way to change this in the future ;-)
>   
That would be nice, I know most users don't need to change this and can 
live with default settings, but there are so many possible scenarios 
where one would want more specific control over antenna settings.


Thanks for the help!

Hans
