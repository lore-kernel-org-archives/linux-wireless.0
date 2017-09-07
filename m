Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37690 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751884AbdIGUl0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 16:41:26 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: RE: [EXT] Re: [PATCH] mwifiex: check for mfg_mode in add_virtual_intf
Date: Thu, 7 Sep 2017 20:41:21 +0000
Message-ID: <1eba28f4efc641399fcece4657e27ee3@SC-EXCH02.marvell.com> (sfid-20170907_224129_977988_C3865F88)
References: <1504118818-1749-1-git-send-email-gbhat@marvell.com>
 <20170831202146.GA27509@google.com>
In-Reply-To: <20170831202146.GA27509@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> 
> ----------------------------------------------------------------------
> On Thu, Aug 31, 2017 at 12:16:58AM +0530, Ganapathi Bhat wrote:
> > If driver is loaded with 'mfg_mode' enabled, then the sending
> commands
> > are not allowed. So, when mwifiex_send_cmd fails in
> > mwifiex_add_virtual_intf, driver must check for 'mfg_mode' before
> > returning error.
> >
> > Fixes: 7311ea850079 ("mwifiex: fix AP start problem for newly added
> > interface")
> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> > ---
> >  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > index ffada17..1856205 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > @@ -2967,11 +2967,11 @@ struct wireless_dev
> > *mwifiex_add_virtual_intf(struct wiphy *wiphy,
> >
> >  	ret = mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
> >  			       HostCmd_ACT_GEN_SET, 0, NULL, true);
> > -	if (ret)
> > +	if (ret && !adapter->mfg_mode)
> 
> It doesn't feel like ignoring errors is the best approach here,
> especially when it's only a single command that we could easily just
> skip.
Got it.
> 
> So, why don't you just skip it, like this?
> 
> 	if (!adapter->mfg_mode) {
Yes. This is better.
> 		ret = mwifiex_send_cmd(...);
> 		if (ret)
> 			goto err_set_bss_mode;
> 	}
> 
> >  		goto err_set_bss_mode;
> >
> >  	ret = mwifiex_sta_init_cmd(priv, false, false);
> > -	if (ret)
> > +	if (ret && !adapter->mfg_mode)
> >  		goto err_sta_init;
> 
> Same here; I think it's safe to just completely skip
> mwifiex_sta_init_cmd(), no?
Yes. I have sent v2 of these changes.
> 
> Brian
> 
> >
> >  	mwifiex_setup_ht_caps(&wiphy->bands[NL80211_BAND_2GHZ]->ht_cap,
> > priv);
> > --
> > 1.9.1
> >

Thanks,
Ganapathi
