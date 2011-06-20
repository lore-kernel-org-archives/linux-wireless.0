Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:36491 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755689Ab1FTTGg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 15:06:36 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Julian Calaby <julian.calaby@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Joe Perches <joe@perches.com>
Date: Mon, 20 Jun 2011 12:06:08 -0700
Subject: RE: [PATCH] mwifiex: remove casts of void pointers
Message-ID: <477F20668A386D41ADCC57781B1F704307FF88DA9B@SC-VEXCH1.marvell.com> (sfid-20110620_210640_012477_1A5D60E9)
References: <1308352468-8926-1-git-send-email-bzhao@marvell.com>
 <BANLkTi=3cQkhEOkSb08A=8VLrqzkwXJEhw@mail.gmail.com>
In-Reply-To: <BANLkTi=3cQkhEOkSb08A=8VLrqzkwXJEhw@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

Thanks for your comments.

> -----Original Message-----
> From: Julian Calaby [mailto:julian.calaby@gmail.com]
> Sent: Sunday, June 19, 2011 6:10 PM
> To: Bing Zhao
> Cc: linux-wireless@vger.kernel.org; John W. Linville; Johannes Berg; Amitkumar Karwar; Kiran Divekar;
> Yogesh Powar; Frank Huang; Joe Perches
> Subject: Re: [PATCH] mwifiex: remove casts of void pointers
> 
> Bing,
> 
> Good work!
> 
> There's one minor issue I've seen:
> 
> On Sat, Jun 18, 2011 at 09:14, Bing Zhao <bzhao@marvell.com> wrote:
> > diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
> > index 8af3a78..d5c987a 100644
> > --- a/drivers/net/wireless/mwifiex/sta_cmd.c
> > +++ b/drivers/net/wireless/mwifiex/sta_cmd.c
> > @@ -300,7 +291,7 @@ static int mwifiex_cmd_tx_power_cfg(struct host_cmd_ds_command *cmd,
> >                                  sizeof(struct mwifiex_types_power_group) +
> >                                  pg_tlv->length);
> >                } else {
> > -                       memmove(cmd_txp_cfg, data_buf,
> > +                       memmove(cmd_txp_cfg, txp,
> >                                sizeof(struct host_cmd_ds_txpwr_cfg));
> 
> this could be replace with
> 
> memmove(cmd_txp_cfg, txp, sizeof(*txp));
> 
> I think (I might be wrong about the argument to sizeof().)

I think that sizeof(struct host_cmd_ds_txpwr_cfg) and sizeof(*txp) are the same. Since more people prefer the later I will re-send v2 patch to address above change.

> 
> 
> Also, there are a number of functions touched by this patch that
> return a value through the former *data_buf parameter. Is it possible
> to refactor them to return the value directly? This would make the
> function flow a lot cleaner and easier to follow.

We will investigate this and update you later.

Thanks,
Bing
