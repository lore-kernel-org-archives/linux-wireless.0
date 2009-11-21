Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:57851 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbZKUSUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Nov 2009 13:20:08 -0500
Received: by iwn8 with SMTP id 8so3223076iwn.33
        for <linux-wireless@vger.kernel.org>; Sat, 21 Nov 2009 10:20:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B07A9F8.9050306@free.fr>
References: <1258756647.2714.17.camel@localhost.localdomain>
	<43e72e890911201526y5b36328ft3a510e546508df66@mail.gmail.com>
	<4B07A9F8.9050306@free.fr>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 21 Nov 2009 10:19:53 -0800
Message-ID: <43e72e890911211019l4f4ede6bqef71009386467a59@mail.gmail.com>
Subject: Re: iwlagn + Ad-Hoc + 5Ghz
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: Jeremy Moles <jeremy@emperorlinux.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 21, 2009 at 12:51 AM, Benoit PAPILLAULT
<benoit.papillault@free.fr> wrote:
> Luis R. Rodriguez a écrit :
>> On Fri, Nov 20, 2009 at 2:37 PM, Jeremy Moles <jeremy@emperorlinux.com> wrote:
>>> Hello all! I have a group of machine here with an app that needs to set
>>> up an ad-hoc network in 5Ghz+ range. The machines themselves are all
>>> different (a Panasonic, a Dell, and a Lenovo) but they are all using
>>> 5100 cards, a 2.6.31 kernel, and the 2.6.31-rc7 driver from the website.
>>>
>>> Using the command "iw list" I can get a lot of helpful info, but I see
>>> "no IBSS" on any channel over 11, and I'm beginning to think that this
>>> just isn't supported on these cards yet.
>>
>> No, this has nothing to do not supporting IBSS but instead you should
>> read "no IBSS" more as a regulatory rule that implies you cannot use a
>> mode of operation that can beacon. We should at least rename this on
>> iw for now to make thins clearer.
>>
>> What you see should be part of the default rules embedded on the
>> device's EEPROM. Beaconing is allowed on channel 11 even on the most
>> restrictive regulatory domain and this is why the world regulatory
>> domain allows 1-11 to beacon too.
>>
>> You should enable debugging on the driver upon load to confirm whether
>> this rule is coming from the EEPROM. Do you have
>> CONFIG_WIRELESS_OLD_REGULATORY? I think even that (by default it used
>> the US) enabled beaconing. Drivers can overrule things though if their
>> EEPROM mandates this.
>>
>>   Luis
>
> Hello,
>
> I got the same problem with Intel 4965 and Intel 5350 since those cards
> are using the same drivers. Like Luis mentionned, "no IBSS" should be
> read as "no beaconing authorized by local regulation".

That's the case for the cfg80211 / CRDA db regulatory no-ibss flag.

> However, I think
> the iwlagn interpretation is a bit broad and such restrictions should be
> done by the CRDA framework instead of the driver itself.

Its my understanding such a change would require a firmware change,
its not so simple for iwl.

> Here in France, IBSS is authorized on all channels. So I made a small
> patch to enable the EEPROM_CHANNEL_IBSS flag

This may or may not mean no-beaconing, you'd need documentation or
confirmation from someone. Or manual testing against AP / Mesh modes
too.

> everywhere (in iwl-core.c and iwl-dev.h) and it just works.

I'm surprised it works without issues, it is likely you will run into
an issue. I could be wrong though. You may want to test against older
supported firmware as well.

The driver is always giving the last say with regards to regulatory.
Although a savvy technical user may indeed know better current
legislation does not allow for blindly trusting the user and in fact
can potentially penalize for it. As an example you can read the recent
clarification by the FCC regarding selecting your regulatory domain
[1].

So although your change may work your are not considering the fact
that iwl card world roam into different regions and as such they
cannot choose a country or extract it from the card and therefore
cannot just allow everything and let the user select a regulatory
domain. If regulatory agencies start shifting responsibility of
regulatory compliance down to the user then things would be easier,
but we're simply not there yet.

[1] http://wireless.kernel.org/en/developers/Regulatory/CRDA#Helping_compliance_by_allowing_to_change_regulatory_domains

  Luis
