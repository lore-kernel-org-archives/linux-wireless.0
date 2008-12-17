Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:65108 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYLQSEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 13:04:49 -0500
Received: by an-out-0708.google.com with SMTP id d40so8802and.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2008 10:04:47 -0800 (PST)
Message-ID: <e27b78a40812171004r3a8d424dk7c390aaf7c757665@mail.gmail.com> (sfid-20081217_190451_925011_9C6601FD)
Date: Wed, 17 Dec 2008 18:04:46 +0000
From: Keir <keirlawson@gmail.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: Mesh now completely broken on ath5k, latest git
Cc: "Andrey Yurovsky" <andrey@cozybit.com>, sbrown@cortland.com,
	linux-wireless@vger.kernel.org, javier@cozybit.com
In-Reply-To: <40f31dec0812170906vd8e4445q9920c66905064df8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com>
	 <4947ABAF.9060205@cortland.com>
	 <e27b78a40812160807j7549e1a5hf3bee474b31c29b7@mail.gmail.com>
	 <45e8e6c40812161030x1f7fb374qd4a386ef9022a853@mail.gmail.com>
	 <40f31dec0812170906vd8e4445q9920c66905064df8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tried this, and I'm getting slightly odd results.  The two nodes
running with these lines commented out can see the node whose code is
previous to the PCU patch, but they cant see each other.  Also the
other node can see both of them... very strange.

Cheers

Keir

2008/12/17 Nick Kossifidis <mickflemm@gmail.com>:
> 2008/12/16 Andrey Yurovsky <andrey@cozybit.com>:
>> Hi Keir.  What type of Atheros-based card are you using?  How many
>> antennas do you have connected?  If I understand things correctly, the
>> PCU code regression (with respect to mesh and maybe AP and IBSS) has
>> to do with having one antenna hooked up when your hardware also has an
>> AUX antenna connector.  If you have only one antenna, can you please
>> plug in a second one and try again (before and after the commit in
>> question)?  I will try to do the same test here.  More details from
>> Nick were posted here:
>> http://marc.info/?l=linux-wireless&m=122771338021489&w=2
>>
>
> To summarize, the following code on base.c is the problem...
>
> 1955                 /*
> 1956                  * Switch antenna every 4 beacons if txantenna is not set
> 1957                  * XXX assumes two antennas
> 1958                  */
> 1959                 if (antenna == 0)
> 1960                         antenna = sc->bsent & 4 ? 2 : 1;
>
> ...we should always set 0 on tx descriptor for the default scenario to
> work. Can you please comment this out and see if it works ?
>
> --
> GPG ID: 0xD21DB2DB
> As you read this post global entropy rises. Have Fun ;-)
> Nick
>
