Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:59738 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZH0XPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 19:15:14 -0400
Received: by iwn42 with SMTP id 42so768935iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 16:15:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090827213921.GB30419@hash.localnet>
References: <20090827023000.21926.90867.stgit@mj.roinet.com>
	<40f31dec0908270558y2a3a565bvcc7e470b7f2644c6@mail.gmail.com>
	<b6c5339f0908271117q3a893d4dma9df0ac441091dbf@mail.gmail.com>
	<43e72e890908271125x378da3abw41e7f73dd8fbfe81@mail.gmail.com>
	<20090827213921.GB30419@hash.localnet>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 27 Aug 2009 16:14:56 -0700
Message-ID: <43e72e890908271614p58feb9bn2130e1c963685a55@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix uninitialized value use in
	ath5k_eeprom_read_turbo_modes()
To: Bob Copeland <me@bobcopeland.com>
Cc: mickflemm@gmail.com, proski@gnu.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>, ic.felix@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 27, 2009 at 2:39 PM, Bob Copeland<me@bobcopeland.com> wrote:
> On Thu, Aug 27, 2009 at 11:25:03AM -0700, Luis R. Rodriguez wrote:
>> > Well, we also don't use the turbo modes at all and that's where the
>> > error is (IIRC) so it shouldn't have any impact. :)
>>
>> Again, why don't we just remove all that fucking turbo cruft?
>
> OK with me since no one seems to care enough to implement mac80211
> support.  I left some of the #defines in place as they are useful
> documentation.  Approx. 80 of the lines removed are comments.
>
>   text    data     bss     dec     hex filename
>  136746     480      56  137282   21842 ath5k_old.ko
>  134913     480      56  135449   21119 ath5k_new.ko
>
> Disclaimer: only barely tested.

Sexy, thanks!

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

>        { AR5K_PHY(14),
> -          { 0x00000007, 0x00000007, 0x0000000b, 0x0000000b } },
> +          { 0x00000007, 0x0000000b, 0x0000000b } },

Apart from this one initval all other ar5211_ini_mode[] values between
802.11a and 802.11g are the same! Which means we could potentially
save (35 lines here * 4 bytes) + (3 entries for AR5K_PHY(14) * 4) =
152 bytes here if we just converge 11a and 11g as just OFDM data for
this ini array and remove AR5K_PHY(14) entry and deal with it as a
final write. I wonder if AR5K_PHY(14) (0x9838) was a typo for 11a or
11g. I'll try to dig to see what this is, perhaps its not a good idea
to move this out and set this later, not sure if this is inline for
the rf buffer trigger stuff, I'll poke.

All other ini arrays differ in more than 1 line so probably not worth mucking.

 Luis
