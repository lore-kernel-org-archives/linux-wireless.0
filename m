Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nyet.org ([66.175.217.148]:49826 "EHLO ln.curtisfong.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbeHRTTd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 15:19:33 -0400
Subject: Re: [PATCH] Fix Bug 199967 - change WARN_ON(1) to IWL_ERR()
To: Luciano Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org
References: <20180818033555.18110-1-nyet@nyet.org>
 <c052cdda16fa0df1b3672f4be9c20df053703ac0.camel@intel.com>
From: Nye Liu <nyet@nyet.org>
Message-ID: <084b662c-4701-9a18-ffb1-c661f4534d8c@nyet.org> (sfid-20180818_181123_702144_989DF870)
Date: Sat, 18 Aug 2018 09:11:18 -0700
MIME-Version: 1.0
In-Reply-To: <c052cdda16fa0df1b3672f4be9c20df053703ac0.camel@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/18/2018 1:41 AM, Luciano Coelho wrote:

> On Fri, 2018-08-17 at 20:35 -0700, Nye Liu wrote:
>> The TX_STATUS_FAIL_DEST_PS case fills logs with full backtraces, which
>> are pretty useless. Just do IWL_ERR() printk.
>>
>> Signed-off-by: Nye Liu <nyet@nyet.org>
>> ---
>>   drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
>> index cf2591f2ac23..87044953e6b4 100644
>> --- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
>> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
>> @@ -1407,8 +1407,10 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
>>   			/* the FW should have stopped the queue and not
>>   			 * return this status
>>   			 */
>> -			WARN_ON(1);
>>   			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
>> +			IWL_ERR(mvm, "TX_STATUS_FAIL_DEST_PS: "
>> +				"tid %d, status %x, flags %x\n", tid, status,
>> +				info->flags);
>>   			break;
>>   		default:
>>   			break;
> I think this error is serious enough and we would like to catch it when
> it occurs so we can debug the actual cause.
>
> But I agree that we shouldn't be repeating it millions of times.  What
> about just changing it to WARN_ON_ONCE() instead?
>
That would be fine, but IMO the WARN_ON() provides less information that 
the printk(). I'm not an IWL devel but there is limited information on 
the wifi state itself in the WARN() - just call stack and register 
information. Also, with WARN_ON_ONCE() the frequency of the error is masked.
