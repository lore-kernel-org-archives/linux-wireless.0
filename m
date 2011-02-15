Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598Ab1BOLkJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 06:40:09 -0500
Date: Tue, 15 Feb 2011 12:39:52 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: zero fill txq->txb on queue reset
Message-ID: <20110215113951.GD2162@redhat.com>
References: <1297693999-15342-1-git-send-email-sgruszka@redhat.com>
 <1297695219.3953.5.camel@jlt3.sipsolutions.net>
 <1297695325.3953.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297695325.3953.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 03:55:25PM +0100, Johannes Berg wrote:
> On Mon, 2011-02-14 at 15:53 +0100, Johannes Berg wrote:
> > On Mon, 2011-02-14 at 15:33 +0100, Stanislaw Gruszka wrote:
> > > We allocate txq->txb area with kzalloc, but when reseting queue
> > > during __iwl_down / __iwl_up we we leave old values, let's zero
> > > initialize in such case as well.
> > > 
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > > ---
> > >  drivers/net/wireless/iwlwifi/iwl-tx.c |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
> > > index a8935cd..0c8555c 100644
> > > --- a/drivers/net/wireless/iwlwifi/iwl-tx.c
> > > +++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
> > > @@ -418,6 +418,8 @@ void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
> > >  
> > >  	if (txq_id == priv->cmd_queue)
> > >  		actual_slots++;
> > > +	else
> > > +		memset(txq->txb, 0, sizeof(txq->txb[0]) * TFD_QUEUE_SIZE_MAX);
> > 
> > I don't mind -- but I think the changelog should say that this isn't
> > necessary since the device will never use any of those entries?
> 
> Err, I confused txb and tfds. But it still shouldn't be necessary --
> aren't the entries reset to NULL when taken out of use?

There are memset zero before the use in {iwlagn,iwl3945}_tx_skb(),
so patch is unneeded as well kzalloc in current code (I add replace
to kmalloc to my todo list).

Stanislaw
