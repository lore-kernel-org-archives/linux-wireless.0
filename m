Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54203 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529AbcGUJSQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 05:18:16 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cathy Luo" <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: RE: [PATCH 5/9] mwifiex: cfg80211 set_default_mgmt_key handler
Date: Thu, 21 Jul 2016 09:18:11 +0000
Message-ID: <33207c0c98c646548bdedf50449719c2@SC-EXCH04.marvell.com> (sfid-20160721_111819_899131_F7C532DA)
References: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
	<1468248832-21969-6-git-send-email-akarwar@marvell.com>
 <87r3aqx3sq.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87r3aqx3sq.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Monday, July 18, 2016 10:49 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam
> Subject: Re: [PATCH 5/9] mwifiex: cfg80211 set_default_mgmt_key handler
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > It is observed that hostapd fails to setup with management frame
> > protection mode enabled when using mwifiex. This patch adds
> > cfg80211_set_default_mgmt_key handler to resolve the problem.
> >
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> >  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > index 8955f8c..bf95cca 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > @@ -484,6 +484,18 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy,
> > struct net_device *netdev,  }
> >
> >  /*
> > + * CFG802.11 operation handler to set default mgmt key.
> > + */
> > +static int
> > +mwifiex_cfg80211_set_default_mgmt_key(struct wiphy *wiphy,
> > +				      struct net_device *netdev,
> > +				      u8 key_index)
> > +{
> > +	wiphy_dbg(wiphy, "set default mgmt key, key index=%d\n",
> key_index);
> > +	return 0;
> > +}
> > +
> > +/*
> >   * This function sends domain information to the firmware.
> >   *
> >   * The following information are passed to the firmware - @@ -4002,6
> > +4014,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
> >  	.leave_ibss = mwifiex_cfg80211_leave_ibss,
> >  	.add_key = mwifiex_cfg80211_add_key,
> >  	.del_key = mwifiex_cfg80211_del_key,
> > +	.set_default_mgmt_key = mwifiex_cfg80211_set_default_mgmt_key,
> >  	.mgmt_tx = mwifiex_cfg80211_mgmt_tx,
> >  	.mgmt_frame_register = mwifiex_cfg80211_mgmt_frame_register,
> >  	.remain_on_channel = mwifiex_cfg80211_remain_on_channel,
> 
> Is it correct to ignore the key index? I see that brcmfmac ignores it as
> well but I want to still confirm this.
> 
> Does this mean that with this patcfh mwifiex properly supports MFP?
> 

Yes. We do pass MFP tests with this patch.

Regards,
Amitkumar
