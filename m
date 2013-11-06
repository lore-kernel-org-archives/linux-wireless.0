Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14516 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab3KFMuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 07:50:16 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: Michal Kazior <michal.kazior@tieto.com>, <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH/RFT 12/12] ath10k: add some debug prints
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
	<1383133346-8135-13-git-send-email-michal.kazior@tieto.com>
	<1383153399.9435.33.camel@joe-AO722>
Date: Wed, 6 Nov 2013 14:43:10 +0200
In-Reply-To: <1383153399.9435.33.camel@joe-AO722> (Joe Perches's message of
	"Wed, 30 Oct 2013 10:16:39 -0700")
Message-ID: <87a9hhsntt.fsf@kamboji.qca.qualcomm.com> (sfid-20131106_135020_578561_AD68E159)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> On Wed, 2013-10-30 at 12:42 +0100, Michal Kazior wrote:
>> Some errors were handled too silently.
>
> These aren't really debug prints.

Yeah, the patch title needs work.

>> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> []
>> @@ -1860,8 +1862,10 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
>>  		ath10k_do_pci_wake(ar);
>>  
>>  	ret = ath10k_pci_ce_init(ar);
>> -	if (ret)
>> +	if (ret) {
>> +		ath10k_err("could not initialize CE (%d)\n", ret);
>
> Rather than try to reinterpret the function name,
> perhaps it's better to simply emit the function name
> as is done most other places like:
>
> 		ath10k_err("ath10k_pci_ce_init failed: (%d)\n", ret);

I don't think that's any better. When function names change but people
forget to change the error message and then it's even more confusing.
And I prefer that a developer puts a bit more effort to the warning
message by writing it in english instead of just copying the function
name.

-- 
Kalle Valo
