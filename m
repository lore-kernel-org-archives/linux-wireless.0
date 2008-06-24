Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:4946 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbYFXUcU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 16:32:20 -0400
Received: by an-out-0708.google.com with SMTP id d40so739918and.103
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 13:32:19 -0700 (PDT)
Message-ID: <486159C1.2070000@gmail.com> (sfid-20080624_223223_346625_FA11FF68)
Date: Tue, 24 Jun 2008 23:32:01 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: drago01 <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	Zhu Yi <yi.zhu@intel.com>, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with	disable_hw_scan=1
References: <48528CF0.8050204@gmail.com>	<1ba2fa240806131304n442972eatfd2f35034476c380@mail.gmail.com>	<48551C62.80904@gmail.com>	<1ba2fa240806150647mdc97d98oad0b1b02de1fcf87@mail.gmail.com>	<48552344.5090801@gmail.com>	<1ba2fa240806150809h13c28937nd064230baca8a15d@mail.gmail.com>	<1ba2fa240806150947s1ed9391ao4b1d1a91c871ef8f@mail.gmail.com>	<4855FF14.9080506@gmail.com>	<1ba2fa240806152252v5fdb4f7dn1028a2a02e8d9cd1@mail.gmail.com>	<f6ca9fed0806180128q739a9e3k68708b908e630324@mail.gmail.com> <20080624194714.GA11664@tuxdriver.com>
In-Reply-To: <20080624194714.GA11664@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Wed, Jun 18, 2008 at 10:28:04AM +0200, drago01 wrote:
>>>>> Please try this one
>>>>>
>>>>> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
>>>>> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
>>>>> @@ -3348,7 +3348,10 @@ static void
>>>>> iwl3945_rx_scan_complete_notif(struct iwl3945_priv *priv,
>>>>>
>>>>>        /* Remove this scanned band from the list
>>>>>         * of pending bands to scan */
>>>>> -       priv->scan_bands--;
>>>>> +       if (priv->cfg->sku & IWL_SKU_A)
>>>>> +               priv->scan_bands--;
>>>>> +       else
>>>>> +               priv->scan_bands = 0;
>>>>>
>>>>>
>>>>
>>>> I tested this patch, and it fixes this issue, Thanks a lot.
>>>>
>>> Thanks a lot for helping resolve this. I will post an official patch.
>> seems like a fix thats worth having in .26
> 
> Did I miss the official post of this patch?
> 
> John

I think patch wasn't posted, but it is committed to wireless tree
commit 085fa962fdeb09b17b8052f5f1da353949829e9d
iwlwifi: improve scanning band selection management


Best regards,
	Maxim Levitsky

PS: take a look at my bugreport about monitor mode, any ideas?

