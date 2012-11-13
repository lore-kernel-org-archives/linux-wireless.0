Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46086 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab2KMLdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 06:33:16 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so7265077oag.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 03:33:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121113043226.GA4064@localhost>
References: <1352746438-2404-1-git-send-email-thomas@cozybit.com>
	<CAJ-Vmom4Q9ToOokeLf91tSDmmPDehcqfofuPu=wL+=Pf4fUr_g@mail.gmail.com>
	<20121112192859.GB6842@localhost>
	<CA+yqC4ZkeKgLKoPh18f1qDyLuOGf22GyL92+suca+gveoq7ZVw@mail.gmail.com>
	<20121113043226.GA4064@localhost>
Date: Tue, 13 Nov 2012 13:33:15 +0200
Message-ID: <CAFtRNNz0edqOYDd5A18vGzo2y4R790htgvacQ5EKLgfk7Q-iKQ@mail.gmail.com> (sfid-20121113_123321_691728_FBD1F238)
Subject: Re: [PATCH] ath5k: RX timestamp is reported at end of frame
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Sam Leffler <sleffler@google.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mcgrof@qca.qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/11/13 Bob Copeland <me@bobcopeland.com>:
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


and also my:


Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
