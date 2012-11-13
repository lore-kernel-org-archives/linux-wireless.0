Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40614 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab2KMQ1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 11:27:43 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so10964031iea.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 08:27:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121113043226.GA4064@localhost>
References: <1352746438-2404-1-git-send-email-thomas@cozybit.com>
	<CAJ-Vmom4Q9ToOokeLf91tSDmmPDehcqfofuPu=wL+=Pf4fUr_g@mail.gmail.com>
	<20121112192859.GB6842@localhost>
	<CA+yqC4ZkeKgLKoPh18f1qDyLuOGf22GyL92+suca+gveoq7ZVw@mail.gmail.com>
	<20121113043226.GA4064@localhost>
Date: Tue, 13 Nov 2012 08:27:43 -0800
Message-ID: <CA+yqC4bFBFBccmeHWOaQHP0E=A0OWk+uef2ASdmLmR6pJfXRGw@mail.gmail.com> (sfid-20121113_172753_955434_45ED5EDB)
Subject: Re: [PATCH] ath5k: RX timestamp is reported at end of frame
From: Sam Leffler <sleffler@google.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 12, 2012 at 8:32 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Mon, Nov 12, 2012 at 11:40:15AM -0800, Sam Leffler wrote:
>> > I'll do some testing tonight with whatever cards I have around here to
>> > see if we can at least get a better idea of which chipsets do what.
>>
>> >From my experience doing tdma on ath chipsets I know the timestamp is
>> a snapshot of the tsf recorded by the dma engine when it writes the
>> descriptor on dma completion.  This was only legacy frames; don't know
>> how things work for aggregate frames.
>
> On dma completion, so that might be even a bit further beyond
> end-of-frame?

It's close enough that if you adjust by the air time for the frame
you'll get an accurate measure of when the preamble was received at
the sta--at least accurate enough for me to synchronize clocks over
100+ km.  Details are available if you search and the code has been in
freebsd for many years...

>
> For the record, I just tested this as follows: I set up a mesh
> network between an ath5k and an ath9k card (the ath9k driver being
> already patched similarly), with the mesh beacon having a few
> information elements, and operating in 2.4 GHz band.
>
> Then I watched toffset adjustments.  A more accurate timestamp
> means the toffsets between the stations should be closer to each
> other.
>
> Here are some representative numbers:
>
> ath5k: phy2: Atheros AR2413 chip found (MAC: 0x78, PHY: 0x45)
> -------------------------------------------------------------
> Without patch:
> updated toffset for 00:80:48:63:a2:f8: 52987952
> updated toffset for 00:03:7f:10:4d:d6: -52989071
> (diff 1119 us)
>
> With patch:
> updated toffset for 00:80:48:63:a2:f8: -92733857
> updated toffset for 00:03:7f:10:4d:d6: 92733496
> (diff 361 us)
>
> ath5k: phy0: Atheros 5414 chip found (MAC: 0xa3, PHY: 0x61)
> -------------------------------------------------------------
> Without patch:
> updated toffset for 00:17:f2:43:be:3a: -2557256031
> updated toffset for 00:03:7f:10:4d:d6: 2557254935
> (diff 1096 us)
>
> With patch:
> updated toffset for 00:17:f2:43:be:3a: -2054754842
> updated toffset for 00:03:7f:10:4d:d6: 2054755003
> (diff 161 us)
>
> Sorry, those are all the ath5k devices I have access to without
> digging through some boxes, but in the absence of someone with
> old old hardware showing up and saying this is worse for them,
> I'd say ship it...
>
> Thomas, feel free to add my:
>
> Tested-by: Bob Copeland <me@bobcopeland.com>
>
> --
> Bob Copeland %% www.bobcopeland.com
