Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:48374 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961Ab1JKM1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 08:27:10 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 11 Oct 2011 14:26:30 +0200
Subject: RE: [PATCH 17/34] iwlagn: fix a race in the unmapping of the TFDs
Message-ID: <4825B8A2C4E264489E57869F0DCFB2234457A944D0@hasmsx502.ger.corp.intel.com> (sfid-20111011_142714_059799_994B9D40)
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
 <1318256839-31837-18-git-send-email-wey-yi.w.guy@intel.com>
 <20111011122216.GA2218@redhat.com>
In-Reply-To: <20111011122216.GA2218@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Mon, Oct 10, 2011 at 07:27:02AM -0700, Wey-Yi Guy wrote:
> > While inspecting the code, I saw that iwl_tx_queue_unmap modifies
> > the read pointer of the Tx queue without taking any locks. This means
> > that it can race with the reclaim flow. This can possibly lead to
> > a DMA warning complaining that we unmap the same buffer twice.
> >
> > This is more a W/A than a fix since it is really weird to take
> > sta_lock inside iwl_tx_queue_unmap, but it can help until we revamp
> > the locking model in the transport layer.
> >
> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
> b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
> > index 60067c7..f69aecb 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
> > @@ -406,6 +406,7 @@ static void iwl_tx_queue_unmap(struct iwl_trans
> *trans, int txq_id)
> >  	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
> >  	struct iwl_queue *q = &txq->q;
> >  	enum dma_data_direction dma_dir;
> > +	unsigned long flags;
> >
> >  	if (!q->n_bd)
> >  		return;
> > @@ -418,12 +419,14 @@ static void iwl_tx_queue_unmap(struct iwl_trans
> *trans, int txq_id)
> >  	else
> >  		dma_dir = DMA_TO_DEVICE;
> >
> > +	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
> sta_lock does not look like right lock to use.
> 
True. And I wrote in the commit message that this is a W/A until we revamp the locking model.

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

