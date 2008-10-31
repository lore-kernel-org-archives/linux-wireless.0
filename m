Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:63173 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYJaTGf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 15:06:35 -0400
Received: by ik-out-1112.google.com with SMTP id c29so378042ika.5
        for <linux-wireless@vger.kernel.org>; Fri, 31 Oct 2008 12:06:32 -0700 (PDT)
Message-ID: <490B5736.10508@gmail.com> (sfid-20081031_200639_997471_FB2C9F6F)
Date: Fri, 31 Oct 2008 15:06:30 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Dave <kilroyd@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: Guidelines regarding separate directory
References: <4909EA78.3060700@lwfinger.net>	 (sfid-20081030_181107_189082_5740895D) <1225387309.3690.73.camel@johannes.berg>	 <490A17F3.5050802@gmail.com>  <1225399481.7931.5.camel@dv>	 <1225399682.3690.82.camel@johannes.berg>  <490B3AAC.1000803@gmail.com> <1225474867.23627.4.camel@dv>
In-Reply-To: <1225474867.23627.4.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Fri, 2008-10-31 at 13:04 -0400, Richard Farina wrote:
>   
>> Johannes Berg wrote:
>>     
>>>>> orinoco_pci.c
>>>>>       
>>>>>           
>>>> orinoco_pci.c is a good candidate for removal.  It only supports the
>>>> hardware that is already supported by hostap_pci.
>>>>     
>>>>         
>>> Wait wait. I think everybody would rather see hostap go than orinoco
>>> since hostap is a huge complex thing and quite buggy.
>>>
>>>   
>>>       
>> I really disagree with this statement.  Until kernel version 2.6.21 the 
>> hostap driver was used very widely by the wifi security community 
>> because of it's great abilities for monitor mode and frame injection.  
>> In kernel 2.6.21 there was a change that made the injection patches not 
>> work and my ability is insufficient to fix this regression, however, the 
>> orinoco driver has always had morbid issues with simple things such as 
>> monitor mode.
>>     
>
> The only issue I know in the monitor mode in orinoco is lack of radiotap
> headers.  That should not be hard to add.  Issues with Agere firmware
> are irrelevant since hostap doesn't support it.  Are there any other
> issues you have in mind?
>
>   
Last I checked, the orinoco_cs driver couldn't even put a prism2 card in 
monitor mode.  I just tried it again and that is working, but the 
channel hopping control doesn't seem to work properly at all. As an 
example, airodump-ng cannot hop channels (which I'm reporting to the 
aircrack-ng team next).  I know that the idea of having one driver for 
the two devices may seem like a good idea, but I've always been against 
it because in fact the orinoco cards were a poor implementation of a 
modified prism2 reference implementation.  I mean no disrespect to the 
orinoco driver team (yes Pavel, I see your name on it) but the driver 
simply is not nearly as mature as the hostap drivers.  The additional 
functionality of the hostap drivers such as master mode, monitor mode 
headers, and firmware loading (both flash and ram) make is an excellent 
choice to be maintained at least in the foreseeable future.

That said, if there is anyone with some interest in fixing the monitor 
mode inject which was broken in kernel 2.6.21 I would be happy to 
provide you with everything I know if you can help (I have a lot of 
documentation and the existing patch sets).  Sadly, my coding skills 
only let me work on very minor things.

Thanks,
Rick Farina

>> I understand that hostap needs some work, and it would be nice if 
>> someone volunteered to help fix the packet injection, but removing this 
>> driver in favor of orinoco_cs would be a serious regression.
>>     
>
> At this point, I agree.  It's better that we concentrate on fixing known
> issues rather than on choosing which driver to remove.
>
>   

