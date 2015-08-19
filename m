Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36492 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbbHSTQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 15:16:37 -0400
Received: by lbbpu9 with SMTP id pu9so9772275lbb.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2015 12:16:35 -0700 (PDT)
Subject: Re: [RFC v2 3/3] iwlwifi: mvm: transfer the truesize to the last TSO
 segment
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1439989181-4444-1-git-send-email-emmanuel.grumbach@intel.com>
 <1439989181-4444-4-git-send-email-emmanuel.grumbach@intel.com>
 <55D4D495.9070705@cogentembedded.com>
 <0BA3FCBA62E2DC44AF3030971E174FB32E8253B0@hasmsx107.ger.corp.intel.com>
Cc: "ido@wizery.com" <ido@wizery.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <55D4D611.1060201@cogentembedded.com> (sfid-20150819_211641_846598_ADCCBE0F)
Date: Wed, 19 Aug 2015 22:16:33 +0300
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8253B0@hasmsx107.ger.corp.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/19/2015 10:12 PM, Grumbach, Emmanuel wrote:

>>> This allows to release the backpressure on the socket only
>>> when the last segment is released.
>>> Now the truesize looks like this:
>>> if the truesize of the original skb is 65420, all the
>>> segments will have a truesize of 704 (skb itself) and the
>>> last one will have 65420.
>>>
>>> Change-Id: I3c894cf2afc0aedfe7b2a5b992ba41653ff79c0e
>>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>>> ---
>>>    drivers/net/wireless/iwlwifi/mvm/tx.c | 17 ++++++++++++++++-
>>>    1 file changed, 16 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
>>> index 5046833..046e50d 100644
>>> --- a/drivers/net/wireless/iwlwifi/mvm/tx.c
>>> +++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
>> [...]
>>> @@ -1034,6 +1035,20 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb_gso,
>>>    		}
>>>
>>>    		__skb_queue_tail(mpdus_skb, skb);
>>> +		sum_truesize += skb->truesize;
>>> +	}
>>> +
>>> +	/* Release the backpressure on the socket only when
>>> +	 * the last segment is released.
>>> +	 */
>>> +	if (skb_gso->destructor == sock_wfree) {
>
> I need to change the destructor function here as per Eric's comment.
>
>>> +		struct sk_buff *tail = mpdus_skb->prev;
>>> +
>>> +		swap(tail->truesize, skb_gso->truesize);
>>> +		swap(tail->destructor, skb_gso->destructor);
>>> +		swap(tail->sk, skb_gso->sk);
>>> +                atomic_add(sum_truesize - skb_gso->truesize,
>>
>>      Please indent using tabs, not spaces.
>
> I am happy this is the only flaw you found ;)

    It just jumped into my eyes. :-)

> Sure - I'll fix. And I'll remove the Change-ID and checkpatch will be
> happy.

    DaveM allows that tag in the networking patches, IIRC.

> No worries ;)

>>
>>> +                           &skb_gso->sk->sk_wmem_alloc);
>>>    	}
>>>
>>>    	ret = 0;

MBR, Sergei

