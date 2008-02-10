Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:37333 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYBJPws (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 10:52:48 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH 06/12] Add support for monitor mode
Date: Sun, 10 Feb 2008 16:52:26 +0100
Cc: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>
References: <20080210145733.17592.61729.stgit@tikku> <20080210150034.17592.71617.stgit@tikku> <200802101649.28711.mb@bu3sch.de>
In-Reply-To: <200802101649.28711.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802101652.26733.mb@bu3sch.de> (sfid-20080210_155251_753642_EABF31AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 10 February 2008 16:49:28 Michael Buesch wrote:
> > +	flags = changed_flags & AT76_SUPPORTED_FILTERS;
> > +	*total_flags = AT76_SUPPORTED_FILTERS;
> 
> &= is needed instead of =
> 
> > +
> > +	/* FIXME: access to priv->promisc should be protected with
> > +	 * priv->mtx, but it's impossible because this function needs to be
> > +	 * atomic */
> > +
> > +	if (flags && !priv->promisc) {

and you must use *total_flags instead of the changed flags here.
So you can drop the local "flags" variable.

> > +		/* mac80211 wants us to enable promiscuous mode */
> > +		priv->promisc = 1;
> > +	} else if (!flags && priv->promisc) {

same here.

> > +		/* we need to disable promiscuous mode */
> > +		priv->promisc = 0;
> > +	} else
> > +		return;
> > +
> > +	queue_work(hw->workqueue, &priv->work_set_promisc);


-- 
Greetings Michael.
