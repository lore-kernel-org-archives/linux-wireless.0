Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39788 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1FLSX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2011 14:23:29 -0400
Received: by ywe9 with SMTP id 9so1686232ywe.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jun 2011 11:23:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DF1D0A5.8080300@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
	<20110609185420.GK4069@shale.localdomain>
	<BANLkTi=FuX0H3UOi6M_LL5t5hdDen77WcQ@mail.gmail.com>
	<4DF1D0A5.8080300@broadcom.com>
Date: Sun, 12 Jun 2011 19:23:27 +0100
Message-ID: <BANLkTi=bVse-E2Gc+ArN8AyS3JwZNAPzmA@mail.gmail.com> (sfid-20110612_202333_064962_7C916645)
Subject: Re: [PATCH 00/21] staging: brcm80211: code cleanup and fullmac bugfix
From: julie Sullivan <kernelmail.jms@gmail.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: Dan Carpenter <error27@gmail.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I am using GregKH's staging-next repo:
> git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git
>

> The patch applies on top of 5ad7b85b90e30eb5af4fbf6ce21907a2bd8934df.
>
> Bye, Roland.
>

OK, this compiles fine on x86-64/SMP. It's probably not interesting
but there are just a few warnings:

drivers/staging/brcm80211/brcmfmac/dhd_sdio.c: In function
‘dhdsdio_probe_attach’:
drivers/staging/brcm80211/brcmfmac/dhd_sdio.c:5418:14: warning: cast
to pointer from integer of different size
drivers/staging/brcm80211/brcmfmac/dhd_sdio.c: In function
‘dhdsdio_chip_recognition’:
drivers/staging/brcm80211/brcmfmac/dhd_sdio.c:6018:19: warning: cast
from pointer to integer of different size

drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c: In function
‘sdioh_request_packet’:
drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c:814:3: warning: cast
from pointer to integer of different size
drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c: In function
‘sdioh_request_buffer’:
drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c:909:14: warning:
cast from pointer to integer of different size

which were there before the patches were applied too. The following
disappeared after the patches were applied:

drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:2308:2: warning:
initialization from incompatible pointer type

Cheers
Julie
