Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:13381 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbYFONrf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 09:47:35 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3973077waf.23
        for <linux-wireless@vger.kernel.org>; Sun, 15 Jun 2008 06:47:32 -0700 (PDT)
Message-ID: <1ba2fa240806150647mdc97d98oad0b1b02de1fcf87@mail.gmail.com> (sfid-20080615_154738_279895_6BFA7D2B)
Date: Sun, 15 Jun 2008 16:47:32 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with disable_hw_scan=1
Cc: "=?ISO-8859-1?Q?Tor_H=E5kon_Haugen?=" <tor.hakon.haugen@gmail.com>,
	"Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <48551C62.80904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <484FEA26.1040305@gmail.com>
	 <1213241315.7814.696.camel@debian.sh.intel.com>
	 <20080612135936.GA5031@tuxdriver.com>
	 <1213342523.7814.865.camel@debian.sh.intel.com>
	 <20080613130310.GA5333@tuxdriver.com> <48528B63.5030403@gmail.com>
	 <48528CF0.8050204@gmail.com>
	 <1ba2fa240806131304n442972eatfd2f35034476c380@mail.gmail.com>
	 <48551C62.80904@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 15, 2008 at 4:42 PM, Maxim Levitsky <maximlevitsky@gmail.co=
m> wrote:
> Tomas Winkler wrote:
>>
>> On Fri, Jun 13, 2008 at 6:06 PM, Maxim Levitsky <maximlevitsky@gmail=
=2Ecom>
>> wrote:
>>>
>>> Tor H=E5kon Haugen wrote:
>>>>
>>>> John W. Linville wrote:
>>>>>
>>>>> On Fri, Jun 13, 2008 at 03:35:23PM +0800, Zhu Yi wrote:
>>>>>>
>>>>>> On Thu, 2008-06-12 at 09:59 -0400, John W. Linville wrote:
>>>>>>>
>>>>>>> Honestly I'm tempted to change it to "enable_hw_scan" instead..=
=2E
>>>>>>
>>>>>> Give the advantages, I'd like to use it if we can fix the bug (I
>>>>>> haven't
>>>>>> seen what the bug is myself). But you are free to change the def=
ault
>>>>>> value until it is fixed. There is no such problem for 4965, righ=
t?
>>>>>
>>>>> AFAICT only the 3945 seems to need it.
>>>>>
>>>> I can confirm that this also applies to 4965 as a friend of mine h=
as
>>>> this card. According to him the card works a lot better with the
>>>> parameters "swcrypto=3D1" and "disable_hw_scan=3D1".
>>>
>>> Just to make it clear,
>>> iwl3945 doesn't work at all without disable_hw_scan=3D1 here.
>>> The driver just shuts down thee card since it detects microcode err=
or.
>>>
>>
>> It looks like this is all caused by the big rate, band patch. Looks
>> like A band scan channels are not configured correctly for the
>> scanning. This crashes the firmware.
>>
>> Tomas
>
> Probably, I see that eeprom according to dmesg contains no info about=
 A
> channels, so maybe this crashes the firmware.
>

Can you please send your dmesg.

> I have few questions:
>
> * Is there a software workaround without the need to update the firmw=
are?

Yes

> * Is the firmware error so harmful, so driver can't continue?

This is firmware misconfiguration.  Driver should be friendly to
firmware and use correctly API.

> * Can I expect updated version of the firmware with  fix?

No need so far.

> Sadly this confirms that firmware is worse that I thought, it is clos=
er to
> closed drivers.

The firmware API is open, it just wasn't used correctly.

> (Although intel isn't guilty in this case due to regulations.)

Thanks
Tomas
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
