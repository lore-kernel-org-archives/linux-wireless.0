Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34951 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936933AbdADUGY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 15:06:24 -0500
Received: by mail-wm0-f66.google.com with SMTP id l2so67785311wml.2
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2017 12:06:23 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: [1/2] ath10k: add accounting for the extended peer statistics
Date: Wed, 04 Jan 2017 21:06:20 +0100
Message-ID: <2769662.Qa6eUCGVkY@debian64> (sfid-20170104_210721_767645_663430DA)
In-Reply-To: <20170103052827.GA8204@atheros-ThinkPad-T61>
References: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com> <CAAd0S9DcCM9XQOihZx1sVf_1=S3VvDye4k1gEMgWEmNWDaBk5Q@mail.gmail.com> <20170103052827.GA8204@atheros-ThinkPad-T61>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Shafi and Kalle,

On Tuesday, January 3, 2017 10:58:27 AM CET Mohammed Shafi Shajakhan wrote:
> On Fri, Dec 30, 2016 at 03:35:10PM +0100, Christian Lamparter wrote:
> > On Thu, Dec 29, 2016 at 3:11 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> > > Christian Lamparter <chunkeey@googlemail.com> wrote:
> > >> The 10.4 firmware adds extended peer information to the
> > >> firmware's statistics payload. This additional info is
> > >> stored as a separate data field and the elements are
> > >> stored in their own "peers_extd" list.
> > >>
> > >> These elements can pile up in the same way as the peer
> > >> information elements. This is because the
> > >> ath10k_wmi_10_4_op_pull_fw_stats() function tries to
> > >> pull the same amount (num_peer_stats) for every statistic
> > >> data unit.
> > >>
> > >> Fixes: 4a49ae94a448faa ("ath10k: fix 10.4 extended peer stats update")
> > >> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> > >
> > > My understanding is that I should skip this patch 1. Please let me know if
> > > I misunderstood. But I'm still plannning to apply patch 2.
> > 
> > I added Mohammed (I hope, he can reply to the open question when he
> > returns), Since I'm not sure what he wants or not.
> > 
> > As far as I'm aware, the "extended" boolean serves no purpose
> > because it was only used in once place in debugfs_sta which was
> > removed in the patch. ( "ath10k_sta_update_stats_rx_duration"
> > and "ath10k_sta_update_extd_stats_rx_duration" have been unified).
> 
> [shafi] We will wait for Kalle to review from the de-ferred stage
> and get his opinion as well(regarding the design change).
> I have no concerns as long this does not changes the existing behaviour.
> thank you !

Thank you Shafi for sticking around. I just fished your response to 
"Re: [PATCH] ath10k: merge extended peer info data with existing peers info" [0].
out of my spam-bucket. Kalle, please look if your copy of the mail got 
flagged/deleted as well. Judging from the reply in this thread, I think you
overlooked it as well? 

After reading it, I think the previous post and the request to put the patch
on wait was unnecessary. As of now, it seems to me that the open questions
between us have been settled amically (so to speak). Kalle, do you have any
concerns or can you put this in the next round then?

Regards,
Christian

[0] <https://www.mail-archive.com/ath10k@lists.infradead.org/msg06066.html>
