Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:53721 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZH1D5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 23:57:50 -0400
Received: by iwn42 with SMTP id 42so826337iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 20:57:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0908272001u1a67cbf3ycc5d9588dd48915d@mail.gmail.com>
References: <20090827023000.21926.90867.stgit@mj.roinet.com>
	<40f31dec0908270558y2a3a565bvcc7e470b7f2644c6@mail.gmail.com>
	<b6c5339f0908271117q3a893d4dma9df0ac441091dbf@mail.gmail.com>
	<43e72e890908271125x378da3abw41e7f73dd8fbfe81@mail.gmail.com>
	<40f31dec0908272001u1a67cbf3ycc5d9588dd48915d@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 27 Aug 2009 20:57:32 -0700
Message-ID: <43e72e890908272057s28ee11c6x624e8a08c6bd17e9@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix uninitialized value use in
	ath5k_eeprom_read_turbo_modes()
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Bob Copeland <bcopeland@gmail.com>, Pavel Roskin <proski@gnu.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 27, 2009 at 8:01 PM, Nick Kossifidis<mickflemm@gmail.com> wrote:
> 2009/8/27 Luis R. Rodriguez <mcgrof@gmail.com>:
>> On Thu, Aug 27, 2009 at 11:17 AM, Bob Copeland<bcopeland@gmail.com> wrote:
>>> On Thu, Aug 27, 2009 at 8:58 AM, Nick Kossifidis<mickflemm@gmail.com> wrote:
>>>> 2009/8/27 Pavel Roskin <proski@gnu.org>:
>>>
>>>> Current code works fine (i 've checked it against various cards),
>>>> there is nothing wrong
>>>> with having another function for reading turbo modes, i find it's
>>>> cleaner that way.
>>>
>>> Well, we also don't use the turbo modes at all and that's where the
>>> error is (IIRC) so it shouldn't have any impact. :)
>>
>> Again, why don't we just remove all that fucking turbo cruft?
>>
>>  Luis
>>
>
> Why should we remove it, we are discussing on implementing channel
> width setting for 5 and 10 MHz channels already so where is the
> problem supporting turbo mode (40MHz) ?

Supporting 5 MHz and 10 MHz channels is very different than supporting
Turbo (40 MHz). 5 MHz and 10 MHz channels seems to be something you
can use as per 802.11, 40 MHz "Turbo" stuff is just a vendor extension
and at least by my part I don't want to move a finger to either
support it nor do I think its a good idea to support it. Other people
have objected to vendor extensions before on mac80211 so I don't think
you'll find much support for this from a lot of people.

The way I see is if you want vendor extensions like Atheros Turbo or
XR use MadWifi.

> Also EEPROM code should read the eeprom and fill the structs, since
> these infos are there we should read them, i don't see any reason to
> skip them

I didn't see Bob's patch remove that stuff. Its pointless to use it though.

> i thought our goal was to support this hw as much as
> possible,

We should support users as best as possible, whether or not you
support vendor extensions is an entirely different story.

> if we want to get rid of MadWiFi we 'll have to at least
> support 5, 10 and 40MHz (turbo) channels.

I don't want to get rid of MadWifi, what we have now is a proper
upstream replacement. MadWifi is still a hack put together, and people
who want hacks can use that.

> I understand that there is
> no support yet on mac80211/cfg80211 but i don't think removing all
> this stuff and bring it back is the right thing to do.

I don't expect it will come back.

  Luis
