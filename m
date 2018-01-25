Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47424 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751256AbeAYN0f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 08:26:35 -0500
From: Ganapathi Bhat <gbhat@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Brian Norris" <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Shrenik Shikhare <shrenik@marvell.com>
Subject: RE: [EXT] Re: [2/2] mwifiex: use more_rx_task_flag to avoid USB RX
 stall
Date: Thu, 25 Jan 2018 13:26:29 +0000
Message-ID: <b42d5e27ba214f0380c36f33fe7eccc3@SC-EXCH02.marvell.com> (sfid-20180125_142639_530869_9D2779AD)
References: <1516633497-6584-3-git-send-email-gbhat@marvell.com>
        <20180125071202.0F39560A60@smtp.codeaurora.org>
        <e7a1f375b450451da611477943d2eeb6@SC-EXCH02.marvell.com>
 <87a7x2yu03.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87a7x2yu03.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Thursday, January 25, 2018 6:29 PM
> To: Ganapathi Bhat
> Cc: linux-wireless@vger.kernel.org; Brian Norris; Cathy Luo; Xinming Hu;
> Zhiyuan Yang; James Cao; Mangesh Malusare; Shrenik Shikhare
> Subject: Re: [EXT] Re: [2/2] mwifiex: use more_rx_task_flag to avoid USB RX
> stall
>
> Ganapathi Bhat <gbhat@marvell.com> writes:
>
> >> > The above scenario occurs in some platforms where the RX processing
> >> > is comparitively slower. This results in RX stall in driver,
> >> > command/TX timeouts in firmware. The above scenario is introduced
> >> > after commit
> >> > c7dbdcb2a4e1
> >> > ("mwifiex: schedule rx_work on RX interrupt for USB")
> >> >
> >> > To fix this set a new more_rx_task_flag whenever RX data callback
> >> > is trying to schedule rx_work but rx_processing is not yet cleared.
> >> > This will let the current rx_work(which was waiting for
> >> > rx_proc_lock) to loopback and process newly arrived RX packets.
> >> >
> >> > Signed-off-by: Cathy Luo <cluo@marvell.com>
> >> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> >>
> >> I can't find any commit with id c7dbdcb2a4e1, is it correct?
> >
> > Correct. Actually the commit id c7dbdcb2a4e1 is the PATCH [1/2] sent in this
> series.
>
> Actually the commit id will be different, I just tested it to be sure:
>
> $ git reset --hard master
> HEAD is now at b69c1df47281 brcmfmac: separate firmware errors from i/o
> errors $ git am -s -3 1.patch
> Applying: mwifiex: schedule rx_work on RX interrupt for USB $ git log --
> oneline -1 | cat
> 676bc4833907 mwifiex: schedule rx_work on RX interrupt for USB $ git reset -
> -hard master HEAD is now at b69c1df47281 brcmfmac: separate firmware
> errors from i/o errors $ git am -s -3 1.patch
> Applying: mwifiex: schedule rx_work on RX interrupt for USB $ git log --
> oneline -1 | cat
> 74c5fc1d45b4 mwifiex: schedule rx_work on RX interrupt for USB $
>
> So the date, and most likely also the commiter, is included when calculating
> the hash. So you can't really refer to uncommited patches using a commit id
> as the id is determined only once the maintainer applies the patch.
Ok. So, what can be done in this case. Should we wait for 1st patch to be committed and then send v3 of second patch?
>
> --
> Kalle Valo
Regards,
Ganapathi
