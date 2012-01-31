Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3110 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab2AaOpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 09:45:08 -0500
Message-ID: <4F27FE61.9010701@broadcom.com> (sfid-20120131_154514_484339_69E68588)
Date: Tue, 31 Jan 2012 15:44:49 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Milan Bouchet-Valat" <nalimilan@club-internet.fr>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4313 keeps disconnecting with brcmsmac and multiple APs
References: <22905678.140637.1327401110095.JavaMail.www@wsfrf1232>
 <4F227784.10309@broadcom.com> <1327660003.21888.14.camel@milan>
 <4F228C76.2010109@broadcom.com>
 <13367957.180704.1328018261479.JavaMail.www@wsfrf1118>
In-Reply-To: <13367957.180704.1328018261479.JavaMail.www@wsfrf1118>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2012 02:57 PM, Milan Bouchet-Valat wrote:
> (Just noticed my Webmail got the quotations wrong. New attempt:)
> 
> Le vendredi 27 janvier 2012 à 12:37 +0100, Arend van Spriel a écrit :
> On 01/27/2012 11:26 AM, Milan Bouchet-Valat wrote:
>>> Le vendredi 27 janvier 2012 à 11:08 +0100, Arend van Spriel a écrit :
>>>> Another thing to consider. I notice that you have a bluetooth device in
>>>> there as well. Can you disable that (if possible) and try again.
>>> I'll try that, but sadly not before Tuesday as I'm not in the right
>>> place ATM.
>>
>> Ok. To disable bluetooth you could use the rfkill utility:
>>
>> $ rfkill block bluetooth
> Yes, I did that, but it doesn't fix the problem.
> 
>>> Does your AP have DFS enabled?
>>> I'll ask my IT staff about that. Or is there a way to get this
>>> information from the logs or iwconfig?
>>>
>>
>> I actually did mean whether the AP has automatic channel selection. I am
>> not sure whether it is advertised in the beacons.
> I think you found the origin of the problem. I ran iwlist scan after  the bug happened, and my network's APs are visible on 3 different  channels (1, 6 and 11). When everything was fine, it was only on channel  11. The most surprising thing is that the precise AP I'm associated  with is now visible on two channels (1 and 11).
> 
> Another weird  fact is that after reloading brcmsmac (I had to do it twice to be able  to reconnect), I still see my APs on these different 3 channels, and  still it works fine. But maybe the channel change is what triggers the  bug.
> 
> As you see, this is a very crowded place, with other  networks using the same channels. This is probably not an ideal setup,  but it's great to stress-test the drivers. ;-)
> 
> 
> Regards
> 

Could you provide another log trace in which it goes wrong. I am
wondering whether it attempts to connect to a different AP or not. I
assume each AP has the same SSID and security configration, right?

Gr. AvS

