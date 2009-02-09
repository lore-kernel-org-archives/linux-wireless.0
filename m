Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4660 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZBIQvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 11:51:20 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Russ Dill <russ.dill@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	Tulio Magno Quites Machado Filho <tuliom@gmail.com>
Subject: Re: ath5k LEDs on Acer Ferrari 5000 laptop
Date: Mon, 9 Feb 2009 11:50:22 -0500
Message-Id: <20090209164501.M58498@bobcopeland.com> (sfid-20090209_175124_761915_6ECBDFB7)
In-Reply-To: <f9d2a5e10902090822i36989c8bl45c4a34c0cbb90b8@mail.gmail.com>
References: <f9d2a5e10902082209h33afe4dey4930f23c3f178bc8@mail.gmail.com> <20090209151221.M9585@bobcopeland.com> <f9d2a5e10902090822i36989c8bl45c4a34c0cbb90b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 9 Feb 2009 09:22:16 -0700, Russ Dill wrote
> So no, the LED does not work with or without the emachines patch. It
> only works if I instead set sc->led_pin to 1 and sc->led_on to 1. I
> only mention the emachines patch because it tries to cover 100% of
> AMBIT systems, whereas my laptop wireless chipset identifies as AMBIT,
> but its LED is wired differently.

Right, ok, that is what I wanted to know.  I guess we can just 
differentiate based on sub-device ID.

I actually have some LED cleanup patches sitting around that need dusting
off, part of which is a sysfs file to set the led pin and polarity (I have
mixed feelings about the usefulness of that part, perhaps it is overkill).
Also todo is to make that device selection table-driven instead of 
cascading ifs.  I'll post that stuff this week.

As for the function of each LED -- correct, right now we just map everything
on to rx and tx; it's definitely not ideal.

-- 
Bob Copeland %% www.bobcopeland.com


