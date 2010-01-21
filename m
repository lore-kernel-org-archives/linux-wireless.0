Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:62337 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab0AUSQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 13:16:56 -0500
Received: by pwi21 with SMTP id 21so154095pwi.21
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2010 10:16:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264067069.11396.33.camel@johannes.local>
References: <20100121025546.GB8069@bombadil.infradead.org>
	<1264067069.11396.33.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 21 Jan 2010 10:16:35 -0800
Message-ID: <43e72e891001211016i617de5c6o24fdfd1aa6f54eeb@mail.gmail.com>
Subject: Re: RFC/RFT: compat-wireless for 2.6.32.4 - MQ backport support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 21, 2010 at 1:44 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-01-20 at 21:55 -0500, Luis R. Rodriguez wrote:
>
>> @@ -287,7 +287,13 @@
>>
>>       rcu_read_lock();
>>       list_for_each_entry_rcu(sdata, &local->interfaces, list)
>> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
>>               netif_tx_wake_queue(netdev_get_tx_queue(sdata->dev, queue));
>> +#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
>> +             netif_start_subqueue(sdata->dev, queue);
>> +#else
>> +             netif_wake_queue(sdata->dev);
>> +#endif
>
> That's incorrect, you need to check for all hardware queues being awake.

Can you elaborate? I'm not following.

  Luis
