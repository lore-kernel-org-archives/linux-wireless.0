Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:52873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbYFRI2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 04:28:06 -0400
Received: by ug-out-1314.google.com with SMTP id h2so735781ugf.16
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2008 01:28:04 -0700 (PDT)
Message-ID: <f6ca9fed0806180128q739a9e3k68708b908e630324@mail.gmail.com> (sfid-20080618_102818_069681_96D1621F)
Date: Wed, 18 Jun 2008 10:28:04 +0200
From: drago01 <drago01@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with disable_hw_scan=1
Cc: "Maxim Levitsky" <maximlevitsky@gmail.com>,
	"Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240806152252v5fdb4f7dn1028a2a02e8d9cd1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <484FEA26.1040305@gmail.com> <48528CF0.8050204@gmail.com>
	 <1ba2fa240806131304n442972eatfd2f35034476c380@mail.gmail.com>
	 <48551C62.80904@gmail.com>
	 <1ba2fa240806150647mdc97d98oad0b1b02de1fcf87@mail.gmail.com>
	 <48552344.5090801@gmail.com>
	 <1ba2fa240806150809h13c28937nd064230baca8a15d@mail.gmail.com>
	 <1ba2fa240806150947s1ed9391ao4b1d1a91c871ef8f@mail.gmail.com>
	 <4855FF14.9080506@gmail.com>
	 <1ba2fa240806152252v5fdb4f7dn1028a2a02e8d9cd1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> Please try this one
>>>
>>> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
>>> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
>>> @@ -3348,7 +3348,10 @@ static void
>>> iwl3945_rx_scan_complete_notif(struct iwl3945_priv *priv,
>>>
>>>        /* Remove this scanned band from the list
>>>         * of pending bands to scan */
>>> -       priv->scan_bands--;
>>> +       if (priv->cfg->sku & IWL_SKU_A)
>>> +               priv->scan_bands--;
>>> +       else
>>> +               priv->scan_bands = 0;
>>>
>>>
>>
>>
>> I tested this patch, and it fixes this issue, Thanks a lot.
>>
> Thanks a lot for helping resolve this. I will post an official patch.

seems like a fix thats worth having in .26
