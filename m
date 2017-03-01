Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:37721 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbdCAJcW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Mar 2017 04:32:22 -0500
Received: by mail-it0-f43.google.com with SMTP id 203so26737166ith.0
        for <linux-wireless@vger.kernel.org>; Wed, 01 Mar 2017 01:30:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPK922czwT9jmpkn0xXGJxwL74hzsKWjxkYEhZf15v2oHKPV3g@mail.gmail.com>
References: <CAPK922czwT9jmpkn0xXGJxwL74hzsKWjxkYEhZf15v2oHKPV3g@mail.gmail.com>
From: Julien Massot <jmassot@softbankrobotics.com>
Date: Wed, 1 Mar 2017 10:03:20 +0100
Message-ID: <CADGp=Qd+X4K1j4OV+Gio6EMWMNtvh_WyOzBcrau-y6PUUczrVg@mail.gmail.com> (sfid-20170301_103229_176239_98199E62)
Subject: Re: ath9k driver : Support for Continuous Test Tone mode
To: Senthilganapathy Paramasivam <senthilgp2020@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Senthil,

On Tue, Feb 28, 2017 at 9:02 PM, Senthilganapathy Paramasivam
<senthilgp2020@gmail.com> wrote:
>
> Hi ,
> One of our wireless embedded product is operating on Linux Kernel : 3.12.=
19.
>
> This product has a 802.11 a/b/g/n Full-size Mini PCIe Card
> EWM-W158F01E Which is based on atheros AR9592-AR1B Chipset. ath9k
> driver supports this chip set.
>
> One of the compliance testing requirement is :
> In the minimum transfer rate for power measurements, and at the
> maximum rate for the other measurements, with the transmitter
> operating with continuous transmission.
>
> I am looking for the test mode support in ath9k driver and user space
> utility to invoke the test mode.
>
> 1. Configuring the atheros 9k driver in CONFIG_ATH9K_TX99 test mode
> https://github.com/torvalds/linux/commit/ef6b19e40f525777a0052956bf7d9a19=
85f74993
> as per the log message the supported kernel is from 3.14-rc1
> Latest Kernel 3.12.70 also does not have support for TX99 mode.

You may want to try backport driver
https://backports.wiki.kernel.org/index.php/Main_Page


>
>
> 2. User space utility to send the continuous tone
> Some of the references using a special tool called Atheros test tool
> for the user space utility.
>   There is a reference to a windows based utility "Atheros Radio test too=
l".
>   Some documents refer to linux based atheros test tool but they are
> based on wireless extensions.
>   Searching for a similar utility did not yield any results.



Please take a look at this commit message
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
=3D89f927af7f3389e20c8ad24abfb3d1369f3ffc10

I tested it successfully using an AR9462 adapter and a kernel 4.0.

>From what I understood from tx99_power parameter
doing;
echo 10 > /sys/kernel/debug/ieee80211/phy0/ath9k/tx99_power
will set the tx power to 5 dBm

Please try this shell script:
http://pastebin.com/ANZwVmbp

./test-wifi.sh 1 HT40+
First arg is the channel number,second one is the HT mode.
This script set the txpower to 20dBm.

I'm almost sure that there is a version of ART for Linux somewhere but you
may need to sign NDA, or special licence with QCA.

Best Regards,
Julien

--=20





*This email and any attachment thereto are confidential and intended solely=
=20
for the use of the individual or entity to whom they are addressed.If you=
=20
are not the intended recipient, please be advised that disclosing, copying,=
=20
distributing or taking any action in reliance on the contents of this email=
=20
is strictly prohibited. In such case, please immediately advise the sender,=
=20
and delete all copies and attachment from your system.This email shall not=
=20
be construed and is not tantamount to an offer, an acceptance of offer, or=
=20
an agreement by SoftBank Robotics Europe on any discussion or contractual=
=20
document whatsoever. No employee or agent is authorized to represent or=20
bind SoftBank Robotics Europe to third parties by email, or act on behalf=
=20
of SoftBank Robotics Europe by email, without express written confirmation=
=20
by SoftBank Robotics Europe=E2=80=99 duly authorized representatives.*
------------------------------




*Ce message =C3=A9lectronique et =C3=A9ventuelles pi=C3=A8ces jointes sont =
confidentiels,=20
et exclusivement destin=C3=A9s =C3=A0 la personne ou l'entit=C3=A9 =C3=A0 q=
ui ils sont=20
adress=C3=A9s.Si vous n'=C3=AAtes pas le destinataire vis=C3=A9, vous =C3=
=AAtes pri=C3=A9 de ne pas=20
divulguer, copier, distribuer ou prendre toute d=C3=A9cision sur la foi de =
ce=20
message =C3=A9lectronique. Merci d'en aviser imm=C3=A9diatement l'exp=C3=A9=
diteur et de=20
supprimer toutes les copies et =C3=A9ventuelles pi=C3=A8ces jointes de votr=
e=20
syst=C3=A8me.Ce message =C3=A9lectronique n'=C3=A9quivaut pas =C3=A0 une of=
fre, =C3=A0 une=20
acceptation d=E2=80=99offre, ou =C3=A0 un accord de SoftBank Robotics Europ=
e sur toute=20
discussion ou document contractuel quel qu=E2=80=99il soit, et ne peut =C3=
=AAtre=20
interpr=C3=A9t=C3=A9 comme tel. Aucun employ=C3=A9 ou agent de SoftBank Rob=
otics Europe=20
n'est autoris=C3=A9 =C3=A0 repr=C3=A9senter ou =C3=A0 engager la soci=C3=A9=
t=C3=A9 par email, ou =C3=A0 agir=20
au nom et pour le compte de la soci=C3=A9t=C3=A9 par email, sans qu=E2=80=
=99une confirmation=20
=C3=A9crite soit donn=C3=A9e par le repr=C3=A9sentant l=C3=A9gal de SoftBan=
k Robotics Europe ou=20
par toute autre personne ayant re=C3=A7u d=C3=A9l=C3=A9gation de pouvoir ap=
propri=C3=A9e.*
