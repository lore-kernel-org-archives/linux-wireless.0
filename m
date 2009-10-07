Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from galiil.marvell.com ([199.203.130.254]:43125 "EHLO
	galiil.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbZJGBMp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 21:12:45 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andrey Yurovsky <andrey@cozybit.com>
CC: "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 6 Oct 2009 18:12:04 -0700
Subject: RE: [PATCH] libertas: Use lbs_is_cmd_allowed() check in command
 	handling routines.
Message-ID: <477F20668A386D41ADCC57781B1F704306DDD5C33D@SC-VEXCH1.marvell.com>
References: <1254873770-31241-1-git-send-email-bzhao@marvell.com>
 <45e8e6c40910061801u2b67abb5v4658a7bbf1e0726a@mail.gmail.com>
In-Reply-To: <45e8e6c40910061801u2b67abb5v4658a7bbf1e0726a@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrey,

> -----Original Message-----
> From: Andrey Yurovsky [mailto:andrey@cozybit.com]
> Sent: Tuesday, October 06, 2009 6:01 PM
> To: Bing Zhao
> Cc: libertas-dev@lists.infradead.org; Amitkumar Karwar; linux-wireless@vger.kernel.org
> Subject: Re: [PATCH] libertas: Use lbs_is_cmd_allowed() check in command handling routines.
> 
> Hi Bing,
> 
> On Tue, Oct 6, 2009 at 5:02 PM, Bing Zhao <bzhao@marvell.com> wrote:
> > From: Amitkumar Karwar <akarwar@marvell.com>
> > +static int lbs_is_cmd_allowed(struct lbs_private *priv)
> > +{
> > +       int         ret = 1;
> > +
> > +       lbs_deb_enter(LBS_DEB_CMD);
> > +
> > +       if (!priv->is_auto_deep_sleep_enabled) {
> > +               if (priv->is_deep_sleep) {
> > +                       lbs_deb_cmd("IOCTLS called when station"
> > +                                       " is in deep sleep\n");
> > +                       ret = 0;
> > +               }
> > +       }
> 
> Can this debug message be something like "command not allowed in deep
> sleep" instead of mentioning IOCTLS?

Thanks for your suggestion. Yes, it will be changed.

Regards,

Bing

> 
>   -Andrey
