Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33369 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbbHSOY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 10:24:29 -0400
Message-ID: <1439994266.6610.14.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20150819_162445_271948_C70753FD)
Subject: Re: [RFC v2 3/3] iwlwifi: mvm: transfer the truesize to the last
 TSO segment
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, ido@wizery.com,
	netdev@vger.kernel.org
Date: Wed, 19 Aug 2015 07:24:26 -0700
In-Reply-To: <1439989181-4444-4-git-send-email-emmanuel.grumbach@intel.com>
References: <1439989181-4444-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1439989181-4444-4-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-08-19 at 15:59 +0300, Emmanuel Grumbach wrote:
> This allows to release the backpressure on the socket only
> when the last segment is released.
> Now the truesize looks like this:
> if the truesize of the original skb is 65420, all the
> segments will have a truesize of 704 (skb itself) and the
> last one will have 65420.
> 
> Change-Id: I3c894cf2afc0aedfe7b2a5b992ba41653ff79c0e
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/mvm/tx.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
> index 5046833..046e50d 100644
> --- a/drivers/net/wireless/iwlwifi/mvm/tx.c
> +++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
> @@ -764,7 +764,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb_gso,
>  	bool ipv6 = skb_shinfo(skb_gso)->gso_type & SKB_GSO_TCPV6;
>  	struct iwl_lso_splitter s = {};
>  	struct page *hdr_page;
> -	unsigned int mpdu_sz;
> +	unsigned int mpdu_sz, sum_truesize = 0;
>  	u8 *hdr_page_pos, *qc, tid;
>  	int i, ret;
>  
> @@ -898,6 +898,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb_gso,
>  						mpdu_sz, tcp_hdrlen(skb_gso));
>  
>  	__skb_queue_tail(mpdus_skb, skb_gso);
> +	sum_truesize += skb_gso->truesize;
>  
>  	/* mss bytes have been consumed from the data */
>  	s.gso_payload_pos = s.mss;
> @@ -1034,6 +1035,20 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb_gso,
>  		}
>  
>  		__skb_queue_tail(mpdus_skb, skb);
> +		sum_truesize += skb->truesize;
> +	}
> +
> +	/* Release the backpressure on the socket only when
> +	 * the last segment is released.
> +	 */
> +	if (skb_gso->destructor == sock_wfree) {
> +		struct sk_buff *tail = mpdus_skb->prev;
> +
> +		swap(tail->truesize, skb_gso->truesize);
> +		swap(tail->destructor, skb_gso->destructor);
> +		swap(tail->sk, skb_gso->sk);
> +                atomic_add(sum_truesize - skb_gso->truesize,
> +                           &skb_gso->sk->sk_wmem_alloc);
>  	}
>  
>  	ret = 0;

Using existing net/core/tso.c helpers would avoid using this.

(BTW TCP packets do not have sock_wfree as destructor but tcp_wfree(),
yet we want backpressure mostly for TCP stack (TCP Small Queues))


