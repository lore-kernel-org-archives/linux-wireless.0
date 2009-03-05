Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58737 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbZCEAAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 19:00:05 -0500
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: reinette chatre <reinette.chatre@intel.com>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <c4d76b3b0903041147s2138e72bjb39864f87b4cd09e@mail.gmail.com>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <c4d76b3b0901261913s23427b19tbbe34ee7b4261068@mail.gmail.com>
	 <c4d76b3b0901261935n1846b675w72cfa7308d198080@mail.gmail.com>
	 <20090127162437.GA3596@sortiz.org>
	 <c4d76b3b0901271531q19578871idbc59b5a23ac868e@mail.gmail.com>
	 <1ba2fa240901272312j270eedb5x33534a9703d26e06@mail.gmail.com>
	 <20090128113751.GA3197@sortiz.org>
	 <c4d76b3b0903011937p6538adbfpc0dab859a6742394@mail.gmail.com>
	 <1236141120.12734.2.camel@rainbow> <1236194370.6612.73.camel@rc-desk>
	 <c4d76b3b0903041147s2138e72bjb39864f87b4cd09e@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 16:04:53 -0800
Message-Id: <1236211493.6612.90.camel@rc-desk> (sfid-20090305_010010_804294_A974D7BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-03-04 at 11:47 -0800, Jason Andryuk wrote:
> On Wed, Mar 4, 2009 at 2:19 PM, reinette chatre
> <reinette.chatre@intel.com> wrote:
> > On Tue, 2009-03-03 at 20:32 -0800, Jason Andryuk wrote:
> >> On Sun, Mar 1, 2009 at 10:37 PM, Jason Andryuk <jandryuk@gmail.com> wrote:
> >> > I tested c2a0aa3cb733452e749727680e380dca6cc10a68 "iwl3945: use
> >> > iwl_rb_status" with the additional patches to initialize rb_stts
> >> > (copied from iwl_rx_queue_alloc) and to convert the BUG_ON to a
> >> > WARN_ON.
> >> >
> >> > The driver runs without segfaulting.  So far the WARN_ON has not been
> >> > triggered, but the driver fails to finish authentication with the AP.
> >> > I receive "wlan0: authentication with AP 00:30:bd:c0:90:24 timed out"
> >>
> >> Ok, I started poking around with manually checking interesting commits instead of git bisect.
> >>
> >> 55b3e21... iwl3945: use iwl-io.h and delete iwl-3945-io.h with BUG->WARN patch works.
> >>
> >> bb64785... iwlwifi: use iwl_cmd instead of iwl3945_cmd
> >> fails to authenticate to the AP.  It generates a Microcode SW Error attached below.
> >>
> >> The previous revision:
> >> a0dedce... iwlwifi: replace IWL_ERROR with IWL_ERR
> >> Authenticates to the AP and works just fine.
> >>
> >> I keep looking over commitdiff bb64785... but I cannot see what is causing problems.  I even tried modifying iwl3945_cmd in various ways from a0dedce... but those attempts kept working.
> >>
> >> During testing, I saw a lot of UNKNOWN 0x1b
> >> [ 8892.625374] ieee80211 phy0: I iwl3945_rx_handle r = 162, i = 160, UNKNOWN, 0x1b
> >> Currently in the logs for commit a0dedce... it shows up as REPLY_3945_RX.
> >>
> >> Any ideas?
> >
> > Thank you very much for this digging.
> >
> > Are you running on 64bit?
> 
> Yes, 64bit.

could you please try this patch on top of latest wireless-testing?

Thanks

Reinette


diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 0a75053..00b25a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -743,6 +743,7 @@ void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	struct iwl3945_tfd *tfd_tmp = (struct iwl3945_tfd *)txq->tfds;
 	struct iwl3945_tfd *tfd = &tfd_tmp[txq->q.read_ptr];
 	struct pci_dev *dev = priv->pci_dev;
+	int index = txq->q.read_ptr;
 	int i;
 	int counter;
 
@@ -759,6 +760,13 @@ void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 		return;
 	}
 
+	/* Unmap tx_cmd */
+	if (counter)
+		pci_unmap_single(dev,
+				pci_unmap_addr(&txq->cmd[index]->meta, mapping),
+				pci_unmap_len(&txq->cmd[index]->meta, len),
+				PCI_DMA_TODEVICE);
+
 	/* unmap chunks if any */
 
 	for (i = 1; i < counter; i++) {




