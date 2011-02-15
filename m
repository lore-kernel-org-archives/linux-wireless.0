Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab1BOLsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 06:48:08 -0500
Subject: Re: [PATCH] iwlwifi: zero fill txq->txb on queue reset
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110215113951.GD2162@redhat.com>
References: <1297693999-15342-1-git-send-email-sgruszka@redhat.com>
	 <1297695219.3953.5.camel@jlt3.sipsolutions.net>
	 <1297695325.3953.6.camel@jlt3.sipsolutions.net>
	 <20110215113951.GD2162@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 12:48:02 +0100
Message-ID: <1297770482.3935.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-15 at 12:39 +0100, Stanislaw Gruszka wrote:

> > > >  	if (txq_id == priv->cmd_queue)
> > > >  		actual_slots++;
> > > > +	else
> > > > +		memset(txq->txb, 0, sizeof(txq->txb[0]) * TFD_QUEUE_SIZE_MAX);
> > > 
> > > I don't mind -- but I think the changelog should say that this isn't
> > > necessary since the device will never use any of those entries?
> > 
> > Err, I confused txb and tfds. But it still shouldn't be necessary --
> > aren't the entries reset to NULL when taken out of use?
> 
> There are memset zero before the use in {iwlagn,iwl3945}_tx_skb(),
> so patch is unneeded as well kzalloc in current code (I add replace
> to kmalloc to my todo list).

Well, don't worry, the change is fine -- I just wanted to understand if
I missed something that made it necessary.

johannes

