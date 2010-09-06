Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc1-s14.bay0.hotmail.com ([65.54.190.25]:59230 "EHLO
	bay0-omc1-s14.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119Ab0IFFNy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 01:13:54 -0400
From: Sushil DUTT <sdutt@our.ecu.edu.au>
To: =?iso-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: Bob Copeland <me@bobcopeland.com>, jpo <pommnitz@yahoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: RE: mac80211-based commercial router?
Date: Mon, 6 Sep 2010 05:12:56 +0000
Message-ID: <47710AF097913A429588DDC29B060B83032FB9@SINPRD0103MB052.apcprd01.prod.exchangelabs.com>
References: <AANLkTim_Ou8fFbfsn8AEZFpWBzjnAQuT4S_w8bV5saYD@mail.gmail.com>
 <loom.20100903T224155-155@post.gmane.org>
 <AANLkTikdXBsO0Qx2nEV+Ka9X2D55odmGwePMaUGaQi7j@mail.gmail.com>
 <AANLkTinu_4tsfJ=0CXS7yuuiqw0X5juqjP_T_edw0b4Y@mail.gmail.com>
 <AANLkTi=aJssChg0uiEec-Pa=3oOdc3cFoee1X7U7BWwF@mail.gmail.com>,<AANLkTimVRPTRdMe-pEusXxCiZXjPPWSFfXY7CRiyRazj@mail.gmail.com>
In-Reply-To: <AANLkTimVRPTRdMe-pEusXxCiZXjPPWSFfXY7CRiyRazj@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Friends,

I saw in this thread that Athreos Ath9k is based on mac80211. Any idea, from where I can get this development kit? This kit seems perfect for my WLAN solution:)

To give a background about my project,
Our lab has developed a WLAN solution which shows better results(in comaprision of mkt available solutions) in simulation. Now my job is to embedd & prove this solution in a stable hardware environment. I need a platform with SDK which can support both AP & Station. Reference application is highly desirable to reduce my development time.

Thanks in advance for your responses.


Thanks & Regards,
Sushil Dutt
Centre for Communications Engineering Research
School of Engineering
Edith Cowan University
100 Joondalup Drive, Joondalup WA 6027, Australia.
Telephone: (61 8) 6304 5318 or (61 8) 6304 5458
Fax: (61 8) 6304 5811


________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] on behalf of Gábor Stefanik [netrolller.3d@gmail.com]
Sent: Monday, September 06, 2010 7:29 AM
To: Björn Smedman
Cc: Bob Copeland; jpo; linux-wireless@vger.kernel.org; Luis R. Rodriguez
Subject: Re: mac80211-based commercial router?

2010/9/6 Björn Smedman <bjorn.smedman@venatech.se>:
> 2010/9/6 Gábor Stefanik <netrolller.3d@gmail.com>:
>> On Sun, Sep 5, 2010 at 10:08 PM, Bob Copeland <me@bobcopeland.com> wrote:
>>> On Fri, Sep 3, 2010 at 4:43 PM, jpo <pommnitz@yahoo.com> wrote:
>>>
>>>> Android 2.2 comes with AP functionality. Are the Android WLAN drivers mac80211
>>>> based?
>>>
>>> No, they aren't.  Does Android really do AP mode or
>>> just adhoc?
>>>
>>> wl1251 is an in-tree module for the TI chip used in G1,
>>> but it doesn't support AP mode.  I do not know if there's
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
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html