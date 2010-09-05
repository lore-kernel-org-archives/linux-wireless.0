Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35783 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab0IEXaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Sep 2010 19:30:11 -0400
Received: by qwh6 with SMTP id 6so3404965qwh.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Sep 2010 16:30:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=aJssChg0uiEec-Pa=3oOdc3cFoee1X7U7BWwF@mail.gmail.com>
References: <AANLkTim_Ou8fFbfsn8AEZFpWBzjnAQuT4S_w8bV5saYD@mail.gmail.com>
 <loom.20100903T224155-155@post.gmane.org> <AANLkTikdXBsO0Qx2nEV+Ka9X2D55odmGwePMaUGaQi7j@mail.gmail.com>
 <AANLkTinu_4tsfJ=0CXS7yuuiqw0X5juqjP_T_edw0b4Y@mail.gmail.com> <AANLkTi=aJssChg0uiEec-Pa=3oOdc3cFoee1X7U7BWwF@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 6 Sep 2010 01:29:50 +0200
Message-ID: <AANLkTimVRPTRdMe-pEusXxCiZXjPPWSFfXY7CRiyRazj@mail.gmail.com>
Subject: Re: mac80211-based commercial router?
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
Cc: Bob Copeland <me@bobcopeland.com>, jpo <pommnitz@yahoo.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/6 Björn Smedman <bjorn.smedman@venatech.se>:
> 2010/9/6 Gábor Stefanik <netrolller.3d@gmail.com>:
>> On Sun, Sep 5, 2010 at 10:08 PM, Bob Copeland <me@bobcopeland.com> wrote:
>>> On Fri, Sep 3, 2010 at 4:43 PM, jpo <pommnitz@yahoo.com> wrote:
>>>
>>>> Android 2.2 comes with AP functionality. Are the Android WLAN drivers mac80211
>>>> based?
>>>
>>> No, they aren't.  Does Android really do AP mode or
>>> just adhoc?
>>>
>>> wl1251 is an in-tree module for the TI chip used in G1,
>>> but it doesn't support AP mode.  I do not know if there's
>>> a mac80211 driver that supports the broadcom chip used
>>> in other phones.
>>
>> AFAIK BCM4325 should be doable, especially if it is attached via SDIO
>> bus. In phones where SPI is used, it is more problematic, as b43
>> doesn't support SPI.
>>
>
> I guess the short answer is no then; all the chip vendors still focus
> on their own proprietary mac implementations, at least on the AP side.
> Any thoughts on what would be required for them to switch to mac80211?
> Will it ever happen?
>
> /Björn
>

AFAIK, the status is the following:
-Atheros: Ath9k is officially supported and recommended by Atheros,
and is usable for an AP - indeed, I believe Atheros is the first and
only company to officially support a mac80211 driver AND make chipsets
for APs. AFAIK, for the AR9002 family, no other Linux driver is
available (at least not wit 802.11n support). Once we begin seeing
AR9002-based APs with Linux firmware, chances are they will have a
mac80211 driver inside. CCing Luis on this one.
-Broadcom: they refuse to even acknowledge (maybe with the exception
of legal threats) the development of b43, and supply binary drivers
(and a 2.4-series kernel) in their platform kits. Also, b43 is way
behind time when it comes to HW support (it doesn't support N-PHY,
which is the norm now), and usually when APs begin shipping wiht a new
Broadcom chipset, b43 still doesn't support that chipset until much
later. I don't know about APs that include a Broadcom CPU but an
Atheros wireless chip - AFAIK some do exist, but all use madwifi or
some variant.
-Ralink: Again, platform kits contain non-mac80211 drivers, even for
recent chipsets (at least they are open-source, though). Someone
should find a way to make them base drivers for the eventual RT4xxx
(?) chipsets on the rt2x00 framework.
-Marvell: No idea.
-Realtek: Same situation as Ralink.

And some embedded Linux vendors:
-MontaVista: I believe they are still using 2.4.x kernels (though I've
heard of MontaVista-based routers with 2.6.8 - but even that one is
way too old for mac80211.)
-MikroTik: AFAIK RouterOS contains binary drivers with no relation to
their open-source counterparts. They even named their Atheros driver
"ath5k" IIRC, ignoring the in-tree driver with the same name! Plus,
even if it had mac80211-based drivers, it wouldn't matter, since there
is no (legal) way to access a Unix shell in RouterOS; instead it uses
a proprietary "configuration shell" apparently inspired by Cisco IOS
and ZyNOS.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
