Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42570 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1JRIb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 04:31:29 -0400
Received: by bkbzt19 with SMTP id zt19so510970bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 01:31:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC0DF4A03E@SJEXCHCCR02.corp.ad.broadcom.com>
References: <CADxqDgHYu51DQXOLT3eA=6PckSmXc42BFUF=Z7qZ_Cs45T1GjQ@mail.gmail.com>
 <400C43189542CE41BC0A5B252FC90136BC0DF4A03E@SJEXCHCCR02.corp.ad.broadcom.com>
From: =?ISO-8859-1?Q?Andr=E9s_Garc=EDa_Saavedra?=
	<andres.garcia.saavedra@gmail.com>
Date: Tue, 18 Oct 2011 10:31:08 +0200
Message-ID: <CADxqDgGoBq5+6O1XUB1fu6Na3E1Mq2sko9w=PUtK=V+gZcOXjQ@mail.gmail.com> (sfid-20111018_103134_092016_4CA1B74F)
Subject: Re: brcmfmac driver implementation: Questions
To: Arend Van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you for your answers, been very helpful.

2011/10/17 Arend Van Spriel <arend@broadcom.com>:
>> Sent: maandag 17 oktober 2011 19:59
>>
>> Hi all,
>>
>> I would like to test some custom powersaving algorithms for 802.11abg
>> WLANs on some current android smartphone (e.g., nexus one). My
>> question is regarding the brcmfmac driver implementation for BCM4329
>> chipsets:
>>
>> * The current open source implementation of the driver, brcmfmac, does
>> ONLY support 11n PHY?
>
> Yes. It supports the bcm4329 device which comes with a 11n phy, which
> can connect to a non-11n AP without problems.
>
>> * Does this driver interfaces the mac80211 operations or "acts as" a
>> mac80211 driver itself talking to cfg80211/nl80211?
>
> The brcmfmac does not require mac80211, but interfaces with cfg80211.
>
>> * Does the chipset/current implementation support sleep/awake
>> triggers? (or at least quiet elements?)
>
> Nope. All powersaving the device does is done on the device as it
> knows best what parts of the device can be put to sleep. Who or what
> is going to fire those triggers?

What I basically mean here to force the wifi interface stay quiet (or
sleep) for a certain duration of time (the way Notice of Absence
protocol proposes or 802.11h's Quiet Element does). For example, the
ath5k driver  supports quiet elements and the card offers registers
that can be edited within the driver to force a station be quiet for a
certain duration at certain intervals of time. A (local) test
implementation i've performed on ath5k "understands" the NoA IE from a
beacon and edits those registers accordingly in order to stay quiet
accordingly for powersaving purposes.

For the case of a potential BCM4329 implementation of NoA, the
brcmfmac should be the one to trigger those scheduled quiet intervals
on the HW (or is there a lower layer to interface the HW?) when it
receives each beacon NoA IE.

Thanks again, and excuses for my vague knowledge on the bcm4329 drivers.
Andrés

>
>> Thanks for your answer,
>> Andrés
>
> Hope that helps.
>
> Gr. AvS
>
>
