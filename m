Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:61362 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYLQRGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 12:06:08 -0500
Received: by yw-out-2324.google.com with SMTP id 9so1589202ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2008 09:06:07 -0800 (PST)
Message-ID: <40f31dec0812170906vd8e4445q9920c66905064df8@mail.gmail.com> (sfid-20081217_180614_059323_C0DE63ED)
Date: Wed, 17 Dec 2008 19:06:07 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Andrey Yurovsky" <andrey@cozybit.com>
Subject: Re: Mesh now completely broken on ath5k, latest git
Cc: Keir <keirlawson@gmail.com>, sbrown@cortland.com,
	linux-wireless@vger.kernel.org, javier@cozybit.com
In-Reply-To: <45e8e6c40812161030x1f7fb374qd4a386ef9022a853@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com>
	 <4947ABAF.9060205@cortland.com>
	 <e27b78a40812160807j7549e1a5hf3bee474b31c29b7@mail.gmail.com>
	 <45e8e6c40812161030x1f7fb374qd4a386ef9022a853@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/12/16 Andrey Yurovsky <andrey@cozybit.com>:
> Hi Keir.  What type of Atheros-based card are you using?  How many
> antennas do you have connected?  If I understand things correctly, the
> PCU code regression (with respect to mesh and maybe AP and IBSS) has
> to do with having one antenna hooked up when your hardware also has an
> AUX antenna connector.  If you have only one antenna, can you please
> plug in a second one and try again (before and after the commit in
> question)?  I will try to do the same test here.  More details from
> Nick were posted here:
> http://marc.info/?l=linux-wireless&m=122771338021489&w=2
>

To summarize, the following code on base.c is the problem...

1955                 /*
1956                  * Switch antenna every 4 beacons if txantenna is not set
1957                  * XXX assumes two antennas
1958                  */
1959                 if (antenna == 0)
1960                         antenna = sc->bsent & 4 ? 2 : 1;

...we should always set 0 on tx descriptor for the default scenario to
work. Can you please comment this out and see if it works ?

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
