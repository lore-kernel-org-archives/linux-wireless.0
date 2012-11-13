Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51420 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab2KMEca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 23:32:30 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so10179417iea.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 20:32:30 -0800 (PST)
Date: Mon, 12 Nov 2012 23:32:26 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Sam Leffler <sleffler@google.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: RX timestamp is reported at end of frame
Message-ID: <20121113043226.GA4064@localhost> (sfid-20121113_053240_219005_D7AEE4C3)
References: <1352746438-2404-1-git-send-email-thomas@cozybit.com>
 <CAJ-Vmom4Q9ToOokeLf91tSDmmPDehcqfofuPu=wL+=Pf4fUr_g@mail.gmail.com>
 <20121112192859.GB6842@localhost>
 <CA+yqC4ZkeKgLKoPh18f1qDyLuOGf22GyL92+suca+gveoq7ZVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+yqC4ZkeKgLKoPh18f1qDyLuOGf22GyL92+suca+gveoq7ZVw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 12, 2012 at 11:40:15AM -0800, Sam Leffler wrote:
> > I'll do some testing tonight with whatever cards I have around here to
> > see if we can at least get a better idea of which chipsets do what.
> 
> >From my experience doing tdma on ath chipsets I know the timestamp is
> a snapshot of the tsf recorded by the dma engine when it writes the
> descriptor on dma completion.  This was only legacy frames; don't know
> how things work for aggregate frames.

On dma completion, so that might be even a bit further beyond
end-of-frame?

For the record, I just tested this as follows: I set up a mesh
network between an ath5k and an ath9k card (the ath9k driver being
already patched similarly), with the mesh beacon having a few
information elements, and operating in 2.4 GHz band.

Then I watched toffset adjustments.  A more accurate timestamp
means the toffsets between the stations should be closer to each
other.

Here are some representative numbers:

ath5k: phy2: Atheros AR2413 chip found (MAC: 0x78, PHY: 0x45)
-------------------------------------------------------------
Without patch:
updated toffset for 00:80:48:63:a2:f8: 52987952
updated toffset for 00:03:7f:10:4d:d6: -52989071
(diff 1119 us)

With patch:
updated toffset for 00:80:48:63:a2:f8: -92733857
updated toffset for 00:03:7f:10:4d:d6: 92733496
(diff 361 us)

ath5k: phy0: Atheros 5414 chip found (MAC: 0xa3, PHY: 0x61)
-------------------------------------------------------------
Without patch:
updated toffset for 00:17:f2:43:be:3a: -2557256031
updated toffset for 00:03:7f:10:4d:d6: 2557254935
(diff 1096 us)

With patch:
updated toffset for 00:17:f2:43:be:3a: -2054754842
updated toffset for 00:03:7f:10:4d:d6: 2054755003
(diff 161 us)

Sorry, those are all the ath5k devices I have access to without
digging through some boxes, but in the absence of someone with
old old hardware showing up and saying this is worse for them,
I'd say ship it...

Thomas, feel free to add my:

Tested-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com
