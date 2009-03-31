Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:54297 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758510AbZCaIPG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 04:15:06 -0400
Received: by ewy9 with SMTP id 9so2421865ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 01:15:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200903301729.28132.rossi.f@inwind.it>
References: <20090315202035.GC5246@makis>
	 <200903292204.44260.rossi.f@inwind.it>
	 <40f31dec0903291423s384a98b5l8f86b317aeb5c9a4@mail.gmail.com>
	 <200903301729.28132.rossi.f@inwind.it>
Date: Tue, 31 Mar 2009 11:15:03 +0300
Message-ID: <40f31dec0903310115k247ff208ved52293bda56185a@mail.gmail.com> (sfid-20090331_101525_756083_303C57D1)
Subject: Re: [PATCH 3/3] ath5k: Add tx power calibration support
From: Nick Kossifidis <mickflemm@gmail.com>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/30 Fabio Rossi <rossi.f@inwind.it>:
> On Sunday 29 March 2009, Nick Kossifidis wrote:
>
>> This patch introduces a function (and some helpers) to set 2 tables =
on
>> hardware, it doesn't mess with the rest of the driver. I've tested i=
t
>> both on sta and ap scenarios with all the cards i have available and
>> it worked fine. If you want to make more tests just disable parts of
>> hw_txpower on phy.c, you can start by commenting out everything =C2=A0=
below
>>
>> ath5k_setup_rate_powertable(ah, txpower, &rate_info, ee_mode);
>>
>> to skip the setting of tx power, if you comment out the whole functi=
on
>> you'll disable the functionality that this patch adds.
>
> I have discovered the problem. Inside ath5k_hx_txpower() it's called
> ath5k_setup_channel_powertable() where the gain curves of frequency
> piers are scanned (if I have understood correctly) to extract the dat=
a for
> the calibration of the current channel.
>
> In particular, for the 5180MHz channel (the first of the A band), the=
 function
> ath5k_get_linear_pcdac_min() is called with some critical data which =
generate
> an endless while loop.
>
> Here are the bad numbers passed to ath5k_get_linear_pcdac_min():
> * pwrL[0] =3D 4
> * pwrL[1] =3D 4
> * stepL[0] =3D 20
> * stepL[1] =3D 35
> and with this configuration the variable 'tmp' is never decremented i=
nside the
> first while loop.
>
> I suppose the data comes from the EEPROM. Is there an easy way to rea=
d the
> contents of the EEPROM regarding the calibration data for all the cha=
nnels?
>
> Fabio
>

Nice catch ;-)

It's weird that your EEPROM contains a value twice, both pwrL[0] and
pwrL[1] are 4 so interpolation always returns 4 and tmp is always > 1
so you have an endless loop. This is not what we expect to have on
EEPROM (we are supposed to have a monotonicaly increasing curve and in
your case it should be almost linear). Anyway since we have such cards
we just need to put a check there and where pwrL[0] =3D=3D pwrL[1], we =
set
tmp =3D stepL[0] or if pwrR[0] =3D=3D pwrR[1], we set tmp =3D stepR[0].=
 Try
this out and see how it goes...


--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
