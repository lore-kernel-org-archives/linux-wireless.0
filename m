Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63241 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab0CATAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 14:00:14 -0500
Received: by pwj8 with SMTP id 8so1838729pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 11:00:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201003011927.53208.helmut.schaa@googlemail.com>
References: <201002281534.11656.helmut.schaa@googlemail.com>
	<1267465615.2253.159.camel@rchatre-DESK> <43e72e891003011007p6053aaaewef3a0d639159c120@mail.gmail.com>
	<201003011927.53208.helmut.schaa@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Mar 2010 10:59:54 -0800
Message-ID: <43e72e891003011059v564931e2qfe390657b698c277@mail.gmail.com>
Subject: Re: iwl4965: 11a channels disabled in current wireless-testing
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 1, 2010 at 10:27 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Montag 01 März 2010 schrieb Luis R. Rodriguez:
>> On Mon, Mar 1, 2010 at 9:46 AM, reinette chatre
>> <reinette.chatre@intel.com> wrote:
>> > On Sun, 2010-02-28 at 06:34 -0800, Helmut Schaa wrote:
>> >> have there been any recent changes to the regulatory stuff, especially
>> >> in conjunction with iwlagn?
>> >>
>> >> Because with wireless-testing I get all 11a channels disabled by default
>> >> and the same for channels 12 & 13 in the g-band.
>> >
>> > This could be related to a change in the default regulatory domain. It
>> > used to be US, but now it is world,
>>
>> This change actually happened a while ago and the world regulatory
>> domain actually enables passive scanning on a lot of channels instead
>> of straight out disabling them.
>
> How do channels get disabled then?

In this order:

  * if the Intel card has an EEPROM where certain channels are disabled
  * if you set the country yourself
  * if your AP tells you that you are in a country where certain
channels are disabled

>> > which is more restrictive. You can
>> > modify your regulatory domain using "iw reg set <domain>"
>>
>> For Intel, as well as with Atheros cards, cards using 'iw reg set'
>> would actually not yield enabling new channels, it would only disable
>> channels further.
>
> Right, that's what I can see here as well.
>
> However, I just noticed in dmesg:
>
> iwlagn 0000:10:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
>
> So it seems the card reports the correct set of channels but it doesn't
> get reflected in cfg80211.

You can try to register to nl80211 events after loading cfg80211:

iw event -t

Then load iwlagn and see if you pick anything up. Might want to enable
CFG80211_REG_DEBUG.

  Luis
