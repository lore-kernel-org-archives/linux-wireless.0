Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61385 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2JEXsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 19:48:47 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so2337070pad.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2012 16:48:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121005165152.GA4473@sven-atom.home.narfation.org>
References: <1348756862-8788-1-git-send-email-sven@narfation.org>
	<506B0628.6070201@openwrt.org>
	<CAJ-Vmo=bu=j+=z_TAeE3--Sn5oAEbkEG-HDqK=6okR8xmmWpSQ@mail.gmail.com>
	<2629427.e28b8DS3gI@bentobox>
	<506ED3D4.7050107@openwrt.org>
	<CAJ-VmonKjxmquSUg99kAtPWVwHH-4zTooF1Xvj9mGUyjWL5pCA@mail.gmail.com>
	<20121005165152.GA4473@sven-atom.home.narfation.org>
Date: Fri, 5 Oct 2012 16:48:47 -0700
Message-ID: <CAJ-VmomfDr-JAMtgQmbEsSeF62W-dmsK7LRTJxNUUddOTqDayA@mail.gmail.com> (sfid-20121006_014856_214218_648BE798)
Subject: Re: [ath9k-devel] [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL
 on AR9003
From: Adrian Chadd <adrian@freebsd.org>
To: Sven Eckelmann <sven@narfation.org>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	lindner_marek@yahoo.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 October 2012 09:51, Sven Eckelmann <sven@narfation.org> wrote:

>> Well, is it a RX chainmask thing, or is it a chip thing?
>>
>> It's totally possible to have an RX chainmask of say 0x2 or 0x4..
>
> What are you trying to tell us?

That the check for "rx chainmask == 1? Definitely can't do MRC CCK"
implying "rx chainmask != 1? Definitely can do MRC CCK."
I think that's the wrong logic. It may be a general chipset problem
across some/all AR9300 and later chips that doing MRC CCK with only
one RX chain enabled is a problem, or it may be a single-chain NIC
problem.

I'm pretty sure we can configure any of the RX antennas; it doesn't
have to be "one chain == chain 0."

Anywy. I'll double check that.

> Maybe you missed that part of the conversation, but this was exactly what I
> did. You can even find one of my debug patches which implements it (but many
> fancy hacks are missing).

Cool. I did miss that. But if its' a TX descriptor issue it won't be
due to a register access? :)



Adrian
