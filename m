Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:43356 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934108Ab3FSPsC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 11:48:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Paul Stewart <pstew@chromium.org>
Date: Wed, 19 Jun 2013 08:45:44 -0700
Subject: RE: [PATCH 2/3] mwifiex: add basic 11h support for station
Message-ID: <477F20668A386D41ADCC57781B1F70430EA2BD5148@SC-VEXCH1.marvell.com> (sfid-20130619_174807_395069_EAC08E5F)
References: <1371598618-26593-1-git-send-email-bzhao@marvell.com>
 <1371598618-26593-2-git-send-email-bzhao@marvell.com>
 <20130619142446.GC12079@tuxdriver.com>
In-Reply-To: <20130619142446.GC12079@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Thanks for your comment.

> > @@ -427,6 +427,13 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
> >
> >  		break;
> >
> > +	case EVENT_CHANNEL_SWITCH_ANN:
> > +		dev_dbg(adapter->dev, "event: Channel Switch Announcement\n");
> > +		ret = mwifiex_send_cmd_async(priv,
> > +			HostCmd_CMD_802_11_DEAUTHENTICATE,
> > +			HostCmd_ACT_GEN_SET, 0,
> > +			priv->curr_bss_params.bss_descriptor.mac_address);
> > +
> >  	default:
> >  		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
> >  			eventcause);
> 
> Do you mean for this case to fall-through to the default case?

No. I will fix it in v2.

Thanks,
Bing

