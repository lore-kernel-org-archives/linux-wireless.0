Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:33251 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751271AbcJ0QUp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 12:20:45 -0400
Received: by mail-qk0-f193.google.com with SMTP id x11so2864675qka.0
        for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2016 09:20:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161027142103.19756-1-johannes@sipsolutions.net>
References: <20161027142103.19756-1-johannes@sipsolutions.net>
From: Dave Taht <dave.taht@gmail.com>
Date: Thu, 27 Oct 2016 09:20:43 -0700
Message-ID: <CAA93jw6GfrMyg3RGBnUoXh26V+1fTHrFub4g=uLkDYd4tjRGtA@mail.gmail.com> (sfid-20161027_182048_946723_9598D170)
Subject: Re: [RFC] mac80211: set wifi_acked[_valid] bits for transmitted SKBs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 27, 2016 at 7:21 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> There may be situations in which the in-kernel originator of an
> SKB cares about its wifi transmission status. To have that, set
> the wifi_acked[_valid] bits before freeing/orphaning the SKB if
> the destructor is set. The originator can then use it in there.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/status.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index ddf71c648cab..dc3132d0effe 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -541,6 +541,11 @@ static void ieee80211_report_used_skb(struct ieee802=
11_local *local,
>         } else if (info->ack_frame_id) {
>                 ieee80211_report_ack_skb(local, info, acked, dropped);
>         }
> +
> +       if (!dropped && skb->destructor) {
> +               skb->wifi_acked_valid =3D 1;
> +               skb->wifi_acked =3D acked;
> +       }
>  }

One of the things I've been curious about one day trying to take advantage =
of
is the pacing available from sch_fq, in a world where we were trying
to take advantage of the chocolatey goodness of the new TCP BBR
congestion control algorithm. (sch_fq is apparently required for BBR
to work right)

By moving the fq_codel algo into the softmac layer as we are doing, we
currently expose the "noqueue" interface to the qdisc layer, there, which
works great for routers, but for dual use (acting as a NAS host and
routing) seems less than ideal.

Now it turns out that you can indeed slap the fq qdisc on top of the
new wifi intermediate queues code...

dave@nemesis:~/slashdot$ tc -s qdisc show dev wlp3s0
qdisc fq 8001: root refcnt 5 limit 10000p flow_limit 100p buckets 1024
orphan_mask 1023 quantum 3028 initial_quantum 15140 refill_delay
40.0ms
 Sent 30828141202 bytes 20530733 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
  1127 flows (1127 inactive, 0 throttled)
  0 gc, 117 highprio, 714646 throttled

but as 1127 inactive flows have been there for a day now, and don't
show up in netstat, I guess that somewhere in here we aren't
"retiring" a skb in a way the tcp stack understands.

root@nemesis:~/slashdot# tc qdisc del dev wlp3s0 root
root@nemesis:~/slashdot# tc -s qdisc show dev wlp3s0
qdisc noqueue 0: root refcnt 2
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0





>
>  /*
> --
> 2.9.3
>



--=20
Dave T=C3=A4ht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
