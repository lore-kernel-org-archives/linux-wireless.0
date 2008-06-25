Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:53331 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbYFYLMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 07:12:39 -0400
Received: by mu-out-0910.google.com with SMTP id w8so1111413mue.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 04:12:37 -0700 (PDT)
Message-ID: <48622822.3000300@gmail.com> (sfid-20080625_131241_953594_A3A67D42)
Date: Wed, 25 Jun 2008 13:12:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linville@tuxdriver.com
Subject: Re: Small cleanups
References: <20080625102553.GA2648@elf.ucw.cz> <486227D2.6030801@gmail.com>
In-Reply-To: <486227D2.6030801@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> -    if ((ai->APList == NULL) &&
>> -        (ai->APList = kmalloc(sizeof(APListRid), GFP_KERNEL)) == NULL)
>> +    if (!ai->APList)
>> +        ai->APList = kmalloc(sizeof(APListRid), GFP_KERNEL);
>> +    if (!ai->APList)
>>          return -ENOMEM;
>> -    if ((ai->SSID == NULL) &&
>> -        (ai->SSID = kmalloc(sizeof(SsidRid), GFP_KERNEL)) == NULL)
>> +    if (!ai->SSID)
>> +        ai->SSID = kmalloc(sizeof(SsidRid), GFP_KERNEL);
>> +    if (!ai->SSID)
>>          return -ENOMEM;
> 
> Would you mind sending another patch which would fix the potential leak?

Sorry, ignore this.
