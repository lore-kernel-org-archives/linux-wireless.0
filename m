Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:33414 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754152AbdCFXnT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 18:43:19 -0500
Received: by mail-ot0-f175.google.com with SMTP id 19so53978454oti.0
        for <linux-wireless@vger.kernel.org>; Mon, 06 Mar 2017 15:42:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADGp=QdoLDarssMn1c8iYOkGqevhYB09se5dKsm87OTvNCU-Tw@mail.gmail.com>
References: <CAPK922czwT9jmpkn0xXGJxwL74hzsKWjxkYEhZf15v2oHKPV3g@mail.gmail.com>
 <CADGp=QdoLDarssMn1c8iYOkGqevhYB09se5dKsm87OTvNCU-Tw@mail.gmail.com>
From: Senthilganapathy Paramasivam <senthilgp2020@gmail.com>
Date: Mon, 6 Mar 2017 16:43:53 -0600
Message-ID: <CAPK922dZW7UEpmQBy+ZAg1JoDp-GGf5PK57Ewtc-PMLYNLUREg@mail.gmail.com> (sfid-20170307_004402_528195_107322A7)
Subject: Re: ath9k driver : Support for Continuous Test Tone mode
To: Julien Massot <jmassot@softbankrobotics.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julien,

Thanks so much for the pointers.

I back ported the patch at
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
=3D89f927af7f3389e20c8ad24abfb3d1369f3ffc10
to the 3.12 kernel.

Now able to set the tx99 mode and configure the moni0 interface.

But I am not seeing any activity through the interface

moni0     Link encap:UNSPEC  HWaddr
00-0E-8E-45-02-DD-10-0B-00-00-00-00-00-00-00-00
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

Is there any test firmware to be placed at /lib/firmware/ ?

Thanks
Senthil


On Wed, Mar 1, 2017 at 2:59 AM, Julien Massot
<jmassot@softbankrobotics.com> wrote:
> Hi Senthil,
>
>
> On Tue, Feb 28, 2017 at 9:02 PM, Senthilganapathy Paramasivam
> <senthilgp2020@gmail.com> wrote:
>>
>> Hi ,
>> One of our wireless embedded product is operating on Linux Kernel :
>> 3.12.19.
>>
>> This product has a 802.11 a/b/g/n Full-size Mini PCIe Card
>> EWM-W158F01E Which is based on atheros AR9592-AR1B Chipset. ath9k
>> driver supports this chip set.
>>
>> One of the compliance testing requirement is :
>> In the minimum transfer rate for power measurements, and at the
>> maximum rate for the other measurements, with the transmitter
>> operating with continuous transmission.
>>
>> I am looking for the test mode support in ath9k driver and user space
>> utility to invoke the test mode.
>>
>> 1. Configuring the atheros 9k driver in CONFIG_ATH9K_TX99 test mode
>>
>> https://github.com/torvalds/linux/commit/ef6b19e40f525777a0052956bf7d9a1=
985f74993
>> as per the log message the supported kernel is from 3.14-rc1
>> Latest Kernel 3.12.70 also does not have support for TX99 mode.
>
>
> You may want to try backport driver
> https://backports.wiki.kernel.org/index.php/Main_Page
>
>>
>> 2. User space utility to send the continuous tone
>> Some of the references using a special tool called Atheros test tool
>> for the user space utility.
>>   There is a reference to a windows based utility "Atheros Radio test
>> tool".
>>   Some documents refer to linux based atheros test tool but they are
>> based on wireless extensions.
>>   Searching for a similar utility did not yield any results.
>
>
> Please take a look at this commit message
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
=3D89f927af7f3389e20c8ad24abfb3d1369f3ffc10
>
> I tested it successfully using an AR9462 adapter and a kernel 4.0.
>
> From what I understood from tx99_power parameter
> doing;
> echo 10 > /sys/kernel/debug/ieee80211/phy0/ath9k/tx99_power
> will set the tx power to 5 dBm
>
> http://pastebin.com/ANZwVmbp
>
>
> I'm almost sure that there is a version of ART for Linux somewhere but yo=
u
> may need to sign NDA, or special licence with QCA.
>
> Best Regards,
> Julien
>
>
>
>
> This email and any attachment thereto are confidential and intended solel=
y
> for the use of the individual or entity to whom they are addressed.
> If you are not the intended recipient, please be advised that disclosing,
> copying, distributing or taking any action in reliance on the contents of
> this email is strictly prohibited. In such case, please immediately advis=
e
> the sender, and delete all copies and attachment from your system.
> This email shall not be construed and is not tantamount to an offer, an
> acceptance of offer, or an agreement by SoftBank Robotics Europe on any
> discussion or contractual document whatsoever. No employee or agent is
> authorized to represent or bind SoftBank Robotics Europe to third parties=
 by
> email, or act on behalf of SoftBank Robotics Europe by email, without
> express written confirmation by SoftBank Robotics Europe=E2=80=99 duly au=
thorized
> representatives.
>
> ________________________________
>
> Ce message =C3=A9lectronique et =C3=A9ventuelles pi=C3=A8ces jointes sont=
 confidentiels, et
> exclusivement destin=C3=A9s =C3=A0 la personne ou l'entit=C3=A9 =C3=A0 qu=
i ils sont adress=C3=A9s.
> Si vous n'=C3=AAtes pas le destinataire vis=C3=A9, vous =C3=AAtes pri=C3=
=A9 de ne pas divulguer,
> copier, distribuer ou prendre toute d=C3=A9cision sur la foi de ce messag=
e
> =C3=A9lectronique. Merci d'en aviser imm=C3=A9diatement l'exp=C3=A9diteur=
 et de supprimer
> toutes les copies et =C3=A9ventuelles pi=C3=A8ces jointes de votre syst=
=C3=A8me.
> Ce message =C3=A9lectronique n'=C3=A9quivaut pas =C3=A0 une offre, =C3=A0=
 une acceptation
> d=E2=80=99offre, ou =C3=A0 un accord de SoftBank Robotics Europe sur tout=
e discussion ou
> document contractuel quel qu=E2=80=99il soit, et ne peut =C3=AAtre interp=
r=C3=A9t=C3=A9 comme tel.
> Aucun employ=C3=A9 ou agent de SoftBank Robotics Europe n'est autoris=C3=
=A9 =C3=A0
> repr=C3=A9senter ou =C3=A0 engager la soci=C3=A9t=C3=A9 par email, ou =C3=
=A0 agir au nom et pour le
> compte de la soci=C3=A9t=C3=A9 par email, sans qu=E2=80=99une confirmatio=
n =C3=A9crite soit donn=C3=A9e
> par le repr=C3=A9sentant l=C3=A9gal de SoftBank Robotics Europe ou par to=
ute autre
> personne ayant re=C3=A7u d=C3=A9l=C3=A9gation de pouvoir appropri=C3=A9e.
