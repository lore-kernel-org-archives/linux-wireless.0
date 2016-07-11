Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:34715 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbcGKMYm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 08:24:42 -0400
Received: by mail-lf0-f42.google.com with SMTP id h129so71204378lfh.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 05:24:41 -0700 (PDT)
Received: from [192.168.10.110] ([147.83.206.88])
        by smtp.gmail.com with ESMTPSA id j192sm4285344lfg.28.2016.07.11.05.24.36
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jul 2016 05:24:36 -0700 (PDT)
To: linux-wireless <linux-wireless@vger.kernel.org>
From: Joan Josep Aleixendri <jj.aleixendri@gmail.com>
Subject: A question about MAC80211 (3.9)
Message-ID: <349f74d9-ee27-8abb-afce-96532fec5e80@gmail.com> (sfid-20160711_142445_986626_7732B830)
Date: Mon, 11 Jul 2016 14:24:33 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everybody!


I'm a student working on a project about mac80211. I'm trying to modify 
the behaviour of the AC's queues but I could really need some help about 
this subject.


We are implementing a rate control algorithm. To do this we enqueue 
packets on ieee80211_tx_frags() function, just after we are sure the 
packet is going to be submitted to the driver under the standard code. 
You can see the code below


The problem is that once we send a packet that was going to the driver 
to the pending queue (because our custom logic), the tasklet takes over 
and tries to resubmit the packet to tx_frags(). The result is that we 
start losing connection and queuing the same packet over and over. Is 
there a way to stop the tasklet for some defined period of time? Or 
maybe another advice to implement rate limiting at mac80211?


Thanks for your time! And i really appreciate your help!


Joan Josep Aleixendri Cruelles


Code:

ieee80211_tx_frags():

     spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
         if (local->queue_stop_reasons[q] ||
             (!txpending && !skb_queue_empty(&local->pending[q]))) {
                 if (unlikely(info->flags &
                         IEEE80211_TX_INTFL_OFFCHAN_TX_OK)) {
                     if (local->queue_stop_reasons[q] &
~BIT(IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL)) {
                          /*
                          * Drop off-channel frames if queues
                          * are stopped for any reason other
                          * than off-channel operation. Never
                          * queue them.
                          */
                          spin_unlock_irqrestore(
&local->queue_stop_reason_lock,
                                  flags);
ieee80211_purge_tx_queue(&local->hw,
                                  skbs);
                              return true;
                          }
                      } else {
                          /*
                          * Since queue is stopped, queue up frames for
                          * later transmission from the tx-pending
                          * tasklet when the queue is woken again.
                          */
                          if (txpending)
skb_queue_splice_init(skbs,
                                  &local->pending[q]);
                          else
                              skb_queue_splice_tail_init(skbs,
&local->pending[q]);

spin_unlock_irqrestore(&local->queue_stop_reason_lock,
flags);
                          return false;
                      }
                  }
++           // CUSTOM CODE
++           if(packet_meets_requirements_to_be_xmitted()){
++               goto xmit;
++           }
++           else{
++               //Send the packet back to pending
++               if (txpending)
++                   skb_queue_splice_init(skbs,
++                           &local->pending[q]);
++               else
++                   skb_queue_splice_tail_init(skbs,
++                           &local->pending[q]);
++ spin_unlock_irqrestore(&local->queue_stop_reason_lock,
++                       flags);
++               return false;
++           }
++           xmit:
spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);

          info->control.vif = vif;
          control.sta = sta;

          __skb_unlink(skb, skbs);
          drv_tx(local, &control, skb);
      }

return true;
