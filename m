Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47560 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbaIWQsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 12:48:13 -0400
Message-ID: <5421A44C.8080307@candelatech.com> (sfid-20140923_184828_237567_36B64067)
Date: Tue, 23 Sep 2014 09:48:12 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: use configured nss instead of max nss.
References: <1411426820-4047-1-git-send-email-greearb@candelatech.com> <CA+BoTQn9sECMNZsxQpB4i3wHPxfVL+LXq9=2GBd-opH6+9TD=A@mail.gmail.com>
In-Reply-To: <CA+BoTQn9sECMNZsxQpB4i3wHPxfVL+LXq9=2GBd-opH6+9TD=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/2014 01:59 AM, Michal Kazior wrote:
> On 23 September 2014 01:00,  <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> When re-associating a station, the nss was set back to
>> maximum value even if user had configured small number
>> of tx chains.  So, pay attention to user's config in
>> this case as well.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/mac.c | 11 +++++++++--
>>  1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index 855c71c..c5d31cc 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -4086,6 +4086,10 @@ ath10k_default_bitrate_mask(struct ath10k *ar,
>>         u32 legacy = 0x00ff;
>>         u8 ht = 0xff, i;
>>         u16 vht = 0x3ff;
>> +       u16 nrf = ar->num_rf_chains;
>> +
>> +       if (ar->cfg_tx_chainmask)
>> +               nrf = get_nss_from_chainmask(ar->cfg_tx_chainmask);
> 
> Oh, so you do update the peer nss value here.

Yeah, I found this was needed in further testing yesterday...

> I think it might be a good idea to convey the limitation of tx/rx
> chainmask to the user: you can't change the tx/rx chainmask on the fly
> easily (while connected/have associated stations). Or do you plan to
> schedule peer reassoc in __ath10k_set_antenna() in a follow up
> patch(es) later?

My user-space tools assume you have to re-connect (requested from user-space)
after changing the chainmask.  I was under the impression that this
is how ath9k works, though I could be wrong.

I would rather keep this requirement in user-space...

I am not sure where to document this...just a comment in the code?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

