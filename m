Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:60139 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbXKZQvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 11:51:44 -0500
Received: by ug-out-1314.google.com with SMTP id z38so965255ugc
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 08:51:42 -0800 (PST)
Message-ID: <474AF99C.1000806@gmail.com> (sfid-20071126_165148_803333_7A303FE9)
Date: Mon, 26 Nov 2007 17:51:40 +0100
From: drago01 <drago01@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
References: <47494851.4070504@gmail.com>	 <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com>	 <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com>	 (sfid-20071126_145009_936981_8E94FA2D) <1196092359.4149.278.camel@johannes.berg>
In-Reply-To: <1196092359.4149.278.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2007-11-26 at 15:50 +0100, dragoran wrote:
>   
>> btw would it make sense to ratelimit
>>
>> "WEP decrypt failed (ICV)" messages?
>> they are a bit annoying when connected to this network...
>>
>> dmesg  | grep ICV | wc -l
>> 3489
>>
>> after some minutes.
>>     
>
> I think they're only shown in a DEBUG config, no?
>
>   
looking at the code seems not:
---
    if (ieee80211_wep_decrypt_data(local->wep_rx_tfm, rc4key, klen,
                       skb->data + hdrlen + WEP_IV_LEN,
                       len)) {
        printk(KERN_DEBUG "WEP decrypt failed (ICV)\n");
        ret = -1;
    }
---
and here I have:
# CONFIG_MAC80211_DEBUG is not set
