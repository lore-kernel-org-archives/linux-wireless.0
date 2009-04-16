Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:57220 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbZDPPXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 11:23:15 -0400
MIME-version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0KI700L6R9EPOXB0@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Thu, 16 Apr 2009 17:23:13 +0200 (CEST)
Message-id: <49E74D46.6030707@nets.rwth-aachen.de> (sfid-20090416_172318_087691_A82DCC28)
Date: Thu, 16 Apr 2009 17:22:46 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>, Hans Maes <Hans@bitnet.be>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: how to set antenna iw + ath5k
References: <49E71982.5050204@bitnet.be>
 <40f31dec0904160611l58500309wa1ba92fe3aeff843@mail.gmail.com>
 <69e28c910904160637j5769be3au94821d48bfecf6f2@mail.gmail.com>
In-reply-to: <69e28c910904160637j5769be3au94821d48bfecf6f2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

G=E1bor Stefanik wrote:
> On Thu, Apr 16, 2009 at 3:11 PM, Nick Kossifidis <mickflemm@gmail.com=
> wrote:
>  =20
>> 2009/4/16 Hans Maes <Hans@bitnet.be>:
>>    =20
>>> Hello,
>>>
>>> I'm not sure this is the correct place to ask my question, but I've=
 been
>>> searching on google for ages now and can't seem to find an answer s=
o I'm
>>> asking it here.
>>> If not, please yell at me and tell me where to go whine instead ;-)
>>>
>>> I'm using CM11 a/b/g cards with the Atheros AR5414A Chip, which hav=
e 2
>>> antenna connectors.
>>> I only have 1 antenna connected to the MAIN connector.
>>> Running a self compiled 2.6.29 kernel on a few debian lenny boxes w=
ith ath5k
>>> module for the wireless cards, set up in mesh mode.
>>> Seems to work fine on the test bench, but behaves rather poorly in
>>> production environment.
>>> Everything related to the mesh network setup seems to work, but I h=
ave about
>>> 40% - 60% packet loss on the entire netwerk (about 15 nodes)
>>>
>>> I'm guessing this has something to do with the antenna diversity se=
tting.
>>>
>>> Can anybody tell me how to tell the ath5k module to disable antenna
>>> diversity and only use the MAIN antenna ?
>>>
>>> If this is a RTFM thingie, then I apologize, I just can't seem to f=
ind it
>>> anywhere.
>>>
>>> Please reply to my personal e-mail address as well, I'm not subscri=
bed to
>>> the list.
>>>
>>> Thanks for your help.
>>>
>>> Regards,
>>>
>>> Hans
>>>      =20
>> After this patch...
>> https://lists.ath5k.org/pipermail/ath5k-devel/2009-April/002264.html
>>
>> It's possible to tell the driver to use one fixed antenna (in your
>> case its fixed antenna A). Just change...
>> ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_DEFAULT);
>>
>> with
>> ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_FIXED_A);
>>
>> we will have a better way to change this in the future ;-)
>>    =20
>
> I wonder if just exporting that as a modparam is a good-enough
> choice... though perhaps the best solution would be something like "i=
w
> phy phy0 antenna 1 up/down". Or perhaps we should make antenna
> diversity depend on the PCI ID, defaulting to 1 antenna when diversit=
y
> support cannot be determined.
>
>  =20
modparam seems somewhat broken, thinking of multiple wireless cards...
My feature request would be to allow setup fixed txantenna only for
broadcast/multicast frames.
I think it would work for almost all setups, even if only
one antenna connector is used, as diversity logic
will naturally handle unicast frames right. Or did I miss something?

BTW: is it theoretically possible to turn off RX antenna diversity, and
what would be the potential gain?

Best regards,
Arnd

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
