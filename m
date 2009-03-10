Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38763 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbZCJSb3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 14:31:29 -0400
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	Samuel Ortiz <samuel@sortiz.org>,
	Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <c4d76b3b0903100610v21da8728l1414ca0187f29376@mail.gmail.com>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <1236194370.6612.73.camel@rc-desk>
	 <c4d76b3b0903041147s2138e72bjb39864f87b4cd09e@mail.gmail.com>
	 <1236211493.6612.90.camel@rc-desk> <1236297052.6153.4.camel@rainbow>
	 <1236299085.6612.229.camel@rc-desk>	 <1236312734.19328.37.camel@rainbow>
	 <1236317982.12430.9.camel@rc-desk>	 <1236649234.6685.9.camel@rainbow>
	 <1236661466.15923.53.camel@rc-desk>
	 <c4d76b3b0903100610v21da8728l1414ca0187f29376@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-5TgvDj6NueY6mUni68Rx"
Date: Tue, 10 Mar 2009 11:22:45 -0700
Message-Id: <1236709365.3911.1.camel@abhi-desktop> (sfid-20090310_193134_014795_D92ED442)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5TgvDj6NueY6mUni68Rx
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Jason,
  Can you take a look at the patch and test it? I am not sure how the
tip of your git looks like but you can make changes easily by looking at
the patch.

Thanks,
Abhijeet
On Tue, 2009-03-10 at 06:10 -0700, Jason Andryuk wrote:
> > I am finding it hard to keep track of things as what works and what does
> > not work appears to shift. I did install a 64bit system in the hopes of
> > reproducing your issue but could not with a basic open connect. How do
> > you connect to the AP? Please provide details that you think will enable
> > me to reproduce.
> 
> I am trying to connect to an unencrypted 802.11b AP.
> 
> Back in January, after first encountering the BUG, I attempted a git
> bisect, but I ran into problems.
> 
> From earlier git bisect attempts, I found commit
> "738910c064ff461051cd37e17199f270ff88a9a3 iwl3945: use rx queue
> management infrastructure from iwlcore" is the first to trigger the
> original BUG_ON.
> 
> "commit cbd8b90ffd8a321ffb2a705733729f0d5ebb20f9 iwl3945:
> iwl3945_queue and iwl3945_channel_info replacement" worked
> successfully.
> 
> Unfortunately, the conversion of iwl3945 leaves the driver inoperable
> at many places between the two commits above, so a bisect fails on
> account of other issues.  I have been spending time progressing from
> cbd8b90f... to 738910c0... and fixing issues as encountered.
> Following the commits on this page,
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=shortlog;h=738910c064ff461051cd37e17199f270ff88a9a3
> , I am trying to get from "cbd8b90ffd8a321ffb2a705733729f0d5ebb20f9
> iwl3945: iwl3945_queue and iwl3945_channel_info replacement" to the
> top.
> 
> While doing that, I have to fix errors to get the driver functional.
> 
> Basically, I am doing a manual bisect where I have to fix the errors
> at each stage.  But it isn't truly a bisect as I am progressing from
> cbd8b90f... to 738910c0...
> 
> On Tue, Mar 10, 2009 at 1:04 AM, reinette chatre
> <reinette.chatre@intel.com> wrote:
> > Hi Jason,
> >
> > On Mon, 2009-03-09 at 18:40 -0700, Jason Andryuk wrote:
> >> I thought I had made a big breakthrough when I found the solution to
> >> getting
> >> "iwlwifi: use iwl_cmd instead of iwl3945_cmd"
> >> bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d to work.  Then I discovered
> >> that casting to iwl3945_tx_cmd was fixed later by "iwl3945: use
> >> iwl3945_tx_cmd instead of iwl_tx_cmd" fadd267e...
> >
> >
> > Does this mean if you apply commit fadd267e on top of
> > bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d then things work?
> 
> No.  My patch, which is basically fadd267e..., completes the
> transition of bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d and allows the
> driver to work at *that* stage.
> bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d and fadd267e should have been
> one commit.
> 
> >>
> >> However, with this new knowledge, I was able to get farther.
> >>
> >> Using my iwl3945_tx_cmd conversion patch,
> >
> > Is this the last patch you emailed?
> 
> I don't have the patch in front of me, but it is basically fadd267e
> 
> >> a patch for allocating rb_stts
> 
> It is basically the reverse of this patch from Sam Ortiz *I think*.
> Again, I don't have it in front of me.  Commit "
> c2a0aa3cb733452e749727680e380dca6cc10a68 iwl3945: use iwl_rb_status"
> has a NULL pointer dereference since it doesn't allocate rb_stts.
> 
> ---
>  drivers/net/wireless/iwlwifi/iwl-rx.c |    8 --------
>  1 file changed, 8 deletions(-)
> 
> Index: wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-rx.c
> 2009-01-27 17:13:46.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c
> 2009-01-27 17:15:46.000000000 +0100
> @@ -346,11 +346,6 @@ int iwl_rx_queue_alloc(struct iwl_priv *
>        if (!rxq->bd)
>                goto err_bd;
> 
> -       rxq->rb_stts = pci_alloc_consistent(dev, sizeof(struct iwl_rb_status),
> -                                       &rxq->rb_stts_dma);
> -       if (!rxq->rb_stts)
> -               goto err_rb;
> -
>        /* Fill the rx_used queue with _all_ of the Rx buffers */
>        for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
>                list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
> @@ -362,9 +357,6 @@ int iwl_rx_queue_alloc(struct iwl_priv *
>        rxq->need_update = 0;
>        return 0;
> 
> -err_rb:
> -       pci_free_consistent(priv->pci_dev, 4 * RX_QUEUE_SIZE, rxq->bd,
> -                           rxq->dma_addr);
>  err_bd:
>        return -ENOMEM;
>  }
> 
> >> and a patch for the BUG_ON -> WARN_ON,
> >
> > ... and this one
> 
> This is your patch from January 9
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index a23d51d..09c1c8d 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -3118,7 +3118,14 @@ static void iwl3945_tx_cmd_complete(struct
> iwl_priv *priv,
>         int cmd_index;
>         struct iwl_cmd *cmd;
> 
> -       BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
> +       if (WARN(txq_id != IWL_CMD_QUEUE_NUM,
> +                "wrong command queue %d, sequence 0x%X readp=%d writep=%d\n",
> +                 txq_id, sequence,
> +                 priv->txq[IWL_CMD_QUEUE_NUM].q.read_ptr,
> +                 priv->txq[IWL_CMD_QUEUE_NUM].q.write_ptr)) {
> +               iwl_print_hex_dump(priv, IWL_DL_INFO , rxb, 32);
> +               return;
> +       }
> 
>         cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
>         cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
> 
> 
> >>  I was able to narrow down commit
> >> "iwl3945: sync tx queue data structure with iwlagn"
> >> ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f as the one that starts
> >> introducing Microcode SW errors.
> >>
> >
> > I am not sure how your repository looks at this stage. What is your
> > latest wireless-testing commit and what patches do you have on top of
> > it?
> 
> The repo looks like this:
> git checkout -f ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f
> patch -p1 < ../iwl-tx-cmd-conversion.patch
> patch -p1 < ../iwl-rb_stts.patch
> patch -p1 < ../iwl-BUG-to-WARN.patch
> 
> The previous commit with the above patches works.
> 
> >> I tried adding in Reinette's iwl3945_hw_txq_free_tfd pci_unmap_single
> >> patch from earlier, but it did not fix the problem.
> >>
> >> Would TX debugging output be more helpful?
> >
> > You log below has a new error (similar to what you note in your next
> > email). "Unsupported interface type 515". This is very strange and
> > really looks like some corruption as this value is initialized with a
> > macro during probe. Could you enable mac and info debugging also (add
> > 0x3 to your current debug flags)? This code has also changed a bit since
> > commit bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d.
> >
> > You can also put a dump_stack() in iwl3945_connection_init_rx_config to
> > see where the call comes from and then trace the value of mode to see
> > where it is set to 515 ... it is supposed to be 2
> > (NL80211_IFTYPE_STATION).
> 
> It may be a little while before I can get back to this.
> 
> Thanks for looking into it.
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-5TgvDj6NueY6mUni68Rx
Content-Disposition: attachment; filename=0001-iwl3945-use-iwl_tx_cmd_complete.patch
Content-Type: application/mbox; name=0001-iwl3945-use-iwl_tx_cmd_complete.patch
Content-Transfer-Encoding: 7bit

>From 82940a202f56d601f4c4844f6b3bdf19ae2dad9a Mon Sep 17 00:00:00 2001
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Date: Tue, 10 Mar 2009 11:23:00 -0700
Subject: [PATCH] iwl3945: use iwl_tx_cmd_complete

iwl3945 uses iwl_tx_cmd_complete to reclaim the unused buffers of the queue.
iwl_tx_cmd_complete in turn call the iwl_hcmd_queue_reclaim which will
unmap the dma mapping to tx_cmd and frees the memory.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   81 +--------------------------
 1 files changed, 1 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index fd3a529..93f70df 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1479,85 +1479,6 @@ static void iwl3945_setup_rx_handlers(struct iwl_priv *priv)
 	iwl3945_hw_rx_handler_setup(priv);
 }
 
-/**
- * iwl3945_cmd_queue_reclaim - Reclaim CMD queue entries
- * When FW advances 'R' index, all entries between old and new 'R' index
- * need to be reclaimed.
- */
-static void iwl3945_cmd_queue_reclaim(struct iwl_priv *priv,
-				      int txq_id, int index)
-{
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
-	int nfreed = 0;
-
-	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
-		IWL_ERR(priv, "Read index for DMA queue txq id (%d), index %d, "
-			  "is out of range [0-%d] %d %d.\n", txq_id,
-			  index, q->n_bd, q->write_ptr, q->read_ptr);
-		return;
-	}
-
-	for (index = iwl_queue_inc_wrap(index, q->n_bd); q->read_ptr != index;
-		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
-		if (nfreed > 1) {
-			IWL_ERR(priv, "HCMD skipped: index (%d) %d %d\n", index,
-					q->write_ptr, q->read_ptr);
-			queue_work(priv->workqueue, &priv->restart);
-			break;
-		}
-		nfreed++;
-	}
-}
-
-
-/**
- * iwl3945_tx_cmd_complete - Pull unused buffers off the queue and reclaim them
- * @rxb: Rx buffer to reclaim
- *
- * If an Rx buffer has an async callback associated with it the callback
- * will be executed.  The attached skb (if present) will only be freed
- * if the callback returns 1
- */
-static void iwl3945_tx_cmd_complete(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
-	int txq_id = SEQ_TO_QUEUE(sequence);
-	int index = SEQ_TO_INDEX(sequence);
-	int huge =  !!(pkt->hdr.sequence & SEQ_HUGE_FRAME);
-	int cmd_index;
-	struct iwl_cmd *cmd;
-
-	if (WARN(txq_id != IWL_CMD_QUEUE_NUM,
-		 "wrong command queue %d, sequence 0x%X readp=%d writep=%d\n",
-		  txq_id, sequence,
-		  priv->txq[IWL_CMD_QUEUE_NUM].q.read_ptr,
-		  priv->txq[IWL_CMD_QUEUE_NUM].q.write_ptr)) {
-		iwl_print_hex_dump(priv, IWL_DL_INFO , rxb, 32);
-		return;
-	}
-
-	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
-	cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
-
-	/* Input error checking is done when commands are added to queue. */
-	if (cmd->meta.flags & CMD_WANT_SKB) {
-		cmd->meta.source->u.skb = rxb->skb;
-		rxb->skb = NULL;
-	} else if (cmd->meta.u.callback &&
-		   !cmd->meta.u.callback(priv, cmd, rxb->skb))
-		rxb->skb = NULL;
-
-	iwl3945_cmd_queue_reclaim(priv, txq_id, index);
-
-	if (!(cmd->meta.flags & CMD_ASYNC)) {
-		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
-		wake_up_interruptible(&priv->wait_command_queue);
-	}
-}
-
 /************************** RX-FUNCTIONS ****************************/
 /*
  * Rx theory of operation
@@ -1917,7 +1838,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 			 * fire off the (possibly) blocking iwl_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb && rxb->skb)
-				iwl3945_tx_cmd_complete(priv, rxb);
+				iwl_tx_cmd_complete(priv, rxb);
 			else
 				IWL_WARN(priv, "Claim null rxb?\n");
 		}
-- 
1.5.4.3


--=-5TgvDj6NueY6mUni68Rx--

