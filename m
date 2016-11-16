Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33850 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbcKPIHD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 03:07:03 -0500
Received: by mail-wm0-f68.google.com with SMTP id g23so8393687wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2016 00:07:03 -0800 (PST)
Subject: Re: [PATCH 05/10] rt2800: make ba_size depend on ampdu_factor
To: Stanislaw Gruszka <sgruszka@redhat.com>
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
 <1478095865-8651-6-git-send-email-sgruszka@redhat.com>
 <ebc4779b-a68b-f3b3-c8fc-87db9401a603@kresin.me>
 <20161114084536.GB12372@redhat.com> <20161114124323.GA31857@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>
From: Mathias Kresin <dev@kresin.me>
Message-ID: <e4dfaa30-7dd6-c485-3e30-71bfafbc1502@kresin.me> (sfid-20161116_090707_845920_236EFF82)
Date: Wed, 16 Nov 2016 09:07:00 +0100
MIME-Version: 1.0
In-Reply-To: <20161114124323.GA31857@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

14.11.2016 13:43, Stanislaw Gruszka:
> On Mon, Nov 14, 2016 at 09:45:36AM +0100, Stanislaw Gruszka wrote:
>> Could you check below patch and see if it helps? If it does not,
>> could you printk sta->ht_cap.ampdu_density and ba_size values
>> and provide them here.
>
> Actually please print parameters from below patch. I think ba_size
> should be based on per TID buf_size instead of ampdu_factor, in case
> STA has buf size different for some TIDs.
>
> Also adding Felix to cc since my orginal patch:
> http://marc.info/?l=linux-wireless&m=147809595316289&w=2
> was shamelessly stolen from mt76 driver. Perhaps Felix could provide
> us some expertise.
>
> Thanks
> Stanislaw
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index 2515702..35bc38c 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -7950,6 +7950,8 @@ int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  	struct rt2x00_sta *sta_priv = (struct rt2x00_sta *)sta->drv_priv;
>  	int ret = 0;
>
> +	printk("action %d sta %pM tid %u buf_size %u ampdu_factor %u\n", params->action, sta->addr, params->tid, params->buf_size, sta->ht_cap.ampdu_factor);
> +
>  	/*
>  	 * Don't allow aggregation for stations the hardware isn't aware
>  	 * of because tx status reports for frames to an unknown station
>

Here are the results of the requested tests. Please keep in mind, I'm 
not in a lab environment:

LEDE head
   connect
     action 0 sta 9c:f3:87:bc:AA:BB tid 6 buf_size 64 ampdu_factor 3
     action 2 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
     action 6 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 64 ampdu_factor 3
     action 0 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 64 ampdu_factor 3

   wireless (iperf client) to wired (iperf server)
     Interval           Transfer     Bandwidth
       0.00-60.01  sec   544 MBytes  76.1 Mbits/sec           sender
       0.00-60.01  sec   544 MBytes  76.1 Mbits/sec           receiver

   wired (iperf client) to wireless (iperf server)
     Interval           Transfer     Bandwidth       Retr
       0.00-60.00  sec   609 MBytes  85.1 Mbits/sec   96      sender
       0.00-60.00  sec   606 MBytes  84.8 Mbits/sec           receiver

   on interface down
     action 4 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
     action 1 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
     action 1 sta 9c:f3:87:bc:AA:BB tid 6 buf_size 0 ampdu_factor 3

LEDE + vanilla driver (without LEDE rt2x00 patches)
   connect
     action 0 sta 9c:f3:87:bc:AA:BB tid 6 buf_size 64 ampdu_factor 3
     action 2 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
     action 6 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 64 ampdu_factor 3
     action 0 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 64 ampdu_factor 3

   wireless (iperf client) to wired (iperf server)
     Interval           Transfer     Bandwidth
       0.00-60.02  sec   522 MBytes  73.0 Mbits/sec           sender
       0.00-60.02  sec   522 MBytes  73.0 Mbits/sec           receiver

   wired (iperf client) to wireless (iperf server)
     Interval           Transfer     Bandwidth       Retr
       0.00-60.00  sec   583 MBytes  81.5 Mbits/sec  104      sender
       0.00-60.00  sec   581 MBytes  81.2 Mbits/sec           receiver

   on interface down
     action 4 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
     action 1 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
     action 1 sta 9c:f3:87:bc:AA:BB tid 6 buf_size 0 ampdu_factor 3

LEDE + vanilla driver + patchset
   connect
     action 0 sta 9c:f3:87:bc:AA:BB tid 6 buf_size 64 ampdu_factor 3
     action 2 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
     action 6 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 64 ampdu_factor 3
     action 0 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 64 ampdu_factor 3

   wireless (iperf client) to wired (iperf server)
     Interval           Transfer     Bandwidth
       0.00-60.02  sec   377 MBytes  52.7 Mbits/sec           sender
       0.00-60.02  sec   377 MBytes  52.6 Mbits/sec           receive

     on interface down
       action 4 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
       action 1 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
       action 1 sta 9c:f3:87:bc:AA:BB tid 6 buf_size 0 ampdu_factor 3
       ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue 2 failed
                       to flush
       ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue 2 failed
                       to flush

   wired (iperf client) to wireless (iperf server)
     * not reliable reproducible stalls/reconnects:
         action 1 sta 9c:f3:87:bc:AA:BB tid 6 buf_size 0 ampdu_factor 3
         action 2 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
         action 0 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 64 ampdu_factor 3
         action 6 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 64 ampdu_factor 3
         action 0 sta 9c:f3:87:bc:AA:BB tid 6 buf_size 64 ampdu_factor 3
     * one time I've seen this:
         ieee80211 phy0: rt2x00lib_rxdone_read_signal: Warning - Frame
                         received with unrecognized signal, mode=0x0001,
                         signal=0x010c, type=4
     * sometimes the same rt2x00queue_flush_queue warning on interface
       down

     Interval           Transfer     Bandwidth       Retr
       0.00-60.00  sec   576 MBytes  80.6 Mbits/sec  447      sender
       0.00-60.00  sec   574 MBytes  80.2 Mbits/sec           receiver

     on interface down
       action 4 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
       action 1 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
       action 1 sta 9c:f3:87:bc:AA:BB tid 6 buf_size 0 ampdu_factor 3

LEDE + vanilla driver + patchset + increased max psdu
   connect
     action 0 sta 9c:f3:87:bc:AA:BB tid 6 buf_size 64 ampdu_factor 3
     action 2 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
     action 6 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 64 ampdu_factor 3
     action 0 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 64 ampdu_factor 3

   wireless (iperf client) to wired (iperf server)
     Interval           Transfer     Bandwidth
       0.00-60.02  sec   366 MBytes  51.1 Mbits/sec           sender
       0.00-60.02  sec   365 MBytes  51.1 Mbits/sec           receiver

   wired (iperf client) to wireless (iperf server)
     Interval           Transfer     Bandwidth       Retr
       0.00-60.00  sec   569 MBytes  79.6 Mbits/sec  471      sender
       0.00-60.00  sec   566 MBytes  79.1 Mbits/sec           receiver

   on interface down
     action 4 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
     action 1 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
     action 1 sta 9c:f3:87:bc:AA:BB tid 6 buf_size 0 ampdu_factor 3
     ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue 2 failed
                     to flush
     ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue 2 failed
                     to flush
