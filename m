Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:33002 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbbHSTKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 15:10:18 -0400
Received: by lalv9 with SMTP id v9so9136453lal.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2015 12:10:16 -0700 (PDT)
Subject: Re: [RFC v2 3/3] iwlwifi: mvm: transfer the truesize to the last TSO
 segment
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org
References: <1439989181-4444-1-git-send-email-emmanuel.grumbach@intel.com>
 <1439989181-4444-4-git-send-email-emmanuel.grumbach@intel.com>
Cc: ido@wizery.com, netdev@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <55D4D495.9070705@cogentembedded.com> (sfid-20150819_211022_344033_2FDBE0B7)
Date: Wed, 19 Aug 2015 22:10:13 +0300
MIME-Version: 1.0
In-Reply-To: <1439989181-4444-4-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 08/19/2015 03:59 PM, Emmanuel Grumbach wrote:

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
>   drivers/net/wireless/iwlwifi/mvm/tx.c | 17 ++++++++++++++++-
>   1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
> index 5046833..046e50d 100644
> --- a/drivers/net/wireless/iwlwifi/mvm/tx.c
> +++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
[...]
> @@ -1034,6 +1035,20 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb_gso,
>   		}
>
>   		__skb_queue_tail(mpdus_skb, skb);
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

    Please indent using tabs, not spaces.

> +                           &skb_gso->sk->sk_wmem_alloc);
>   	}
>
>   	ret = 0;

MBR, Sergei

