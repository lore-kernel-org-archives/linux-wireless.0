Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43923 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab1HQIMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 04:12:32 -0400
Received: by pzk37 with SMTP id 37so666900pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Aug 2011 01:12:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20110817T044544-76@post.gmane.org>
References: <1313345797-5441-2-git-send-email-zajec5@gmail.com>
	<loom.20110817T044544-76@post.gmane.org>
Date: Wed, 17 Aug 2011 10:12:31 +0200
Message-ID: <CACna6ryO9=rwwOMya7RdDohk0p-TOR6O0FU2p6UYnOCzBsHhWg@mail.gmail.com> (sfid-20110817_101238_030724_4939C756)
Subject: Re: [PATCH V3 3.2 2/2] b43: fix DMA on some bugged hardware
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?V=C3=ADtor_Ferreira?= <vitor.dominor@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

/me rearranged order of quoted fragments

2011/8/17 Vítor Ferreira <vitor.dominor@gmail.com>:
> Greetings! I'm a grateful Linux end-user, following up on the success of this
> patch.
> I can confirm that after applying the following patches:
> - RESEND-3.2-1-2-ssb-fix-DMA-translation-for-some-specific-boards.patch
> - RFC-RFT-V2-2-2-b43-fix-DMA-on-some-bugged-hardware.patch
> - v2-08-46-net-wireless-b43-fix-DMA-direction-for-RX-buffers.patch
> to a 3.0.1 fedora patched kernel, the problem reporting to these patches has
> been solved (as far as I am concerned).

I didn't expect that patches to affect your card.


> Just a side note... Curiously with Intel VT, the b43 driver would start and work
> for some short time before it crashed, while the wl proprietary driver (from
> Broadcom) would not even fully load.

I hope you mean DMA errors, not really crashing.
What you describe here sounds like standard LP-PHY DMA issue resolved
in 3.0 kernel. We got some timeouts-related bug, which didn't hit
right after loading b43, usually some time (seconds-minutes) later.
The last patches are supposed to fix situation where DMA does not work
at all. Not even for a second, not for a single packet. I'm really
sure of that, unless you have some *really* bugged hardware accepting
multiple "translation bits" (something my patches fix).
Moreover LP-PHY DMA problems (timeouts issue) was known to be somehow
CPU/BIOS-related. Which makes it even more probably that that's
exactly what you were experiencing.


> Recently, while searching again for a possible solution for this issue, I
> stumbled on your submitted patches in May to address the DMA issue. Then, in the
> b43 supported devices table, I found that my Broadcom wireless card (14e4:4315 -
> LP-r1) is now fully supported since kernel version 3.0. However, incidently I
> had received the kernel 3.0 as a Fedora kernel update and upon enabling again
> Intel VT, the DMA error presented itself still, not better not worse.

That's the tricky part. Kernel 3.0 should really work for you. Unless
Fedora got some problem (mistake?) in compiling/numbering...


> Again, I
> found your recent patches to address the DMA error and followed its developpment
> on the mailing list throughout the last few days.
> Seeing the initial successful tests on 64-bit affected systems, I decided to
> give them a shot on my own system.
> To do so, I updated my 3.0 kernel to the latest in its series (3.0.3rc1?,
> 2.6.40.3 in fedora versioning) and downloaded the latest bleeding edge
> compat-wireless (yesterday) and I applied the above patches to it without
> problems.

I think the important part was updating to the recent compat-wireless,
not applying my patches. If you wish, you can still use that
compat-wireless, revert my 2 patches and test again. I suspect card
will be still working for you.


> Right now, I am writing this with Intel VT enabled and a stable wireless
> connection to my home AP, using the b43 driver. So, I am showing here my
> appreciation and thanking for your great work in crushing a pesky bug that was
> perhaps the only one stopping my computer from being fully Linux compatible (HP
> Pavilion dv5t). Continue your great work!

I'm really glad it's working for you now :) We're recently getting
more hardware support and (as you can see) we can slowly focus on bug
fixes now. There still a lot to do, but I hope to have the most of the
hardware supported and bugs resolved still this yeah. Then we can
finally slow down our extremly-fast-recent development a little ;)

-- 
Rafał
