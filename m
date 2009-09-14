Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from correio.ufra.edu.br ([200.129.150.6]:60386 "EHLO
	correio.ufra.edu.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbZINQrb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 12:47:31 -0400
Received: from localhost (localhost [127.0.0.1])
	by correio.ufra.edu.br (Postfix) with ESMTP id 8A9B47A58E
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 13:50:09 -0300 (BRT)
Received: from correio.ufra.edu.br ([127.0.0.1])
	by localhost (correio.ufra.edu.br [127.0.0.1]) (amavisd-new, port 10025)
	with LMTP id TVaq1n3kzX9r for <linux-wireless@vger.kernel.org>;
	Mon, 14 Sep 2009 13:50:00 -0300 (BRT)
Received: from [192.168.0.100] (srv2.ufra.edu.br [200.129.150.5])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by correio.ufra.edu.br (Postfix) with ESMTP id 3F2107A58D
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 13:50:00 -0300 (BRT)
Message-ID: <4AAE7395.1050502@ufra.edu.br>
Date: Mon, 14 Sep 2009 13:47:17 -0300
From: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: zd1211rw on ppc (iBook G4) -- Solved, somewhat)
References: <4A9BFCCB.6040808@ufra.edu.br> <3ace41890908311025r3ce83c12gd6aeace4833609b1@mail.gmail.com> 	<4A9C0ADC.6050607@ufra.edu.br> <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com> 	<4A9D7DC0.6050701@ufra.edu.br> <4AAC240E.20104@ufra.edu.br> 	<3ace41890909130313y474074ecnc5e720f780a4bd8f@mail.gmail.com> 	<3ace41890909132041w2d3f10b7r72e0eb855f1ab2a5@mail.gmail.com> <43e72e890909132109l4b47431cw85cfba21ec1fb42c@mail.gmail.com>
In-Reply-To: <43e72e890909132109l4b47431cw85cfba21ec1fb42c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Sun, Sep 13, 2009 at 8:41 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
>   
>> On Sun, Sep 13, 2009 at 11:13 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
>>     
>>> On Sat, Sep 12, 2009 at 11:43 PM, Leonardo H. Souza Hamada
>>> <leonardo.hamada@ufra.edu.br> wrote:
>>>       
>>>> Hi all,
>>>>
>>>> At this moment, after tweaking the zd1211rw code in kernel
>>>> 2.6.31-gentoo, finally I am able to use the WLI-U2-KG54L wireless usb
>>>> dongle on this old ibook.
>>>>
>>>> Browsing the source with a cross referencing tool
>>>> (http://lxr.free-electrons.com) and making additional checking points, I
>>>> could trace the issue as follow.
>>>>
>>>> The problem is that this device returns a regulatory region of 0x49,
>>>> which is not defined in the zd1211rw tables. So the call
>>>>
>>>> r <http://lxr.free-electrons.com/ident?i=r> = zd_reg2alpha2 <http://lxr.free-electrons.com/ident?i=zd_reg2alpha2>(mac <http://lxr.free-electrons.com/ident?i=mac>->regdomain, alpha2);
>>>>
>>>> will fail the initialization process.
>>>>
>>>>
>>>> Workaround:
>>>>
>>>> ----snip----
>>>> int zd_mac_init_hw(struct ieee80211_hw *hw)
>>>> {
>>>> ...
>>>>        r = zd_read_regdomain(chip, &default_regdomain);
>>>>        /* A unknown regulatory of 0x49 will be set default to
>>>> ZD_REGDOMAIN_FCC. */
>>>>        if (0x49 == default_regdomain)
>>>>                default_regdomain = ZD_REGDOMAIN_FCC;
>>>> ...
>>>> ----snip----
>>>>
>>>> The above code will force the default regulatry to be FCC code for this
>>>> case. I think that this was the case in previous zd1211rw driver. What
>>>> is the country code for 0x49 region? There is a better way?
>>>>
>>>>
>>>> Thanks all,
>>>>
>>>> Phew!! Leonardo
>>>>         
>>> The vendor driver has quite a lot more regdomain code defined, and
>>> 0x49 is apparently
>>>
>>> ZD_Region_Japan_3           = 0x49,//G channel->ch1-13; A channel->8~16,34~46;
>>>
>>> the rw driver code probably should set it to most restrictive than let
>>> it fail...
>>>
>>>       
>> Can you give this patch a try against a recent
>> wireless-testing/compat-wireless? I think this is the correct way to
>> do things.
>>
>> Here is the content of the patch for others who doesn't like
>> attachments - it just sets 0x49 as Japan.
>> ==============================
>> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c
>> b/drivers/net/wireless/zd1211rw/zd_mac.c
>> index 6d66635..b0d32c4 100644
>> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
>> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
>> @@ -42,6 +42,7 @@ static struct zd_reg_alpha2_map reg_alpha2_map[] = {
>>        { ZD_REGDOMAIN_ETSI, "DE" }, /* Generic ETSI, use most restrictive */
>>        { ZD_REGDOMAIN_JAPAN, "JP" },
>>        { ZD_REGDOMAIN_JAPAN_ADD, "JP" },
>> +       { ZD_REGDOMAIN_JAPAN_3, "JP" },
>>        { ZD_REGDOMAIN_SPAIN, "ES" },
>>        { ZD_REGDOMAIN_FRANCE, "FR" },
>>  };
>> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h
>> b/drivers/net/wireless/zd1211rw/zd_mac.h
>> index 7c27591..9701935 100644
>> --- a/drivers/net/wireless/zd1211rw/zd_mac.h
>> +++ b/drivers/net/wireless/zd1211rw/zd_mac.h
>> @@ -193,6 +193,7 @@ struct zd_mac {
>>  #define ZD_REGDOMAIN_FRANCE    0x32
>>  #define ZD_REGDOMAIN_JAPAN_ADD 0x40
>>  #define ZD_REGDOMAIN_JAPAN     0x41
>> +#define ZD_REGDOMAIN_JAPAN_3   0x49
>>     
>
> FWIW, this does seem right.
>
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
*
Ok, got *compat-wireless-2.6.tar.bz2
<http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2>*
"bleeding edge compat-wireless" from* here:
http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2

Steps done, so so:

tar -xjf compat-wireless-2.6.tar.bz2
cd compat-wireless-2009-09-14/
cp -v ../zd1211rw_jp3.diff .
`../zd1211rw_jp3.diff' -> `./zd1211rw_jp3.diff'
patch -p1 < zd1211rw_jp3.diff
patching file drivers/net/wireless/zd1211rw/zd_mac.c
patching file drivers/net/wireless/zd1211rw/zd_mac.h
./scripts/driver-select zd1211rw
Processing new driver-select request...
Backing up makefile: Makefile.bk
Backing up makefile: drivers/net/wireless/Makefile.bk
Backing up makefile: net/wireless/Makefile.bk
Backing up makefile: drivers/ssb/Makefile.bk
Backing up makefile: drivers/net/usb/Makefile.bk
Backing up makefile: drivers/misc/eeprom/Makefile.bk

make
/home/leo/compat-wireless-2009-09-14/config.mk:17: *** "ERROR: you have
MAC80211 compiled into the kernel, CONFIG_MAC80211=y, as such you cannot
replace its mac80211 driver. You need this set to CONFIG_MAC80211=m. If
you are using Fedora upgrade your kernel as later version should this
set as modular. For further information on Fedora see
https://bugzilla.redhat.com/show_bug.cgi?id=470143. If you are using
your own kernel recompile it and make mac80211 modular".  Pare.

<<<Disabling original zd1211rw in kernel configuration, recompiled
kernel as instructed above, installed new kernel, reboot, many times
until I got it right>>>


Results:

dmesg seems ok. no errors.

can do iwlist wlan0

iwconfig wlan0 shows:
IEEE 802.11bg  Mode:Managed  Access Point: Not-Associated  
          Tx-Power=20 dBm  
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off


I do not seem to be able to connect to a given access point so far. LED
does not blink.

It can be that there is a query on the new values against other. Just a
guess.


Regards,
Leonardo

