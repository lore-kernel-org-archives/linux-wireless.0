Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56196 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750941AbeDYIGt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 04:06:49 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Brian Norris" <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: RE: [EXT] Re: [PATCH] mwifiex: fix nested rtnl locking on
 BG_SCAN_STOPPED
Date: Wed, 25 Apr 2018 08:06:46 +0000
Message-ID: <47b96e61ff234dacbe5da02f0730fb84@SC-EXCH02.marvell.com> (sfid-20180425_100656_698589_B6C1EFFC)
References: <1524633572-5588-1-git-send-email-gbhat@marvell.com>
 <87in8fbvrr.fsf@purkki.adurom.net>
In-Reply-To: <87in8fbvrr.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> ----------------------------------------------------------------------
> Ganapathi Bhat <gbhat@marvell.com> writes:
>
> > Whenever sched_scan(BG_SCAN) is in progress and driver downloads any
> > command, firmware will send an event BG_SCAN_STOPPED. On recieving
> > this, driver calls cfg80211_sched_scan_stopped. This function in turn
> > will try to acquire rtnl_lock. But if the rtnl_lock was already
> > held(while sending the command above), this will result in nested rtnl
> > locking. To fix this driver must call rtnl version of the API if
> > rtnl_is_locked().
> >
> > Signed-off-by: Cathy Luo <cluo@marvell.com>
> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
>
> Which one is the author? If Cathy is the author, you should add a From
> header to indicate that.
Sorry for the miss. Myself was the author. Will send v2 with corrections once we address the below comment.
>
> > --- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
> > @@ -848,7 +848,10 @@ int mwifiex_process_sta_event(struct
> > mwifiex_private *priv)
> >
> >     case EVENT_BG_SCAN_STOPPED:
> >             dev_dbg(adapter->dev, "event: BGS_STOPPED\n");
> > -           cfg80211_sched_scan_stopped(priv->wdev.wiphy, 0);
> > +           if (rtnl_is_locked())
> > +                   cfg80211_sched_scan_stopped_rtnl(priv-
> >wdev.wiphy, 0);
> > +           else
> > +                   cfg80211_sched_scan_stopped(priv->wdev.wiphy,
> 0);
>
> IMHO checking if a lock is taking is rather ugly and an indication there's a
> problem with the locking. Instead making an ugly workaround like this I
> would rather investigate who is holding the rtnl and solve that.
There can be applications trying to access driver(via cfg80211), holding rtnl_lock.
For example(in our case):
1. "iw dev"  was called, when BG_SCAN was active.
2. NL80211_CMD_GET_INTERFACE requires rtnl_lock to be hold(specified in internal_flags)
3. cfg80211 will  hold rtnl_lock before calling "get_tx_power"(in pre_doit).
4. mwifiex will download RF_TX_PWR command to firmware
5. firmware will send BG_SCAN_STOPPED event(since BG_SCAN was active).
6. mwifiex will call "cfg80211_sched_scan_stopped" causing nested rtnl locking.

Please share your comments further.
>
> --
> Kalle Valo
