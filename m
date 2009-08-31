Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:36097 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbZHaXLf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 19:11:35 -0400
Received: by fg-out-1718.google.com with SMTP id 22so606072fge.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 16:11:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890908311602g4a976ec5k4f1f5145662cf183@mail.gmail.com>
References: <4A9BFCCB.6040808@ufra.edu.br> <4A9C0ADC.6050607@ufra.edu.br>
	<3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com>
	<200908312127.57610.mb@bu3sch.de> <3ace41890908311235i62ab0510neb8b2021c3f2945e@mail.gmail.com>
	<69e28c910908311414s191aafa6ib0bdae8ed4ace27d@mail.gmail.com>
	<3ace41890908311602g4a976ec5k4f1f5145662cf183@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 1 Sep 2009 01:11:17 +0200
Message-ID: <69e28c910908311611t1666370csa55d16a8623f0648@mail.gmail.com>
Subject: Re: zd1211rw on ppc (iBook G4)
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	"Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Restoring CCs from original message.)

2009/9/1 Hin-Tak Leung <hintak.leung@gmail.com>:
> 2009/8/31 Gábor Stefanik <netrolller.3d@gmail.com>:
>> On Mon, Aug 31, 2009 at 9:35 PM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
>>> On Mon, Aug 31, 2009 at 8:27 PM, Michael Buesch<mb@bu3sch.de> wrote:
>>>> On Monday 31 August 2009 20:26:22 Hin-Tak Leung wrote:
>>>>> It would appear that the rw driver's ieee80211->mac80211 conversion
>>>>> has broken big- endian platforms, at a first guess.
>>>>
>>>> Last time I tested the device worked fine on my powerbook with zd1211rw/mac80211.
>>>> But that's maybe two or three release cycles in the past.
>>>>
>>>> --
>>>> Greetings, Michael.
>>>>
>>>
>>> The rw ieee80211->mac80211 conversion happens in 2.6.27->26.28 ...
>>> Iguess the question is whether it was 2.6.28 or 2.6.27 you had success
>>> with? That's unfortunately two *and* three cycles in the past,
>>> respectively :-).
>>
>> I seem to remember that the conversion happened between 2.6.24 and
>> 2.6.25 - the 2.6.26 injection patch on patches.aircrack-ng.org is also
>> clearly for the mac80211 version.
>
> Some part persists till 2.6.28 - I was running git diff between
> different tags like this:
>
> git diff v2.6.27:drivers/net/wireless/zd1211rw/
> v2.6.28:drivers/net/wireless/zd1211rw/
> diff --git a/Makefile b/Makefile
> index cc36126..1907eaf 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,6 +1,6 @@
>  obj-$(CONFIG_ZD1211RW) += zd1211rw.o
>
> -zd1211rw-objs := zd_chip.o zd_ieee80211.o zd_mac.o \
> +zd1211rw-objs := zd_chip.o zd_mac.o \
>                zd_rf_al2230.o zd_rf_rf2959.o \
>                zd_rf_al7230b.o zd_rf_uw2453.o \
>                zd_rf.o zd_usb.o
> diff --git a/zd_chip.c b/zd_chip.c
> index 0acb5c3..e0ac58b 100644
> --- a/zd_chip.c
> +++ b/zd_chip.c
> @@ -28,7 +28,6 @@
>
>  #include "zd_def.h"
>  #include "zd_chip.h"
> -#include "zd_ieee80211.h"
>  #include "zd_mac.h"
>  #include "zd_rf.h"
>

AFAIK that was a cleanup from the changeover to mac80211 - originally,
zd_ieee80211 housed the bindings to ieee80211softmac. After the
conversion to mac80211, some mac80211 bindings ended up in zd_mac, the
others in zd_ieee80211. In 2.6.28, the two files were merged.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
