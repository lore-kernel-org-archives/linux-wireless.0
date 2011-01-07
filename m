Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41226 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab1AGWyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 17:54:11 -0500
Received: by wyb28 with SMTP id 28so17864369wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 14:54:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110107202224.GI21588@tux>
References: <AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com>
	<AANLkTin8JO4UHUYLufSmPhRw0ZndDdjTpueSOHNQbDiZ@mail.gmail.com>
	<20110107024432.GC20431@tux>
	<201101071111.17423.helmut.schaa@googlemail.com>
	<AANLkTi=cxggOG6xkVQqJ9S+ieg8LD43TSVEYAJW7YFrk@mail.gmail.com>
	<20110107202224.GI21588@tux>
Date: Fri, 7 Jan 2011 14:54:10 -0800
Message-ID: <AANLkTi=m4BzXBR4vohkxT9zKpXxmZSO347qG8=p-FTO1@mail.gmail.com>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
From: Aleksandar Milivojevic <alex@milivojevic.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Wolfgang Kufner <wolfgang.kufner@gmail.com>,
	Luis Correia <buga@loide.net>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 7, 2011 at 12:22 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> You may want to try checing the 'iw event -t' output while the issue happens.
> Maybe it is due to a roaming issue, if you are using a large BSS and roam
> in between you may want to try using wpa_supplicant with nl80211 and use
> the new bgscan module from wpa_supplicant to trigger you to only switch
> based on triggered events from nl80211 like signal rssi changes.
>
> Here is an example supplicant conf that uses the bgscan module:
>
> # WPA-PSK/TKIP
>
> ctrl_interface=/var/run/wpa_supplicant
>
> network={
>        ssid="my-corp-cool-bss"
>        bgscan="simple:30:-45:300"
>        key_mgmt=WPA-PSK
>        proto=RSN
>        pairwise=CCMP
>        group=CCMP
>        psk="foobar_is_great"
> }
>
> No Linux distributions today uses this other than ChromeOS, but they should
> all change to use it.

I doubt it would help in this case, since things are very static.
There's only single AP (typical home network environment).  The
wireless card is plugged into (and sits directly on top of) an
desktop, so its position in space is rather static (if I wanted to
make a bad attempt at being funny, I'd add "relative to the AP").

I'll check out what "iw event -t" has to say over the weekend.
