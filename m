Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54128 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbZLWCah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 21:30:37 -0500
Date: Tue, 22 Dec 2009 21:26:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] rtl8180: remove priv->mode
Message-ID: <20091223022618.GB20928@tuxdriver.com>
References: <1261523585-20635-1-git-send-email-linville@tuxdriver.com> <69e28c910912221537l6e296f2ub8e9821be7c0ba04@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910912221537l6e296f2ub8e9821be7c0ba04@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 23, 2009 at 12:37:27AM +0100, Gábor Stefanik wrote:
> On Wed, Dec 23, 2009 at 12:13 AM, John W. Linville

> > @@ -661,12 +656,14 @@ static int rtl8180_add_interface(struct ieee80211_hw *dev,
> >  {
> >        struct rtl8180_priv *priv = dev->priv;
> >
> > -       if (priv->mode != NL80211_IFTYPE_MONITOR)
> > -               return -EOPNOTSUPP;
> > +       /*
> > +        * We only support one active interface at a time.
> > +        */
> > +       if (priv->vif != NULL)
> 
> if (priv->vif)
> This should be enough.

Sure, probably so.  FWIW, I think I copied that from some other driver.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
