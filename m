Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:33919 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3IAGQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Sep 2013 02:16:19 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Gabor Juhos <juhosg@openwrt.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/7] ath10k: remove void pointer from struct ath10k_pci_compl
References: <20130830122905.31164.50662.stgit@localhost6.localdomain6>
	<20130830123021.31164.8374.stgit@localhost6.localdomain6>
	<522104B1.2070004@openwrt.org>
Date: Sun, 1 Sep 2013 09:16:14 +0300
In-Reply-To: <522104B1.2070004@openwrt.org> (Gabor Juhos's message of "Fri, 30
	Aug 2013 22:46:41 +0200")
Message-ID: <878uzh83td.fsf@kamboji.qca.qualcomm.com> (sfid-20130901_081623_714591_1BCEF9CA)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos <juhosg@openwrt.org> writes:

> 2013.08.30. 14:30 keltezéssel, Kalle Valo írta:
>> Void pointers are bad, mmkay.
>> 
>> No functional changes.
>> 
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/pci.c |   12 ++++++------
>>  drivers/net/wireless/ath/ath10k/pci.h |    2 +-
>>  2 files changed, 7 insertions(+), 7 deletions(-)
>> 
>
> <snip>
>
>> @@ -1026,7 +1026,7 @@ static void ath10k_pci_process_ce(struct ath10k *ar)
>>  				break;
>>  			}
>>  
>> -			skb = (struct sk_buff *)compl->transfer_context;
>> +			skb = (struct sk_buff *)compl->skb;
>
> The cast can be removed from here as well.

Oh, I had missed that. I'll send v2 to fix that.

Thank you for the review.

-- 
Kalle Valo
