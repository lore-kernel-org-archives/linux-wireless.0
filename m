Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35421 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751299AbdGSPAj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 11:00:39 -0400
Subject: Re: ath10k_htt_rx_amsdu_allowed() noise
To: Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <edbe270b-ba70-b844-f814-53d04d07d253@gmail.com>
 <79f47b0b-eb71-db71-2700-e30b01b11c76@qca.qualcomm.com>
From: Gabriel C <nix.or.die@gmail.com>
Message-ID: <ba10dfac-37c4-20d7-1c08-3ee988aff1c6@gmail.com> (sfid-20170719_170101_046413_E3513E86)
Date: Wed, 19 Jul 2017 17:00:36 +0200
MIME-Version: 1.0
In-Reply-To: <79f47b0b-eb71-db71-2700-e30b01b11c76@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18.07.2017 09:14, Ryan Hsu wrote:
> On 07/16/2017 03:56 PM, Gabriel C wrote:
> 
>>
>> Can ath10k_warn() be ath10k_dbg() there ? Maybe this ?
>>
> 
> Looks good to me.
> 
>>
>>  From d4138d936635ca7b69ed7f7b0cda4914f0f07917 Mon Sep 17 00:00:00 2001
>> From: Gabriel Craciunescu <nix.or.die@gmail.com>
>> Date: Mon, 17 Jul 2017 00:45:29 +0200
>> Subject: [PATCH] ath10k_htt_rx_amsdu_allowed(): change ath10k_warn() to th10k_dbg()
>>
>> Signed-off-by: Gabriel Craciunescu <nix.or.die@gmail.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/htt_rx.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> index 398dda978d6e..ad0306cd6ee1 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> @@ -1514,7 +1514,7 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k *ar,
>>           */
>>
>>          if (!rx_status->freq) {
>> -               ath10k_warn(ar, "no channel configured; ignoriframe(s)!\n");
>> +               ath10k_dbg(ar, ATH10K_DBG_HTT, "no channel configured, ignoring frame(s)!\n");
>>                  return false;
>>          }
>>
> 
> Can you send this as patch for reviewing, please?
> 

Sure .. I'll try to send the patch to the list later on today..

Regards,

Gabriel C
