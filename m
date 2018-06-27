Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49832 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S965204AbeF0PAc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 11:00:32 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Brian Norris" <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, 'Xinming Hu' <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: RE: [EXT] Re: [PATCH] mwifiex: fix nested rtnl locking on
 BG_SCAN_STOPPED
Date: Wed, 27 Jun 2018 15:00:26 +0000
Message-ID: <b534bd7a3e6a43baa7593a493f18e6fa@SC-EXCH02.marvell.com> (sfid-20180627_170036_365884_731EF693)
References: <1524633572-5588-1-git-send-email-gbhat@marvell.com>
 <87in8fbvrr.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> > >
> > >   case EVENT_BG_SCAN_STOPPED:
> > >           dev_dbg(adapter->dev, "event: BGS_STOPPED\n");
> > > -         cfg80211_sched_scan_stopped(priv->wdev.wiphy, 0);
> > > +         if (rtnl_is_locked())
> > > +                 cfg80211_sched_scan_stopped_rtnl(priv-
> > >wdev.wiphy, 0);
> > > +         else
> > > +                 cfg80211_sched_scan_stopped(priv->wdev.wiphy,
> > 0);
> >
> > IMHO checking if a lock is taking is rather ugly and an indication there's a
> > problem with the locking. Instead making an ugly workaround like this I
> > would rather investigate who is holding the rtnl and solve that.
> There can be applications trying to access driver(via cfg80211), holding
> rtnl_lock.
> For example(in our case):
> 1. "iw dev"  was called, when BG_SCAN was active.
> 2. NL80211_CMD_GET_INTERFACE requires rtnl_lock to be hold(specified in
> internal_flags)
> 3. cfg80211 will  hold rtnl_lock before calling "get_tx_power"(in pre_doit).
> 4. mwifiex will download RF_TX_PWR command to firmware
> 5. firmware will send BG_SCAN_STOPPED event(since BG_SCAN was active).
> 6. mwifiex will call "cfg80211_sched_scan_stopped" causing nested rtnl
> locking.
>
> Please share your comments further.
Let us know your thoughts on above sequence.

Regards,
Ganapathi
