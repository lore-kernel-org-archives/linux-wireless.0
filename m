Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45897 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S967700AbdAKPrs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 10:47:48 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "briannorris@google.com" <briannorris@google.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [1/2] mwifiex: code rearrangement in pcie.c and sdio.c
Date: Wed, 11 Jan 2017 15:47:43 +0000
Message-ID: <e03f76e98fae4ce1a6cf254a1838574c@SC-EXCH04.marvell.com> (sfid-20170111_164755_050639_4BB4B255)
References: <1480517537-9920-1-git-send-email-akarwar@marvell.com>
        <20161205110906.28C706034F@smtp.codeaurora.org>
        <25e936b31e1e4f3d9db2c2309da9f798@SC-EXCH04.marvell.com>
 <87mvfdk65r.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87mvfdk65r.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Friday, December 30, 2016 4:58 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> rajatja@google.com; briannorris@google.com; dmitry.torokhov@gmail.com;
> Xinming Hu
> Subject: [EXT] Re: [1/2] mwifiex: code rearrangement in pcie.c and
> sdio.c
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > Hi Kalle,
> >
> >> Failed to apply:
> >>
> >> fatal: sha1 information is lacking or useless
> >> (drivers/net/wireless/marvell/mwifiex/pcie.c).
> >> Applying: mwifiex: get rid of global user_rmmod flag Repository
> lacks
> >> necessary blobs to fall back on 3-way merge.
> >> Cannot fall back to three-way merge.
> >> Patch failed at 0001 mwifiex: get rid of global user_rmmod flag
> >>
> >> 2 patches set to Changes Requested.
> >>
> >> 9454491 [1/2] mwifiex: code rearrangement in pcie.c and sdio.c
> >> 9454493 [2/2] mwifiex: get rid of global user_rmmod flag
> >>
> >> --
> >> https://patchwork.kernel.org/patch/9454491/
> >>
> >> Documentation about submitting wireless patches and checking status
> >> from patchwork:
> >>
> >>
> https://wireless.wiki.kernel.org/en/developers/documentation/submitti
> >> ng
> >> patches
> >
> >
> > These two patches have dependency with other patch series. I want you
> to consider patches in following order(first being recent).
> >
> > mwifiex: sdio: fix use after free issue for save_adapter
> 
> This applied fine.
> 
> > mwifiex: use module_*_driver helper macros
> >
> > [2/2] mwifiex: get rid of global user_rmmod flag [1/2] mwifiex: code
> > rearrangement in pcie.c and sdio.c
> >
> > [v3,5/5] mwifiex: move pcie_work and related variables inside card --
> ------ This series can be accepted if there are no further
> concerns/comments from Brian/Dmitry.
> > [v3,4/5] mwifiex: wait firmware dump complete during card remove
> > process [v3,3/5] mwifiex: get rid of drv_info* adapter variables
> > [v3,2/5] mwifiex: do not free firmware dump memory in shutdown_drv
> > [v3,1/5] mwifiex: don't wait for main_process in shutdown_drv
> 
> But these didn't. Can you please rebase these and resubmit in one
> patchset? Less conflicts that way.
> 

The problem here is you tried to apply the patches in reverse order. Sorry for the confusion.
Please apply pending patches in below order.

[v3,1/5] mwifiex: don't wait for main_process in shutdown_drv --- Apply this patch first.
[v3,2/5] mwifiex: do not free firmware dump memory in shutdown_drv
[v3,3/5] mwifiex: get rid of drv_info* adapter variables
[v3,4/5] mwifiex: wait firmware dump complete during card remove process
[v3,5/5] mwifiex: move pcie_work and related variables inside card

[1/2] mwifiex: code rearrangement in pcie.c and sdio.c
[2/2] mwifiex: get rid of global user_rmmod flag

mwifiex: use module_*_driver helper macros

[1/5] mwifiex: get rid of mwifiex_do_flr wrapper
[2/5] mwifiex: cleanup in PCIe flr code path
[3/5] mwifiex: sdio card reset enhancement
[4/5] mwifiex: get rid of __mwifiex_sdio_remove helper 
[5/5] mwifiex: get rid of global save_adapter and sdio_work

Regards,
Amitkumar
