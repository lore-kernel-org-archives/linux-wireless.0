Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:57875 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaFBSx2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 14:53:28 -0400
Received: by mail-we0-f171.google.com with SMTP id w62so5682552wes.16
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jun 2014 11:53:26 -0700 (PDT)
Message-ID: <538CC827.6090408@gmail.com> (sfid-20140602_205331_820783_6A74996D)
Date: Mon, 02 Jun 2014 21:53:27 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: Help debugging iwldvm / ath10k stalls
References: <CALCETrUffJLp+AM2-13HEE5+cKtyMMSjJFsJnhcd5kMzebs3NA@mail.gmail.com> <CANUX_P3NrA2GgZ-Nqgvk7do7Kzqa9kgjtpn4t9TuLKzhmqTqjQ@mail.gmail.com> <CALCETrX1s504Ej7sQV292NfHgrKrV-Wigk0GP7wo6GyALaM9xA@mail.gmail.com> <CANUX_P3jMcV=7stRtPAFZBJVG9bE10iTC0sRK_o-7vTxpy9+9w@mail.gmail.com> <CALCETrVPXwedhPGtDJQDSK5Kxa4NpeSDck4-nHyox_xriPBcZQ@mail.gmail.com> <CALCETrW0NQ6aW06WD6ZAi8-o7fZSiKPOf0xYCSEw2egYBfqyQQ@mail.gmail.com> <CALCETrUTsKCw_G7V=YDeP-v_GF8cK8ezY-wqcpxeuw3dzBQhQg@mail.gmail.com> <CANUX_P2_GZGhd7X4Ntzi5Jeng52i9Jam22DQTTU2akESPL1ffQ@mail.gmail.com> <CALCETrWdQwvMcgC=PESyECzkyMD8-vzjNEHOCkm5z=ENH7coHg@mail.gmail.com> <CANUX_P2AKnUvUyddsGC5JST51bbjpavG3X-VbJhS1Mf7fDNPcw@mail.gmail.com> <CALCETrX8Km4dc-XM4Ga8T7spDJzN00jx162A3iuTo5+NWhGTZg@mail.gmail.com> <CALCETrUHX3XB2+j5=3ULd9zMpDUisj3ZtK5JVuVS8Dh6088TTw@mail.gmail.com> <538CC508.3070707@gmail.com> <CALCETrVrPt4uKNC43nNB08iMA=vK7pM0choHNdB3ctT7RQuepQ@mail.gmail.com>
In-Reply-To: <CALCETrVrPt4uKNC43nNB08iMA=vK7pM0choHNdB3ctT7RQuepQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>>>>
>>>> Anyway, I don't buy the theory that this is caused by the firmware
>>>> going out to lunch.  The queues files in debugfs show the rx queue
>>>> chugging along and all of the tx queues have read_ptr == write_ptr.
>>>> Wireshark shows incoming broadcast traffic, too.  I'd guess that the
>>>> problem is more likely to be that the card is failing to wake up and
>>>> notice pending data in the TIM.
>>
>> Well... I might have been unclear here (I never know how much detail I should share with the recipient :)).
>> From your log it appears that the NIC is in power save. So we can't increment the write pointer of the Tx ring (add a packet for transmission). So we simply remember that we need to do so (increment the write pointer) and request a wakeup so that we will update the write pointer in the wakeup interrupt... which doesn't happen.
>> No power save - no need for wakeup interrupt.
> 
> I'm still unconvinced.  One of the tx queues actually has a both
> read_ptr and write_ptr incrementing once or twice per second even when
> I can't ping the gateway.  Can you point me at the right code or log
> stuff to look at?

drivers/net/wireless/iwlwifi/pcie/tx.c:
static void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans,
                                    struct iwl_txq *txq)
[snip]

                if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
                        IWL_DEBUG_INFO(trans, "Tx queue %d requesting wakeup, GP1 = 0x%x\n",
                                       txq_id, reg);
                        iwl_set_bit(trans, CSR_GP_CNTRL,
                                    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
                        txq->need_update = true;
                        return;
                }
[snip]
}

ISR - drivers/net/wireless/iwlwifi/pcie/tx.c:
irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
{
[snip]
        /* uCode wakes up after power-down sleep */
        if (inta & CSR_INT_BIT_WAKEUP) {
                IWL_DEBUG_ISR(trans, "Wakeup interrupt\n");
                iwl_pcie_rxq_check_wrptr(trans);
                iwl_pcie_txq_check_wrptrs(trans);

                isr_stats->wakeup++;

                handled |= CSR_INT_BIT_WAKEUP;
        }
[snip]
}

drivers/net/wireless/iwlwifi/pcie/tx.c:
void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans)
{
        struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
        int i;

        for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
                struct iwl_txq *txq = &trans_pcie->txq[i];

                spin_lock_bh(&txq->lock);
                if (trans_pcie->txq[i].need_update) {
                        iwl_pcie_txq_inc_wr_ptr(trans, txq);
                        trans_pcie->txq[i].need_update = false;
                }
                spin_unlock_bh(&txq->lock);
        }
}

Note that the CMD queue (9 or 4 depending on your configuration) - uses another mechanism that is safer but consumes more power. This queue is intended for commands and not for real Tx packets.


> 
>>
>>>
>>> OTOH, with iwlwifi.11n_disable=4 (no rx A-MPDU), I seem to be doing
>>> pretty well.  I'll test a stock kernel configured like that for the
>>> next few days.
>>>
>>
>> That's interesting...
> 
> --Andy
> 
