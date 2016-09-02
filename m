Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52820 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750992AbcIBHkn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 03:40:43 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [v4,2/2] mwifiex: add cfg80211 testmode support
Date: Fri, 2 Sep 2016 07:40:40 +0000
Message-ID: <ab9817c5f2f44a5b80c8258962e94a58@SC-EXCH04.marvell.com> (sfid-20160902_094046_335287_DBD5B913)
References: <1469525960-6643-2-git-send-email-akarwar@marvell.com>
 <20160831194003.GA31478@localhost>
In-Reply-To: <20160831194003.GA31478@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Thursday, September 01, 2016 1:10 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> Xinming Hu
> Subject: Re: [v4,2/2] mwifiex: add cfg80211 testmode support
> 
> On Tue, Jul 26, 2016 at 03:09:20PM +0530, Amitkumar Karwar wrote:
> > From: Xinming Hu <huxm@marvell.com>
> >
> > This patch adds cfg80211 testmode support so that userspace tools can
> > download necessary commands to firmware during manufacturing mode
> tests.
> >
> > Signed-off-by: Xinming <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> > v4: Used cfg80211 testmode interface instead of wext in 2/2
> > patch.(Kalle Valo)
> > v3: Add "select WIRELESS_EXT" in Kconfig to resolve kbuild test robot
> errors.
> >     WEXT_PRIV seems to have a dependency with WIRELESS_EXT.
> > v2: 1) Sequence of these two patches are changed to resolve
> compilation
> >     error seen if only 1/2 is applied.
> >     2) Add "select WEXT_PRIV" in Kconfig to resolve warnings reported
> by
> >     kbuild test robot.
> > ---
> >  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 83
> > +++++++++++++++++++++++++
> >  1 file changed, 83 insertions(+)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > index 235fb39..86b31b1 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > @@ -3919,6 +3919,88 @@ static int mwifiex_cfg80211_get_channel(struct
> wiphy *wiphy,
> >  	return ret;
> >  }
> >
> > +#ifdef CONFIG_NL80211_TESTMODE
> > +
> > +enum mwifiex_tm_attr {
> > +	__MWIFIEX_TM_ATTR_INVALID	= 0,
> > +	MWIFIEX_TM_ATTR_CMD		= 1,
> > +	MWIFIEX_TM_ATTR_DATA		= 2,
> > +
> > +	/* keep last */
> > +	__MWIFIEX_TM_ATTR_AFTER_LAST,
> > +	MWIFIEX_TM_ATTR_MAX		= __MWIFIEX_TM_ATTR_AFTER_LAST - 1,
> > +};
> > +
> > +static const struct nla_policy mwifiex_tm_policy[MWIFIEX_TM_ATTR_MAX
> + 1] = {
> > +	[MWIFIEX_TM_ATTR_CMD]		= { .type = NLA_U32 },
> > +	[MWIFIEX_TM_ATTR_DATA]		= { .type = NLA_BINARY,
> > +					    .len = MWIFIEX_SIZE_OF_CMD_BUFFER },
> };
> > +
> > +enum mwifiex_tm_cmd {
> > +	MWIFIEX_TM_CMD_HOSTCMD	= 0,
> > +};
> > +
> > +int mwifiex_tm_cmd(struct wiphy *wiphy, struct wireless_dev *wdev,
> 
> This function should be static, no?
> 
> Brian
> 

Yes. This have been taken care of in V5 patch.

Regards,
Amitkumar Karwar
