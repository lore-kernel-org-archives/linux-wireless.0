Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51636 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab1JYKkT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:40:19 -0400
Received: by iaby12 with SMTP id y12so405693iab.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Oct 2011 03:40:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111021142429.250845759@sipsolutions.net>
References: <20111021142322.229128720@sipsolutions.net>
	<20111021142429.250845759@sipsolutions.net>
Date: Tue, 25 Oct 2011 12:40:18 +0200
Message-ID: <CAB3XZEe3_BjseD3J-k7-USeUYkODTpvbpjpT=14OO6o+-Ya+XQ@mail.gmail.com> (sfid-20111025_124027_798226_5BB497EB)
Subject: Re: [RFC v2 08/12] net: add wireless TX status socket option
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 21, 2011 at 4:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The 802.1X EAPOL handshake hostapd does requires
> knowing whether the frame was ack'ed by the peer.
> Currently, we fudge this pretty badly by not even
> transmitting the frame as a normal data frame but
> injecting it with radiotap and getting the status
> out of radiotap monitor as well. This is rather
> complex, confuses users (mon.wlan0 presence) and
> doesn't work with all hardware.
>
> To get rid of that hack, introduce a real wifi TX
> status option for data frame transmissions.
>
> This works similar to the existing TX timestamping
> in that it reflects the SKB back to the socket's
> error queue with a SCM_WIFI_STATUS cmsg that has
> an int indicating ACK status (0/1).
>
> Since it is possible that at some point we will
> want to have TX timestamping and wifi status in a
> single errqueue SKB (there's little point in not
> doing that), redefine SO_EE_ORIGIN_TIMESTAMPING
> to SO_EE_ORIGIN_TXSTATUS which can collect more
> than just the timestamp; keep the old constant
> as an alias of course. Currently the internal APIs
> don't make that possible, but it wouldn't be hard
> to split them up in a way that makes it possible.
>
> Thanks to Neil Horman for helping me figure out
> the functions that add the control messages.
>
> TODO:
>  * sock_tx_timestamp() function should be renamed,
>   maybe to sock_tx_status()?
>  * sock_recv_timestamp() should also be renamed,
>   I had a hard time figuring out the difference
>   between that and sock_recv_ts_and_drops(). The
>   former is generic, while the latter adds RX
>   information only, maybe that should be reflected
>   in new names?
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]
>        __u8                    ooo_okay:1;
> +       __u8                    wifi_acked_valid:1;
> +       __u8                    wifi_acked:1;
> +       /* 11/13 bit hole (depending on nodetype presence) */
>        kmemcheck_bitfield_end(flags2);
>
>
> +void skb_complete_wifi_ack(struct sk_buff *skb, bool acked)
> +{
> +       struct sock *sk = skb->sk;
> +       struct sock_exterr_skb *serr;
> +       int err;
> +
> +       skb->wifi_acked_valid = 1;
> +       skb->wifi_acked = acked;
> +

i'm not sure it's an actual issue, but setting (u8:1) = (bool) seems wrong?

Eliad.
