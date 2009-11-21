Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 42.mail-out.ovh.net ([213.251.189.42]:54085 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751128AbZKUI5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Nov 2009 03:57:40 -0500
Message-ID: <4B07A9F8.9050306@free.fr>
Date: Sat, 21 Nov 2009 09:51:04 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Jeremy Moles <jeremy@emperorlinux.com>,
	linux-wireless@vger.kernel.org
Subject: Re: iwlagn + Ad-Hoc + 5Ghz
References: <1258756647.2714.17.camel@localhost.localdomain> <43e72e890911201526y5b36328ft3a510e546508df66@mail.gmail.com>
In-Reply-To: <43e72e890911201526y5b36328ft3a510e546508df66@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez a écrit :
> On Fri, Nov 20, 2009 at 2:37 PM, Jeremy Moles <jeremy@emperorlinux.com> wrote:
>> Hello all! I have a group of machine here with an app that needs to set
>> up an ad-hoc network in 5Ghz+ range. The machines themselves are all
>> different (a Panasonic, a Dell, and a Lenovo) but they are all using
>> 5100 cards, a 2.6.31 kernel, and the 2.6.31-rc7 driver from the website.
>>
>> Using the command "iw list" I can get a lot of helpful info, but I see
>> "no IBSS" on any channel over 11, and I'm beginning to think that this
>> just isn't supported on these cards yet.
> 
> No, this has nothing to do not supporting IBSS but instead you should
> read "no IBSS" more as a regulatory rule that implies you cannot use a
> mode of operation that can beacon. We should at least rename this on
> iw for now to make thins clearer.
> 
> What you see should be part of the default rules embedded on the
> device's EEPROM. Beaconing is allowed on channel 11 even on the most
> restrictive regulatory domain and this is why the world regulatory
> domain allows 1-11 to beacon too.
> 
> You should enable debugging on the driver upon load to confirm whether
> this rule is coming from the EEPROM. Do you have
> CONFIG_WIRELESS_OLD_REGULATORY? I think even that (by default it used
> the US) enabled beaconing. Drivers can overrule things though if their
> EEPROM mandates this.
> 
>   Luis

Hello,

I got the same problem with Intel 4965 and Intel 5350 since those cards
are using the same drivers. Like Luis mentionned, "no IBSS" should be
read as "no beaconing authorized by local regulation". However, I think
the iwlagn interpretation is a bit broad and such restrictions should be
done by the CRDA framework instead of the driver itself.

Here in France, IBSS is authorized on all channels. So I made a small
patch to enable the EEPROM_CHANNEL_IBSS flag everywhere (in iwl-core.c
and iwl-dev.h) and it just works.

Will try to post the patch on Monday.

Regards,
Benoit
