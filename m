Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48782 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbZDPPp6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 11:45:58 -0400
Received: by fxm2 with SMTP id 2so497011fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 08:45:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49E74D46.6030707@nets.rwth-aachen.de>
References: <49E71982.5050204@bitnet.be>
	 <40f31dec0904160611l58500309wa1ba92fe3aeff843@mail.gmail.com>
	 <69e28c910904160637j5769be3au94821d48bfecf6f2@mail.gmail.com>
	 <49E74D46.6030707@nets.rwth-aachen.de>
Date: Thu, 16 Apr 2009 18:45:56 +0300
Message-ID: <40f31dec0904160845w4a6a55a8w27888c701f4b3340@mail.gmail.com> (sfid-20090416_174600_717859_99F0F7B1)
Subject: Re: how to set antenna iw + ath5k
From: Nick Kossifidis <mickflemm@gmail.com>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Hans Maes <Hans@bitnet.be>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/16 Arnd Hannemann <hannemann@nets.rwth-aachen.de>:
> G=C3=A1bor Stefanik wrote:
>> On Thu, Apr 16, 2009 at 3:11 PM, Nick Kossifidis <mickflemm@gmail.co=
m> wrote:
>>
>>> 2009/4/16 Hans Maes <Hans@bitnet.be>:
>>>
>>>> Hello,
>>>>
>>>> I'm not sure this is the correct place to ask my question, but I'v=
e been
>>>> searching on google for ages now and can't seem to find an answer =
so I'm
>>>> asking it here.
>>>> If not, please yell at me and tell me where to go whine instead ;-=
)
>>>>
>>>> I'm using CM11 a/b/g cards with the Atheros AR5414A Chip, which ha=
ve 2
>>>> antenna connectors.
>>>> I only have 1 antenna connected to the MAIN connector.
>>>> Running a self compiled 2.6.29 kernel on a few debian lenny boxes =
with ath5k
>>>> module for the wireless cards, set up in mesh mode.
>>>> Seems to work fine on the test bench, but behaves rather poorly in
>>>> production environment.
>>>> Everything related to the mesh network setup seems to work, but I =
have about
>>>> 40% - 60% packet loss on the entire netwerk (about 15 nodes)
>>>>
>>>> I'm guessing this has something to do with the antenna diversity s=
etting.
>>>>
>>>> Can anybody tell me how to tell the ath5k module to disable antenn=
a
>>>> diversity and only use the MAIN antenna ?
>>>>
>>>> If this is a RTFM thingie, then I apologize, I just can't seem to =
find it
>>>> anywhere.
>>>>
>>>> Please reply to my personal e-mail address as well, I'm not subscr=
ibed to
>>>> the list.
>>>>
>>>> Thanks for your help.
>>>>
>>>> Regards,
>>>>
>>>> Hans
>>>>
>>> After this patch...
>>> https://lists.ath5k.org/pipermail/ath5k-devel/2009-April/002264.htm=
l
>>>
>>> It's possible to tell the driver to use one fixed antenna (in your
>>> case its fixed antenna A). Just change...
>>> ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_DEFAULT);
>>>
>>> with
>>> ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_FIXED_A);
>>>
>>> we will have a better way to change this in the future ;-)
>>>
>>
>> I wonder if just exporting that as a modparam is a good-enough
>> choice... though perhaps the best solution would be something like "=
iw
>> phy phy0 antenna 1 up/down". Or perhaps we should make antenna
>> diversity depend on the PCI ID, defaulting to 1 antenna when diversi=
ty
>> support cannot be determined.
>>
>>
> modparam seems somewhat broken, thinking of multiple wireless cards..=
=2E
> My feature request would be to allow setup fixed txantenna only for
> broadcast/multicast frames.

Well such frames should be sent on all antennas i believe (i did some
experiments and it seems we can force this by writing 0xf on antenna
field of tx descriptor).

> I think it would work for almost all setups, even if only
> one antenna connector is used, as diversity logic
> will naturally handle unicast frames right. Or did I miss something?
>
> BTW: is it theoretically possible to turn off RX antenna diversity, a=
nd
> what would be the potential gain?
>

Yes, check out the patch. The only problem i see with rx diversity in
some cases is when you get a frame on the wrong antenna, this can lead
on updating tx antenna (based on acks etc) which can lead to missed
frames.

--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
