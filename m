Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27777 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbYHRTCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 15:02:35 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Ath5k missing led_classdev
Date: Mon, 18 Aug 2008 12:02:33 -0700
Message-ID: <BAD036B67C739F45BE062D0A03D1928603710018@orsmsx414.amr.corp.intel.com> (sfid-20080818_210252_820564_8C7B8580)
In-Reply-To: <b6c5339f0808180742r3fdc06dfo15ef5bb352333251@mail.gmail.com>
References: <Acj9Zps6uV6WabtPRwGUkFptNakABgAAr94gAAAgTxA=> <BAD036B67C739F45BE062D0A03D19286036D35BB@orsmsx414.amr.corp.intel.com> <b6c5339f0808180742r3fdc06dfo15ef5bb352333251@mail.gmail.com>
From: "Lupusoru, Razvan A" <razvan.a.lupusoru@intel.com>
To: "Bob Copeland" <me@bobcopeland.com>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The problem was that inside my .config file I also had
# CONFIG_NEW_LEDS is not set
And
CONFIG_NEW_LEDS=y

And for some reason, it seems that when I compiled the kernel, it parsed
the first line also. After I removed the part that said that it is not
set, I had no problems with ath5k.

Razvan A. Lupusoru

-----Original Message-----
From: bcopeland@gmail.com [mailto:bcopeland@gmail.com] On Behalf Of Bob
Copeland
Sent: Monday, August 18, 2008 7:43 AM
To: Lupusoru, Razvan A
Cc: linux-wireless@vger.kernel.org
Subject: Re: Ath5k missing led_classdev

On Wed, Aug 13, 2008 at 1:28 PM, Lupusoru, Razvan A
<razvan.a.lupusoru@intel.com> wrote:
> Hello,
>
> I compiled the package compat-wireless-2008-08-06 against 2.6.23
kernel.
> After it is done compiling, I get some warnings. The relevant ones
are:
> WARNING: "led_classdev_register"
>
[/kernel2623/compat-wireless-2008-08-06/drivers/net/wireless/ath5k/ath5k
> .ko] undefined!
> WARNING: "led_classdev_unregister"
>
[/kernel2623/compat-wireless-2008-08-06/drivers/net/wireless/ath5k/ath5k
> .ko] undefined!
>
> What options in the kernel do I need to enable to get rid of these
> warnings? I try to "modprobe ath5k" but it tells me it is missing
those
> so it cannot load.

CONFIG_LEDS_CLASS should provide those symbols.  Are you still having
that issue after installing the kernel?  The Kconfig for the in-tree
version selects MAC80211_LEDS, LEDS_CLASS, and NEW_LEDS (and by
extension LEDS_TRIGGERS).

I suppose ath5k should be able to configure all of the LED stuff out
like other drivers; I only didn't do that because there wasn't a knob
before and I didn't want to add new ifdefs to base.c.

-- 
Bob Copeland %% www.bobcopeland.com
