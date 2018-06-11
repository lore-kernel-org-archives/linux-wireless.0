Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:38672 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932440AbeFKUV6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jun 2018 16:21:58 -0400
Date: Mon, 11 Jun 2018 22:21:56 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, tglx@linutronix.de
Subject: Locking in carl9170
Message-ID: <20180611202156.ts3ldjvmjqpsi56o@linutronix.de> (sfid-20180611_222202_134234_1834BAFC)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been locking at the USB completion handler and stumbled upon this
driver. The code path:
 carl9170_usb_rx_irq_complete()
 -> carl9170_handle_command_response()
  -> carl9170_cmd_callback()
     spin_lock(&ar->cmd_lock);

  -> carl9170_update_beacon()
      spin_lock_bh(&ar->beacon_lock);

  -> carl9170_tx_process_status()
   -> __carl9170_tx_process_status()
    -> carl9170_get_queued_skb()
       spin_lock_bh(&queue->lock);

      -> carl9170_release_dev_space()
         spin_lock_bh(&ar->mem_lock);
…

I planned to make all locks use spin_lock_irqsave().
carl9170_usb_rx_irq_complete() is called by HCD's completion handler
which is invoked mostly in IRQ context except for EHCI/DWC2 which invoke
the completion callback in tasklet/BH context. Currently there is a
local_irq_save() before invoking the ->complete callback which I plan to
remove, therefore the push-down. The _irqsave() would reflect the
current status. 
The locks I mentioned use only the _bh() suffix in other places. I
*think* lockdep is not complaining about this on EHCI but should
complain on other controllers which really complete in IRQ-context.
Could you please check if this is the case?

Sebastian
