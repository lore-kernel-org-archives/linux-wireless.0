Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 39.mail-out.ovh.net ([213.251.138.60]:45533 "HELO
	39.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751666AbZA0QWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 11:22:13 -0500
Date: Tue, 27 Jan 2009 17:24:37 +0100
From: Samuel Ortiz <samuel@sortiz.org>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
Message-ID: <20090127162437.GA3596@sortiz.org> (sfid-20090127_172218_774118_763320BC)
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com> <20090126114453.GB3197@sortiz.org> <c4d76b3b0901261913s23427b19tbbe34ee7b4261068@mail.gmail.com> <c4d76b3b0901261935n1846b675w72cfa7308d198080@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c4d76b3b0901261935n1846b675w72cfa7308d198080@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jason,

On Mon, Jan 26, 2009 at 10:35:39PM -0500, Jason Andryuk wrote:
> On Mon, Jan 26, 2009 at 10:13 PM, Jason Andryuk <jandryuk@gmail.com> wrote:
> > I was away from the computer, so I would not have been able to test
> > anything anyway.
> >
> > I tested  wireless-testings of  master-2009-01-23 and had the same
> > inability to authenticate.  The WARNING (previous BUG) was triggered.
> > Below are the logs.
> >
> > I see wireless-testing merged some of your commits, so I'll go try those out.
> >
> > Jason
> 
> Same result: no authentication.  The "wrong command queue 0, sequence
> 0x0 readp=9 writep=9" message came twice right after Network Manager
> gave up and displayed the status of the interface as disconnected.
> 
> Is the "Microcode SW error detected. Restarting 0x82000008." message
> of concern?  I have seen that in all the traces.
No, that's just a consequence of the bug, not the bug itself.
Would you mind applying this patch on top of your latest wireless-testing tree
and testing 3945 with it ? Thanks for your patience.

---
 drivers/net/wireless/iwlwifi/iwl-rx.c |    8 --------
 1 file changed, 8 deletions(-)

Index: wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-rx.c	2009-01-27 17:13:46.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c	2009-01-27 17:15:46.000000000 +0100
@@ -346,11 +346,6 @@ int iwl_rx_queue_alloc(struct iwl_priv *
 	if (!rxq->bd)
 		goto err_bd;
 
-	rxq->rb_stts = pci_alloc_consistent(dev, sizeof(struct iwl_rb_status),
-					&rxq->rb_stts_dma);
-	if (!rxq->rb_stts)
-		goto err_rb;
-
 	/* Fill the rx_used queue with _all_ of the Rx buffers */
 	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
@@ -362,9 +357,6 @@ int iwl_rx_queue_alloc(struct iwl_priv *
 	rxq->need_update = 0;
 	return 0;
 
-err_rb:
-	pci_free_consistent(priv->pci_dev, 4 * RX_QUEUE_SIZE, rxq->bd,
-			    rxq->dma_addr);
 err_bd:
 	return -ENOMEM;
 }
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
