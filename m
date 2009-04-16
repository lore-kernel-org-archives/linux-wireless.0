Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33635 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbZDPNh7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 09:37:59 -0400
Received: by fxm2 with SMTP id 2so420905fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 06:37:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0904160611l58500309wa1ba92fe3aeff843@mail.gmail.com>
References: <49E71982.5050204@bitnet.be> <40f31dec0904160611l58500309wa1ba92fe3aeff843@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 16 Apr 2009 15:37:42 +0200
Message-ID: <69e28c910904160637j5769be3au94821d48bfecf6f2@mail.gmail.com> (sfid-20090416_153803_578448_3FEC1F43)
Subject: Re: how to set antenna iw + ath5k
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Hans Maes <Hans@bitnet.be>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 16, 2009 at 3:11 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2009/4/16 Hans Maes <Hans@bitnet.be>:
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
> we will have a better way to change this in the future ;-)

I wonder if just exporting that as a modparam is a good-enough
choice... though perhaps the best solution would be something like "iw
phy phy0 antenna 1 up/down". Or perhaps we should make antenna
diversity depend on the PCI ID, defaulting to 1 antenna when diversity
support cannot be determined.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
