Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55579 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab1K0OH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 09:07:56 -0500
Received: by qadc14 with SMTP id c14so794087qad.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 06:07:55 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
References: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
Date: Sun, 27 Nov 2011 15:07:55 +0100
Message-ID: <CA+icZUUwLuGa87-B1F7Vd=oEM6KLYAd1GnKig84GTfKQx+iU5Q@mail.gmail.com> (sfid-20111127_150801_516652_B2122F33)
Subject: Re: [PATCH v2 00/12] ath5k: A few updates + cleanups + kerneldoc
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 25, 2011 at 7:40 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> This series of patches includes some stability fixes related to interrupt
> handling, an updated version of a calibration-related patch I posted some
> time ago but never submited here and a new module parameter to disable
> GPIO based rfkill switch (we had a few bug reports on that recently).
>
> It also adds kernel doc on all ath5k_hw_* functions and structs (needs
> some more work but it should be fine, I reviewed the output, spell-ckecked
> it etc) and a few minor fixes and optimizations.
>
> v2: Adress comments from Adrian, Felix, Jiri and Bob. Thanks a lot for the
> review !
>
> Nick Kossifidis (12):
>  ath5k: Switch from read-and-clear to write-to-clear method when
>    handling PISR/SISR registers
>  ath5k: Add TXNOFRM to INT_TX_ALL
>  ath5k: Cleanups v1
>  ath5k: Calibration re-work
>  ath5k: Use usleep_range where possible
>  ath5k: Cleanups v2 + add kerneldoc on all hw functions
>  ath5k: We always do full calibration on AR5210
>  ath5k: Add a module parameter to disable hw rf kill switch
>  ath5k: MRR support and 2GHz radio override belong in ah_capabilities
>  ath5k: ath5k_ani_period_restart only touches struct ath5k_ani_state
>  ath5k: Renumber hw queue ids
>  ath5k: Optimize ath5k_cw_validate
>
>  drivers/net/wireless/ath/ath5k/ahb.c      |    4 +-
>  drivers/net/wireless/ath/ath5k/ani.c      |   91 ++--
>  drivers/net/wireless/ath/ath5k/ani.h      |   32 +-
>  drivers/net/wireless/ath/ath5k/ath5k.h    |  569 +++++++++++++------
>  drivers/net/wireless/ath/ath5k/attach.c   |   16 +-
>  drivers/net/wireless/ath/ath5k/base.c     |  287 +++++++----
>  drivers/net/wireless/ath/ath5k/caps.c     |   27 +-
>  drivers/net/wireless/ath/ath5k/desc.c     |  217 ++++++--
>  drivers/net/wireless/ath/ath5k/desc.h     |  124 +++--
>  drivers/net/wireless/ath/ath5k/dma.c      |  370 ++++++++-----
>  drivers/net/wireless/ath/ath5k/gpio.c     |   81 +++-
>  drivers/net/wireless/ath/ath5k/initvals.c |   75 ++-
>  drivers/net/wireless/ath/ath5k/pci.c      |    2 +-
>  drivers/net/wireless/ath/ath5k/pcu.c      |  222 +++++---
>  drivers/net/wireless/ath/ath5k/phy.c      |  853 +++++++++++++++++++++++------
>  drivers/net/wireless/ath/ath5k/qcu.c      |  143 ++++--
>  drivers/net/wireless/ath/ath5k/reg.h      |   27 +-
>  drivers/net/wireless/ath/ath5k/reset.c    |  230 ++++++--
>  drivers/net/wireless/ath/ath5k/rfbuffer.h |   59 ++-
>  drivers/net/wireless/ath/ath5k/rfgain.h   |   22 +-
>  20 files changed, 2465 insertions(+), 986 deletions(-)
>
> --
> 1.7.8.rc3
>
Unfortunately, <patchwork.kernel.org> is still down, thus I have
extracted your patchset from your emails.
I have git-am-ed them in my local linux-next (next-20111125) GIT.
( Patchset attached ).

I have only seen this little typo by having a quick view on the single patch:

[ drivers/net/wireless/ath/ath5k/pcu.c ]

+ * -Different operating modes: AP, STA, IBSS <--- Space before "Different"

Any special thing you want to be tested?

How can I easily generate the (kernel) docs for ath5k (I mean I don't
want to generate a complete kernel-doc)?

- Sedat -

[1] https://patchwork.kernel.org/project/linux-wireless/list/
