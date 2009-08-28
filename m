Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:41365 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZH1DBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 23:01:47 -0400
Received: by ewy2 with SMTP id 2so1787212ewy.17
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 20:01:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890908271125x378da3abw41e7f73dd8fbfe81@mail.gmail.com>
References: <20090827023000.21926.90867.stgit@mj.roinet.com>
	 <40f31dec0908270558y2a3a565bvcc7e470b7f2644c6@mail.gmail.com>
	 <b6c5339f0908271117q3a893d4dma9df0ac441091dbf@mail.gmail.com>
	 <43e72e890908271125x378da3abw41e7f73dd8fbfe81@mail.gmail.com>
Date: Fri, 28 Aug 2009 06:01:48 +0300
Message-ID: <40f31dec0908272001u1a67cbf3ycc5d9588dd48915d@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix uninitialized value use in
	ath5k_eeprom_read_turbo_modes()
From: Nick Kossifidis <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bob Copeland <bcopeland@gmail.com>, Pavel Roskin <proski@gnu.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/27 Luis R. Rodriguez <mcgrof@gmail.com>:
> On Thu, Aug 27, 2009 at 11:17 AM, Bob Copeland<bcopeland@gmail.com> wrote:
>> On Thu, Aug 27, 2009 at 8:58 AM, Nick Kossifidis<mickflemm@gmail.com> wrote:
>>> 2009/8/27 Pavel Roskin <proski@gnu.org>:
>>
>>> Current code works fine (i 've checked it against various cards),
>>> there is nothing wrong
>>> with having another function for reading turbo modes, i find it's
>>> cleaner that way.
>>
>> Well, we also don't use the turbo modes at all and that's where the
>> error is (IIRC) so it shouldn't have any impact. :)
>
> Again, why don't we just remove all that fucking turbo cruft?
>
>  Luis
>

Why should we remove it, we are discussing on implementing channel
width setting for 5 and 10 MHz channels already so where is the
problem supporting turbo mode (40MHz) ?

Also EEPROM code should read the eeprom and fill the structs, since
these infos are there we should read them, i don't see any reason to
skip them, i thought our goal was to support this hw as much as
possible, if we want to get rid of MadWiFi we 'll have to at least
support 5, 10 and 40MHz (turbo) channels. I understand that there is
no support yet on mac80211/cfg80211 but i don't think removing all
this stuff and bring it back is the right thing to do.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
