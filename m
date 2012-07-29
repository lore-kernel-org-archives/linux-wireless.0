Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:65319 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab2G2Uxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2012 16:53:51 -0400
Received: by gglu4 with SMTP id u4so4260017ggl.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jul 2012 13:53:50 -0700 (PDT)
Message-ID: <5015A2DB.50106@lwfinger.net> (sfid-20120729_225354_507300_F1B19494)
Date: Sun, 29 Jul 2012 15:53:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> <501129D9.4060407@lwfinger.net> <1343314190.31952.YahooMailNeo@web28901.mail.ir2.yahoo.com> <5011BC0A.8060600@lwfinger.net> <1343370892.97699.YahooMailNeo@web28904.mail.ir2.yahoo.com> <501280BF.4070409@lwfinger.net> <1343394581.87030.YahooMailNeo@web28902.mail.ir2.yahoo.com> <1343398356.19742.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343403507.54955.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343404770.91235.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343407089.96532.YahooMailNeo@web28901.mail.ir2.yahoo.com> <50140463.3080209@lwfinger.net> <1343591834.22699.YahooMailNeo@web28905.mail.ir2.yahoo.com>
In-Reply-To: <1343591834.22699.YahooMailNeo@web28905.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/29/2012 02:57 PM, Xavier de Almeida wrote:
>> I run mine, when I test AP mode, without any options.
>
>>
>> I'm glad you got it working. Now you know why I recommend spending 40 euro
>> for
>> an AP rather than trying to use a 600 euro computer for that purpose. BTW, I own
>>
>> 4 AP/routers.
>>
>> Larry
>>
>
> My goal was to have a low power server that runs 24h for wireless, domotic, ... but I didn't find how to increase the signal and remove the power mgt.

A part of "modinfo rtl8192ce" says

parm:  ips:Set to 0 to not use link power save (default 1) (bool)

Load the modules with "sudo modprobe rtl8192ce ips=0" or create the appropriate 
rtl8192ce.conf file, and power saving is disables.


The RTL8187L, the chip in the AWUS036H will never work in AP mode. It has only 
one hardware queue, and getting the timing right for beacons is extremely 
difficult, and not worth the effort.

> Have you had to add parameters in your rtl8192ce.conf file in modprobe?

Except for testing, I use no module parameters. If any were always necessary, I 
would change the default.

Larry

>
> I found this device in my garage :) which is known to be working well so I may try it just to compare the signal strengths between both
> rtl8187 Alfa AWUS036H 0x0bda 0x8187
>
>
> Again I would like to thank you again for all your reactive support in order to help me making my on-board pci wifi card working. At least I can now make a choice depending on the signal length.
>
> FYI I did find that the BW was quote low with the rtl8188ce AP. Did you notice the same issue?
>
> MERCI
>


