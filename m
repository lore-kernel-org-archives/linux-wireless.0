Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:51690 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751352AbeFXUql (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Jun 2018 16:46:41 -0400
From: Daniel Mack <daniel@zonque.org>
Subject: Suspend of SDIO function devices
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
        linux-wireless@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <b8a41e3a-7100-ae17-1275-d1b40a026201@zonque.org> (sfid-20180624_224658_086402_B7589870)
Date: Sun, 24 Jun 2018 22:46:39 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm currently looking into the suspend callbacks of drivers of hardware 
that use an SDIO interface, specifically the libertas_sdio driver:

    drivers/net/wireless/marvell/libertas/if_sdio.c

The comments in if_sdio_suspend() suggest that by returning -ENOSYS due 
to runtime-dependant circumstances, the MMC core will remove the card 
entirely at suspend time. I then searched for the bits that do that and 
failed, until I came across this old commit, which first appeared in 3.16:

    573185cc7e6 mmc: core: Invoke sdio func driver's PM callbacks from 
the sdio bus

Before that commit, the mmc core did in fact invoke the card's 
.suspend() callback manually and if it returned a non-zero result, it 
would remove the card. Now that the generic pm functions are in place, 
this does no longer happen because the host and its clients are 
independent entities. Consequently, systems fail to suspend when the 
libertas_sdio module is loaded.

The pm notifier code in drivers/mmc/core/core.c does still handle cases 
where no pm functions are provided at all (in which case it removes the 
card), but it doesn't handle -ENOSYS return values at runtime.

Now I'm wondering how this is supposed to work, and which end needs 
fixing. The mmc/sdio core by restoring the old logic from before 
573185cc7e6, or the libertas driver.

The platform I'm working on does not retain power for the SDIO slaves, 
so a complete re-init is necessary after resume.

Please advise, I'm happy to test approaches and send patches.


Thanks,
Daniel
