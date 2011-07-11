Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45776 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab1GKFbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 01:31:06 -0400
Received: by wyg8 with SMTP id 8so2336466wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jul 2011 22:31:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn2BH9vEjKWui8JuQRufiKgTtBCHyifXCi1OxLMRck1heQ@mail.gmail.com>
References: <CAD2nsn0-FQuo7bT3nb3jJLDe1XwbMw4J-Gr8qFkY5zzY1O-vxg@mail.gmail.com>
	<20110705143029.GA28091@alittletooquiet.net>
	<CAD2nsn1r7cW7KZ2W_z+SURHRpaTvuC_bd42yN9S+y9JrYMkS4w@mail.gmail.com>
	<20110705172022.GB28091@alittletooquiet.net>
	<20110706023943.GA11178@vmraj-lnx.users.atheros.com>
	<CAD2nsn0HFgm6Puuzuy4gghdDvpb05WaQtETS4=mfQ63mFzo--Q@mail.gmail.com>
	<20110706182937.GE28091@alittletooquiet.net>
	<CAD2nsn3x5sfhTuzH66myCF0P2PyHoX+pqVkYgWC5ogssPdHsqw@mail.gmail.com>
	<CAD2nsn03zdg16O3xcAOGRunYm4NG5PqO=1ht4kx39fAXbSpV5A@mail.gmail.com>
	<CAD2nsn3krB2MZYewRtJpFikUu9079jXXMabz90z6Zc7kfAeELw@mail.gmail.com>
	<20110707225321.GG28091@alittletooquiet.net>
	<CAD2nsn2BH9vEjKWui8JuQRufiKgTtBCHyifXCi1OxLMRck1heQ@mail.gmail.com>
Date: Mon, 11 Jul 2011 11:01:04 +0530
Message-ID: <CAD2nsn0UC=dkM-vB7vsawyB-PzgTV=rGzLDRr_5fx3ZQqVJiuQ@mail.gmail.com> (sfid-20110711_073113_378044_942645B1)
Subject: Re: ath9k_htc fails to initialize TL-WN721N with compat-wireless 3.0-rc4-1
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 8, 2011 at 6:54 PM, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
> On Fri, Jul 8, 2011 at 4:23 AM, Forest Bond <forest@alittletooquiet.net> wrote:
>> Hi shafi,
>>
>> On Thu, Jul 07, 2011 at 03:23:50AM -0400, Mohammed Shafi wrote:
>>> attached a reverting patch for LED, did a basic test and looks fine.
>>> need to investigate in this for backporting.  we have not tested in
>>> 2.6.24 kernel
>>
>> Yes, this seems to fix things.  I can bring the interface up now and get
>> scanning results.  I will test further and let you know how things go.
>
> let me quickly check if undefine CONFIG_MAC80211_LEDS in ath9k_htc in
> latest wireless-testing and if i get a lock up or panic

it did not help, got an idea its a locking issue in com pat, I don't
know why its happening for the older kernel. made it working by
commenting out few spinlocks,
>
>>
>> Thanks again for your help.
>>
>> -Forest
>> --
>> Forest Bond
>> http://www.alittletooquiet.net
>> http://www.rapidrollout.com
>>
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG v1.4.10 (GNU/Linux)
>>
>> iEYEARECAAYFAk4WOOEACgkQRO4fQQdv5AxHWgCcCMFdHTo389d6SW9Kp4MF8Ux2
>> MiEAoL6TIP+qdzRTqGspgOQI5JQeAMk9
>> =HFBX
>> -----END PGP SIGNATURE-----
>>
>>
>
>
>
> --
> shafi
>



-- 
shafi
