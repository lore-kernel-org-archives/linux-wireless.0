Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36466 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbbJZKLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 06:11:37 -0400
Received: by pacfv9 with SMTP id fv9so192845023pac.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2015 03:11:37 -0700 (PDT)
Message-ID: <562DFC61.7080108@gmail.com> (sfid-20151026_111141_039765_DDE95C04)
Date: Mon, 26 Oct 2015 15:41:45 +0530
From: Manikanta <manikanta.pubbisetty@gmail.com>
MIME-Version: 1.0
To: Albino B Neto <bino@bino.us>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: update antenna configuration after setting in
 fw
References: <1445851330-18736-1-git-send-email-manikanta.pubbisetty@gmail.com> <CAMu38xLre1jS7Vjsc3sL80oTkVhg5YQJV-U-CXeEQo8k2Zqp-A@mail.gmail.com>
In-Reply-To: <CAMu38xLre1jS7Vjsc3sL80oTkVhg5YQJV-U-CXeEQo8k2Zqp-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Monday 26 October 2015 03:35 PM, Albino B Neto wrote:
> 2015-10-26 7:22 GMT-02:00  <manikanta.pubbisetty@gmail.com>:
>> Signed-off-by: Manikanta Pubbisetty <manikanta.pubbisetty@gmail.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/mac.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index 484c1a1..8d0ce37 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -3771,9 +3771,6 @@ static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
>>          ath10k_check_chain_mask(ar, tx_ant, "tx");
>>          ath10k_check_chain_mask(ar, rx_ant, "rx");
>>
>> -       ar->cfg_tx_chainmask = tx_ant;
>> -       ar->cfg_rx_chainmask = rx_ant;
>> -
>>          if ((ar->state != ATH10K_STATE_ON) &&
>>              (ar->state != ATH10K_STATE_RESTARTED))
>>                  return 0;
>> @@ -3794,6 +3791,9 @@ static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
>>                  return ret;
>>          }
>>
>> +       ar->cfg_tx_chainmask = tx_ant;
>> +       ar->cfg_rx_chainmask = rx_ant;
>> +
>>          return 0;
>>   }
> Sorry, I see no change in the code. script checkpatch.pl ?
I have moved these two lines of code from the start of the function to 
the end, in between there is code for setting the antenna config in 
firmware. You can find in commit log why I have moved the code down in 
the function.

-Manikanta

