Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:35229 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbeBBUNi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Feb 2018 15:13:38 -0500
Received: by mail-qt0-f180.google.com with SMTP id g14so32478239qti.2
        for <linux-wireless@vger.kernel.org>; Fri, 02 Feb 2018 12:13:37 -0800 (PST)
Subject: Re: [Make-wifi-fast] [PATCH] mac80211: Adjust TSQ pacing shift
To: "dpreed@deepplum.com" <dpreed@deepplum.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
References: <20180202151105.30043-1-toke@toke.dk>
 <1517590516.742814797@apps.rackspace.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A74C66D.3050509@broadcom.com> (sfid-20180202_211341_542192_86F46B2D)
Date: Fri, 2 Feb 2018 21:13:33 +0100
MIME-Version: 1.0
In-Reply-To: <1517590516.742814797@apps.rackspace.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/2/2018 5:55 PM, dpreed@deepplum.com wrote:
> I'm curious about the "WiFi Aware" initiative by the WiFi Alliance.
>
> Does LEDE and/or Linux support this protocol? I know gSupplicant is potentially the way such things are supposed to work, at least according to its supporters.
>
> The general NAN (Neighborhood-Aware-Networking) concept makes a lot of sense at one level, but as an Internet guy, it troubles me that they decided to split from the Internet and go a balkanized direction. To me, the neighborhood is interesting only as part of a larger Internet.
>
> It also troubles me that WiFi Aware is a "certification program" rather than a real standard.

It troubles me that you are breaking into an email conversation with a 
topic that in my opinion is totally unrelated. Although probably not 
intended as such it seems rude. Just start your own conversation.

Regards,
Arend

> -----Original Message-----
> From: "Toke Høiland-Jørgensen" <toke@toke.dk>
> Sent: Friday, February 2, 2018 10:11am
> To: make-wifi-fast@lists.bufferbloat.net, linux-wireless@vger.kernel.org
> Cc: "Toke Høiland-Jørgensen" <toke@toke.dk>
> Subject: [Make-wifi-fast] [PATCH] mac80211: Adjust TSQ pacing shift
>
> Since we now have the convenient helper to do so, actually adjust the
> TSQ pacing shift for packets going out over a WiFi interface. This
> significantly improves throughput for locally-originated TCP
> connections. The default pacing shift of 10 corresponds to ~1ms of
> queued packet data. Adjusting this to a shift of 8 (i.e. ~4ms) improves
> 1-hop throughput for ath9k by a factor of 3, whereas increasing it more
> has diminishing returns.
>
> Achieved throughput for different values of sk_pacing_shift (average of
> 5 iterations of 10-sec netperf runs to a host on the other side of the
> WiFi hop):
>
> sk_pacing_shift 10:  43.21 Mbps (pre-patch)
> sk_pacing_shift  9:  78.17 Mbps
> sk_pacing_shift  8: 123.94 Mbps
> sk_pacing_shift  7: 128.31 Mbps
>
> Latency for competing flows increases from ~3 ms to ~10 ms with this
> change. This is about the same magnitude of queueing latency induced by
> flows that are not originated on the WiFi device itself (and so are not
> limited by TSQ).
>
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> ---
>   net/mac80211/tx.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 25904af38839..69722504e3e1 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -3574,6 +3574,14 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
>   	if (!IS_ERR_OR_NULL(sta)) {
>   		struct ieee80211_fast_tx *fast_tx;
>
> +		/* We need a bit of data queued to build aggregates properly, so
> +		 * instruct the TCP stack to allow more than a single ms of data
> +		 * to be queued in the stack. The value is a bit-shift of 1
> +		 * second, so 8 is ~4ms of queued data. Only affects local TCP
> +		 * sockets.
> +		 */
> +		sk_pacing_shift_update(skb->sk, 8);
> +
>   		fast_tx = rcu_dereference(sta->fast_tx);
>
>   		if (fast_tx &&
>
