Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54746 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbdKUSyG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 13:54:06 -0500
Subject: Re: [v3] ath10k: rebuild crypto header in rx data frames
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>
References: <1509035774-26553-1-git-send-email-kvalo@qca.qualcomm.com>
 <59b2ec22dc9c4db0bd30a65dba660b1c@euamsexm01a.eu.qualcomm.com>
 <154f13b8-1e77-dbe5-4cb0-81c534dbc40b@dd-wrt.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <e98b52a7-ac14-81da-1fab-0c66befcf6d2@candelatech.com> (sfid-20171121_195415_403959_277DB45E)
Date: Tue, 21 Nov 2017 10:54:03 -0800
MIME-Version: 1.0
In-Reply-To: <154f13b8-1e77-dbe5-4cb0-81c534dbc40b@dd-wrt.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is this patch destined for stable?

I was expecting to see it show up in the older stable releases,
but it has not so far as far as I can tell.

Thanks,
Ben

On 10/30/2017 02:32 AM, Sebastian Gottschall wrote:
> will check it tomorrow including gcmp-256, ccmp-256. was out for weekend :-)
>
> Am 30.10.2017 um 09:39 schrieb Kalle Valo:
>> Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>
>>> Rx data frames notified through HTT_T2H_MSG_TYPE_RX_IND and
>>> HTT_T2H_MSG_TYPE_RX_FRAG_IND expect PN/TSC check to be done
>>> on host (mac80211) rather than firmware. Rebuild cipher header
>>> in every received data frames (that are notified through those
>>> HTT interfaces) from the rx_hdr_status tlv available in the
>>> rx descriptor of the first msdu. Skip setting RX_FLAG_IV_STRIPPED
>>> flag for the packets which requires mac80211 PN/TSC check support
>>> and set appropriate RX_FLAG for stripped crypto tail. Hw QCA988X,
>>> QCA9887, QCA99X0, QCA9984, QCA9888 and QCA4019 currently need the
>>> rebuilding of cipher header to perform PN/TSC check for replay
>>> attack.
>>>
>>> Please note that removing crypto tail for CCMP-256, GCMP and GCMP-256 ciphers
>>> in raw mode needs to be fixed. Since Rx with these ciphers in raw
>>> mode does not work in the current form even without this patch and
>>> removing crypto tail for these chipers needs clean up, raw mode related
>>> issues in CCMP-256, GCMP and GCMP-256 can be addressed in follow up
>>> patches.
>>>
>>> Tested-by: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
>>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> Patch applied to ath-current branch of ath.git, thanks.
>>
>> 7eccb738fce5 ath10k: rebuild crypto header in rx data frames
>>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
