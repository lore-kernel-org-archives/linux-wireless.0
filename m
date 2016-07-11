Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36411 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030787AbcGKOOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 10:14:18 -0400
Received: by mail-oi0-f44.google.com with SMTP id w18so5996700oiw.3
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 07:14:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <349f74d9-ee27-8abb-afce-96532fec5e80@gmail.com>
References: <349f74d9-ee27-8abb-afce-96532fec5e80@gmail.com>
From: Dave Taht <dave.taht@gmail.com>
Date: Mon, 11 Jul 2016 16:14:07 +0200
Message-ID: <CAA93jw6L7ym=P5ebtD1G40KRNraVnrqjVK8z8AgNvJEVnG8rnw@mail.gmail.com> (sfid-20160711_161434_470989_865BD80B)
Subject: Re: A question about MAC80211 (3.9)
To: Joan Josep Aleixendri <jj.aleixendri@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What are you trying to accomplish? I look forward to seeing any rate
control algorithm that can address the issues in minstrel!
( http://blog.cerowrt.org/post/minstrel/ )

It has generally been my hope to implement some form of better service
sharing between the VO, VI, and BE queues than what currently exists
in linux mainline... after the swq, fq_codel and airtime fairness
stuff finishes landing. (
https://blog.tohojo.dk/2016/06/fixing-the-wifi-performance-anomaly-on-ath9k.html
)

VO could only offer service once per 10ms per destination, VI, cap the
backlog at no more than 50ms, and in neither case starve BE, BK could
often be folded into BE, and so on. We've got bits of an architecture
for managing these queues discussed out (more discussion at ietf next
week), folding flows into the most appropriate queue rather than
treating them as totally separate. (so as to take better advantage of
aggregation)

Some of the other things in the make-wifi-fast backlog are in the appendix here:

https://docs.google.com/document/d/1Se36svYE1Uzpppe1HWnEyat_sAGghB3kE285LElJBW4/edit#heading=h.3ankl68j6jjo

On Mon, Jul 11, 2016 at 2:24 PM, Joan Josep Aleixendri
<jj.aleixendri@gmail.com> wrote:
> Hello everybody!
>
>
> I'm a student working on a project about mac80211. I'm trying to modify the
> behaviour of the AC's queues but I could really need some help about this
> subject.
>
>
> We are implementing a rate control algorithm. To do this we enqueue packets
> on ieee80211_tx_frags() function, just after we are sure the packet is going
> to be submitted to the driver under the standard code. You can see the code
> below
>
>
> The problem is that once we send a packet that was going to the driver to
> the pending queue (because our custom logic), the tasklet takes over and
> tries to resubmit the packet to tx_frags(). The result is that we start
> losing connection and queuing the same packet over and over. Is there a way
> to stop the tasklet for some defined period of time? Or maybe another advice
> to implement rate limiting at mac80211?
>
>
> Thanks for your time! And i really appreciate your help!
>
>
> Joan Josep Aleixendri Cruelles
>
>
> Code:
>
> ieee80211_tx_frags():
>
>     spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
>         if (local->queue_stop_reasons[q] ||
>             (!txpending && !skb_queue_empty(&local->pending[q]))) {
>                 if (unlikely(info->flags &
>                         IEEE80211_TX_INTFL_OFFCHAN_TX_OK)) {
>                     if (local->queue_stop_reasons[q] &
> ~BIT(IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL)) {
>                          /*
>                          * Drop off-channel frames if queues
>                          * are stopped for any reason other
>                          * than off-channel operation. Never
>                          * queue them.
>                          */
>                          spin_unlock_irqrestore(
> &local->queue_stop_reason_lock,
>                                  flags);
> ieee80211_purge_tx_queue(&local->hw,
>                                  skbs);
>                              return true;
>                          }
>                      } else {
>                          /*
>                          * Since queue is stopped, queue up frames for
>                          * later transmission from the tx-pending
>                          * tasklet when the queue is woken again.
>                          */
>                          if (txpending)
> skb_queue_splice_init(skbs,
>                                  &local->pending[q]);
>                          else
>                              skb_queue_splice_tail_init(skbs,
> &local->pending[q]);
>
> spin_unlock_irqrestore(&local->queue_stop_reason_lock,
> flags);
>                          return false;
>                      }
>                  }
> ++           // CUSTOM CODE
> ++           if(packet_meets_requirements_to_be_xmitted()){
> ++               goto xmit;
> ++           }
> ++           else{
> ++               //Send the packet back to pending
> ++               if (txpending)
> ++                   skb_queue_splice_init(skbs,
> ++                           &local->pending[q]);
> ++               else
> ++                   skb_queue_splice_tail_init(skbs,
> ++                           &local->pending[q]);
> ++ spin_unlock_irqrestore(&local->queue_stop_reason_lock,
> ++                       flags);
> ++               return false;
> ++           }
> ++           xmit:
> spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
>
>          info->control.vif = vif;
>          control.sta = sta;
>
>          __skb_unlink(skb, skbs);
>          drv_tx(local, &control, skb);
>      }
>
> return true;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Dave Täht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
