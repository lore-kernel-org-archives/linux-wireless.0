Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48199 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751395AbbLKJXL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 04:23:11 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Nishant Sarmukadam" <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH] mwifiex: parse hscfg_gpio info from device tree
Date: Fri, 11 Dec 2015 09:23:06 +0000
Message-ID: <f65e448bfd344867afbf6c002cdfc2bf@SC-EXCH04.marvell.com> (sfid-20151211_102319_049011_921E333A)
References: <1448618297-19803-1-git-send-email-akarwar@marvell.com>
 <87vb855qpe.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87vb855qpe.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Friday, December 11, 2015 2:04 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Nishant Sarmukadam; Xinming Hu;
> devicetree@vger.kernel.org
> Subject: Re: [PATCH] mwifiex: parse hscfg_gpio info from device tree
> 
> + devicetree list
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > From: Xinming Hu <huxm@marvell.com>
> >
> > This patch reads hscfg_gpio from device tree and update internal
> > variable
> >
> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> >  drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> > b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> > index e486867..d28a53f 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> > @@ -1459,10 +1459,21 @@ int mwifiex_dnld_dt_cfgdata(struct
> > mwifiex_private *priv,  #ifdef CONFIG_OF
> >  	struct property *prop;
> >  	size_t len = strlen(prefix);
> > +	u32 data;
> >  	int ret;
> >
> >  	/* look for all matching property names */
> >  	for_each_property_of_node(node, prop) {
> > +		if (!strncmp(prop->name, "marvell,hscfg_gpio",
> > +			     strlen("marvell,hscfg_gpio"))) {
> > +			if (!of_property_read_u32(priv->adapter->dt_node,
> > +						  prop->name, &data)) {
> > +				dev_dbg(priv->adapter->dev,
> > +					"hscfg gpio = 0x%x\n", data);
> > +				priv->adapter->hs_cfg.gpio = data;
> > +			}
> > +		}
> 
> I don't see this documented in Documentation/devicetree/bindings. Please
> create a binding document and review it with the device tree
> maintainers.
> 
> Actually when looking mwifiex close I see that it uses more undocumented
> device tree interfaces:
> 
> marvell_cfgdata
> marvell,caldata
> marvell,00_txpwrlimit
> 
> I think these all should be properly documented and reviewed. But I'll
> let the device tree people chime in what's the best way.
> 

Thanks for the review.
Sure. We will document existing DT interfaces and create updated version of this patch which includes documentation in bindings.

Regards,
Amit
