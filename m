Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:42307 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780AbZIKSgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 14:36:35 -0400
Received: by iwn8 with SMTP id 8so569475iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2009 11:36:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909111427.39974.hs4233@mail.mn-solutions.de>
References: <200909111427.39974.hs4233@mail.mn-solutions.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 11 Sep 2009 11:36:18 -0700
Message-ID: <43e72e890909111136r67a305b9qc3e78a7dcb205d@mail.gmail.com>
Subject: Re: Questions about regulatory domain & passive scanning
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, Kel Modderman <kel@otaku42.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 11, 2009 at 5:27 AM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
> Hi !
>
> I'm playing with regulatory domain using wireless-testing, iw,
> crda and ath5 on Debian. Here are some observations:
>
> 1) Debian sucks here

We've tried a few times to poke them and after some thread exchanges
and some changes to wirless-regdb and crda due to concerns over the
signing stuff due to the DFSG in account for these discussions it
seems some stuff was packaged but not sure where it went. Kel, are you
aware of the status in this regard on Debian?

[1] http://lists.alioth.debian.org/pipermail/pkg-wpa-devel/2009-May/002267.html

> 2) I remove CONFIG_WIRELESS_OLD_REGULATORY. Then, after inserting
>   the card, I see in "iw list":
>
>         * 2412 MHz [1] (20.0 dBm)
>         * 2417 MHz [2] (20.0 dBm)
>         * 2422 MHz [3] (20.0 dBm)
>         * 2427 MHz [4] (20.0 dBm)
>         * 2432 MHz [5] (20.0 dBm)
>         * 2437 MHz [6] (20.0 dBm)
>         * 2442 MHz [7] (20.0 dBm)
>         * 2447 MHz [8] (20.0 dBm)
>         * 2452 MHz [9] (20.0 dBm)
>         * 2457 MHz [10] (20.0 dBm)
>         * 2462 MHz [11] (20.0 dBm)
>         * 2467 MHz [12] (20.0 dBm) (passive scanning)
>         * 2472 MHz [13] (20.0 dBm) (passive scanning)
>         * 2484 MHz [14] (20.0 dBm) (passive scanning)
>
>   I'd like to highlight the "passive scanning". Is this info
>   from the card EEPROM?

If you lack crda, by default you will world roam, even if your EEPROM
has been programmed to a specific regulatory domain and calibrated as
such -- reason being is we moved regulatory content to userspace; so
OLD_REG had only 3 statically built regulatory domains in the kernel,
with CRDA you get all of them on userspace, and no more need to update
the kernel to update regulatory settings. World roaming has some
enhancements though like enabling active scanning on passive-scanning
channels if youo pick up a beacon from an AP on that channel.

> 3) After "iw reg set DE" (for germany), it's now
>
>          2412 MHz [1] (20.0 dBm)
>          2417 MHz [2] (20.0 dBm)
>          2422 MHz [3] (20.0 dBm)
>          2427 MHz [4] (20.0 dBm)
>          2432 MHz [5] (20.0 dBm)
>          2437 MHz [6] (20.0 dBm)
>          2442 MHz [7] (20.0 dBm)
>          2447 MHz [8] (20.0 dBm)
>          2452 MHz [9] (20.0 dBm)
>          2457 MHz [10] (20.0 dBm)
>          2462 MHz [11] (20.0 dBm)
>          2467 MHz [12] (20.0 dBm) (passive scanning)
>          2472 MHz [13] (20.0 dBm) (passive scanning)
>          2484 MHz [14] (disabled)
>
>   Great, CRDA worked obviously: channel 14 has been disabled.

Sure, but keep in mind your regulatory domain must've been read too
first, that's probably what lifted your passive scan flag on channel
12 unless you did a scan prior to trying to set the regulatory domain.

>   And, as I understand it, CRDA can just limit settings
>   further, not widening it. Therefore channels 12 and 13
>   are still marked as "passive scanning".

Right. Now if your card is world roaming (defined in
net/wireless/reg.c as reg_is_world_roaming() ) you could lift passive
scan off of 12 and 13 if you had an AP there.

>   If I want to get them to "active scanning", would I need to
>   modify the EEPROM of the card?

Well yes, but you must note that is something not supported, not
recommended, unless you are a manufacturer selling cards and have the
capability to calibrate, etc, and certify. That is -- EEPROM
programming is not something designed to be changed by the end user.

> ath_info says "Reg. Domain:
>   0x60".

Ok, as I have documented on the ath wiki page [1] any Atheros
regulatory domain which has 0x60 is world roaming. As I also
documented as well these 12 world regulatory domains are statically
built into the kernel on ath as they are custom world regulatory
domains, so even without the presence of CRDA you'll get the
regulatory domain your card is designed for. With OLD_REG though you
end up trying to stick to static kenrel US rules so you would only be
allowed to use what the US allows on your 0x60 regulatory domain, this
is ath_world_regdom_60_61_62 on drivers/net/wireless/ath/regd.c.

[1] http://wireless.kernel.org/en/users/Drivers/ath

  Luis
