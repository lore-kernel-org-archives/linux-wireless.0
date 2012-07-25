Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59782 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab2GYQR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 12:17:56 -0400
Message-ID: <1343233072.11031.20.camel@sortiz-mobl> (sfid-20120725_181759_969044_0F97C9D6)
Subject: Re: [NFC] nfc subsystem queries
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: Martin Fuzzey <mfuzzey@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Date: Wed, 25 Jul 2012 18:17:52 +0200
In-Reply-To: <CALBypN7BpiyRJNYzXwHEdUvSp2iB6xwx6RyP_9zUCeggJXNSdg@mail.gmail.com>
References: <CALBypN7BpiyRJNYzXwHEdUvSp2iB6xwx6RyP_9zUCeggJXNSdg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Martin,

(cc'ing the linux-nfc mailing list)

My answers below:

On Wed, 2012-07-25 at 16:55 +0200, Martin Fuzzey wrote:
> Hello,
> I have a few questions about the new NFC subsystem:
> 
> 1) The devices currently supported (pn533, pn544) are quite
> "intelligent", in that they accept fairly high level commands (using
> HCI, NCI or a chip specific USB protocol) and abstract away the
> ISO1443 -3 and -4 details. There are also chips available (such as the
> recent NXP CLRC663 or the older NXP MFRC531) that provide a lower
> level interface and hence require a software implementation of ISO1443
> -3 and -4. Are such chips within the scope of the nfc subsystem? Is
> anyone currently working on or planning to work on drivers fot this
> kind of chip?
I don't think anyone is currently working on that, no.
I wouldn't say it's out of scope, but this is the closer to a SW radio
I'd be willing to go, obviously. It's a lot lower level than what we
have right now, and to a certain extent you'd also need to implement
more than iso14443-[34]. NFCIP-1 and parts of the NFC digital specs come
to mind.


> 2) Are there any test suites that drivers for this subsystem are
> expected to pass (as there are for USB and MMC for example)?
No, there are no such suite.


> 3) Does anyone know if Android is planning to switch to the
> nfc-subsystem? I know this is a bit off topic for this list but the
> question was recently asked (by someone else) with no reply on
> android-kernel.
AFAIK, Google is not planning to switch to the nfc subsystem. They're
using an NFC stack implemented by their HW vendor and seem to be happy
with that setup. I'm no insider though, so they probably have plans I'm
not aware of.

Cheers,
Samuel.


