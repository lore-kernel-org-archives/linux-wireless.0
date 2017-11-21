Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from store.laptop.org ([18.85.44.157]:59117 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750794AbdKUTVe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 14:21:34 -0500
Date: Wed, 22 Nov 2017 06:21:26 +1100
From: James Cameron <quozl@laptop.org>
To: Xinming Hu <huxm@marvell.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>
Subject: Re: [EXT] Re: [PATCH] mwifiex: do not support change AP interface to
 station mode
Message-ID: <20171121192126.GA5400@us.netrek.org> (sfid-20171121_202138_199439_5146C3CD)
References: <1511249043-21404-1-git-send-email-huxm@marvell.com>
 <20171121080408.GH19252@us.netrek.org>
 <f937c2db94884640b64e6950416121e1@SC-EXCH02.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <f937c2db94884640b64e6950416121e1@SC-EXCH02.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 21, 2017 at 12:03:19PM +0000, Xinming Hu wrote:
> Hi James,
> 
> > -----Original Message-----
> > From: quozl@laptop.org [mailto:quozl@laptop.org]
> > Sent: 2017年11月21日 16:04
> > To: Xinming Hu <huxm@marvell.com>
> > Cc: Linux Wireless <linux-wireless@vger.kernel.org>; Kalle Valo
> > <kvalo@codeaurora.org>; Brian Norris <briannorris@chromium.org>; Dmitry
> > Torokhov <dtor@google.com>; rajatja@google.com; Zhiyuan Yang
> > <yangzy@marvell.com>; Tim Song <songtao@marvell.com>; Cathy Luo
> > <cluo@marvell.com>; James Cao <jcao@marvell.com>; Ganapathi Bhat
> > <gbhat@marvell.com>; Ellie Reeves <ellierevves@gmail.com>
> > Subject: [EXT] Re: [PATCH] mwifiex: do not support change AP interface to
> > station mode
> > 
> > External Email
> > 
> > ----------------------------------------------------------------------
> > On Tue, Nov 21, 2017 at 03:24:03PM +0800, Xinming Hu wrote:
> > > Firmware do not support change interface from micro-ap mode to station
> > > mode, forbidden this operation in driver accordingly.
> > 
> > All firmware or specific versions?
> > 
> 
> This property result from the initial design consideration in
> firmware.

Thanks.  I maintain a product that uses your MV8787 device with
firmware sd8787_uapsta.bin and review mwifiex patches for local
backport.

> 
> > >
> > > Signed-off-by: Cathy Luo <cluo@marvell.com>
> > > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > > ---
> > >  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > > b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > > index 6e0d9a9..a87758f 100644
> > > --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > > +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > > @@ -1181,6 +1181,12 @@ static int mwifiex_deinit_priv_params(struct
> > mwifiex_private *priv)
> > >  		switch (type) {
> > >  		case NL80211_IFTYPE_ADHOC:
> > >  		case NL80211_IFTYPE_STATION:
> > > +			if (mwifiex_get_priv_by_id(priv->adapter, priv->bss_num,
> > > +						   MWIFIEX_BSS_TYPE_STA)){
> > 
> > Is this test necessary?
> 
> Hhn, yes, Will remove this check, which comes from a fix for combo sta/uap case.
> Thanks for the suggestion.
> 
> > 
> > dev->ieee80211_ptr->iftype is always NL80211_IFTYPE_AP at this point.
> > 
> > > +				mwifiex_dbg(priv->adapter, INFO,
> > > +					    "Skip change virtual interface\n");
> > 
> > Is this message easy to understand?  Other messages in the same function
> > seem easier; e.g. "%s: changing to %d not supported\n"
> 
> OK.
> 
> > 
> > > +				return 0;
> > 
> > Should this be -EOPNOTSUPP rather than 0?
> 
> Yes.
> 
> > 
> > > +			}
> > >  			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
> > >  							       type, params);
> > >  			break;
> > > --
> > > 1.9.1
> > >
> > 
> > --
> > James Cameron
> > http://quozl.netrek.org/

-- 
James Cameron
http://quozl.netrek.org/
