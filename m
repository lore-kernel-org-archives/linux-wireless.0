Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab3GaMFv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 08:05:51 -0400
Date: Wed, 31 Jul 2013 14:08:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Power saving features for iwl4965
Message-ID: <20130731120848.GA31732@redhat.com> (sfid-20130731_140555_187827_536EED36)
References: <20130603141804.GA2146@redhat.com>
 <CAJZjf_xoCOTFsLAB29uLKeW7+O+k255Amspn6GKFMysc7CTsBg@mail.gmail.com>
 <CAJZjf_xGdvStOG0=FR2+2WsVcjyizQukH+RxysZf8f9-Tk9L9w@mail.gmail.com>
 <20130611161924.GB1696@redhat.com>
 <CAJZjf_zOF=qGEE=pWDRe0YDpAYophm93cVM8pfuL0sTRGq56EA@mail.gmail.com>
 <20130614131829.GA5125@redhat.com>
 <20130625142514.GA1938@redhat.com>
 <CAJZjf_z=+QW_Y3yuz6nJ+muVA_6bGRut8EQ7fCopDqqj2Fn9Yw@mail.gmail.com>
 <20130716102743.GA8321@redhat.com>
 <CAJZjf_y9fnkHLp4YPdYY2sVo4r4+hKJcZAebJmjVKCBh-0EUtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
In-Reply-To: <CAJZjf_y9fnkHLp4YPdYY2sVo4r4+hKJcZAebJmjVKCBh-0EUtA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 17, 2013 at 12:48:30PM +0100, Pedro Francisco wrote:
> On Tue, Jul 16, 2013 at 11:27 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >> I seem only to be able to trigger it with disable_hw_scan=0, I need
> >> further testing with disable_hw_scan=1 (I use disable_hw_scan=0
> >> because it prevents me from getting disconnected from eduroam Cisco
> >> APs -- haven't tested disable_hw_scan=0 since the VOIP-friendly SW
> >> scanning patch, however).
> >>
> >> Do you want the log anyway? (modprobe iwl3945 debug=0x47ffffff
> >> disable_hw_scan=0 and runtime PCI powersave also enabled -- I don't
> >> know if it matters).
> >
> > As this is not causing troubles with default disable_hw_scan option,
> > I'll post that patch.
> 
> My mistake, I can trigger error conditions _independently_ of
> disable_hw_scan option being enabled or disabled, as long as powersave
> is enabled.
> 
> I'll send you a private email with the logs.

I think I found bug which couse this firmware crash. We have only 5
queues so updating write_ptr for txq[5] can cause random value write
to HBUS_TARG_WRPTR register. I also added spin_lock to do not abuse
writes we do in tx skb.

Please test attached patch (with powersave on :-)

Stanislaw


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iwlegacy_fix_wakeup_interrupt.patch"

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index b37a582..afa5c6e 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -1495,12 +1495,14 @@ il3945_irq_tasklet(struct il_priv *il)
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		D_ISR("Wakeup interrupt\n");
 		il_rx_queue_update_write_ptr(il, &il->rxq);
+
+		spin_lock_irqsave(&il->lock, flags);
 		il_txq_update_write_ptr(il, &il->txq[0]);
 		il_txq_update_write_ptr(il, &il->txq[1]);
 		il_txq_update_write_ptr(il, &il->txq[2]);
 		il_txq_update_write_ptr(il, &il->txq[3]);
 		il_txq_update_write_ptr(il, &il->txq[4]);
-		il_txq_update_write_ptr(il, &il->txq[5]);
+		spin_unlock_irqrestore(&il->lock, flags);
 
 		il->isr_stats.wakeup++;
 		handled |= CSR_INT_BIT_WAKEUP;

--azLHFNyN32YCQGCU--
