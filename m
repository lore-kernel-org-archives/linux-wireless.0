Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:4215 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbYHROm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 10:42:59 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2012737rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2008 07:42:59 -0700 (PDT)
Message-ID: <b6c5339f0808180742r3fdc06dfo15ef5bb352333251@mail.gmail.com> (sfid-20080818_164307_564116_A125ECDB)
Date: Mon, 18 Aug 2008 10:42:58 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Lupusoru, Razvan A" <razvan.a.lupusoru@intel.com>
Subject: Re: Ath5k missing led_classdev
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BAD036B67C739F45BE062D0A03D19286036D35BB@orsmsx414.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <Acj9Zps6uV6WabtPRwGUkFptNakABgAAr94gAAAgTxA=>
	 <BAD036B67C739F45BE062D0A03D19286036D35BB@orsmsx414.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 13, 2008 at 1:28 PM, Lupusoru, Razvan A
<razvan.a.lupusoru@intel.com> wrote:
> Hello,
>
> I compiled the package compat-wireless-2008-08-06 against 2.6.23 kernel.
> After it is done compiling, I get some warnings. The relevant ones are:
> WARNING: "led_classdev_register"
> [/kernel2623/compat-wireless-2008-08-06/drivers/net/wireless/ath5k/ath5k
> .ko] undefined!
> WARNING: "led_classdev_unregister"
> [/kernel2623/compat-wireless-2008-08-06/drivers/net/wireless/ath5k/ath5k
> .ko] undefined!
>
> What options in the kernel do I need to enable to get rid of these
> warnings? I try to "modprobe ath5k" but it tells me it is missing those
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
