Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49891 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbcFQN2b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 09:28:31 -0400
Subject: Re: [PATCH 1/2] ath9k: use mac80211 intermediate software queues
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
References: <20160617090929.31606-1-toke@toke.dk>
 <20160617090929.31606-2-toke@toke.dk>
Cc: Tim Shepard <shep@alum.mit.edu>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <30beabff-a8c6-5431-be09-8f2f83ffc974@nbd.name> (sfid-20160617_153552_290843_B755C13A)
Date: Fri, 17 Jun 2016 15:28:26 +0200
MIME-Version: 1.0
In-Reply-To: <20160617090929.31606-2-toke@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-06-17 11:09, Toke Høiland-Jørgensen wrote:
> This patch leaves the code for ath9k's internal per-node per-tid
> queues in place and just modifies the driver to also pull from
> the new mac80211 intermediate software queues, and implements
> the .wake_tx_queue method, which will cause mac80211 to deliver
> packets to be sent via the new intermediate queue.
> 
> Signed-off-by: Tim Shepard <shep@alum.mit.edu>
> 
> Reworked to not require the global variable renaming in ath9k.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h     |  16 +++-
>  drivers/net/wireless/ath/ath9k/debug_sta.c |   7 +-
>  drivers/net/wireless/ath/ath9k/init.c      |   1 +
>  drivers/net/wireless/ath/ath9k/main.c      |   1 +
>  drivers/net/wireless/ath/ath9k/xmit.c      | 119 +++++++++++++++++++++++++----
>  5 files changed, 125 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index 93b3793..caeae10 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -145,8 +145,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
>  #define BAW_WITHIN(_start, _bawsz, _seqno) \
>  	((((_seqno) - (_start)) & 4095) < (_bawsz))
>  
> -#define ATH_AN_2_TID(_an, _tidno)  (&(_an)->tid[(_tidno)])
> -
>  #define IS_HT_RATE(rate)   (rate & 0x80)
>  #define IS_CCK_RATE(rate)  ((rate >= 0x18) && (rate <= 0x1e))
>  #define IS_OFDM_RATE(rate) ((rate >= 0x8) && (rate <= 0xf))
> @@ -232,8 +230,10 @@ struct ath_buf {
>  
>  struct ath_atx_tid {
>  	struct list_head list;
> +	struct sk_buff_head i_q;
Do we really need a third queue here? Instead of adding yet another
layer of queueing here, I think we should even get rid of buf_q.

Channel context based queue handling can be dealt with by
stopping/starting relevant queues on channel context changes.

buf_q becomes unnecessary when you remove all code in the drv_tx
codepath that moves frames to the intermediate queue.

Any frame that was pulled from the intermediate queue and prepared for
tx, but which can't be sent right now can simply be queued to retry_q.

This will also help with getting the diffstat insertion/deletion ratio
under control ;)

>  	struct sk_buff_head buf_q;
>  	struct sk_buff_head retry_q;
> +	struct ieee80211_txq *swq;
No need for this pointer, you can use container_of.

- Felix
