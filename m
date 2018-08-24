Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.143.5]:37353 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726268AbeHXQRo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 12:17:44 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 3C62C19852
        for <linux-wireless@vger.kernel.org>; Fri, 24 Aug 2018 06:58:08 -0500 (CDT)
To: Joe Perches <joe@perches.com>, Kees Cook <keescook@chromium.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20180824011540.GA25716@embeddedor.com>
 <CAGXu5jJxbFzKsV1=xHiKtcx+61QBsK0LYMrwo1vGNWgALzqakw@mail.gmail.com>
 <d0ee04ea40bfc2aecd71b3ed1e1d388911b7d6cb.camel@perches.com>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] iwlwifi: d3: use struct_size() in kzalloc()
Message-ID: <f6818e31-d2da-82b4-b862-1ffb322f9365@embeddedor.com> (sfid-20180824_144320_049346_A0B1D7B7)
Date: Fri, 24 Aug 2018 06:58:05 -0500
MIME-Version: 1.0
In-Reply-To: <d0ee04ea40bfc2aecd71b3ed1e1d388911b7d6cb.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

On 8/23/18 11:33 PM, Joe Perches wrote:
> On Thu, 2018-08-23 at 20:03 -0700, Kees Cook wrote:
>> On Thu, Aug 23, 2018 at 6:15 PM, Gustavo A. R. Silva
>> <gustavo@embeddedor.com> wrote:
>>> One of the more common cases of allocation size calculations is finding
>>> the size of a structure that has a zero-sized array at the end, along
>>> with memory for some number of elements for that array. For example:
>>>
>>> struct foo {
>>>         int stuff;
>>>         void *entry[];
>>> };
> 
> Question for Gustavo.
> 
> Did you find any existing instances that are miscalculated?
> 

I found the following bug:

https://lore.kernel.org/patchwork/patch/977357/


> I believe there are some cases like:
> 
> 	size = sizeof(struct foo) + count * sizeof(something);
> 	ptr = kmalloc(size);
> 	memset(ptr + sizeof(struct foo), 0, size - sizeof(struct foo));
> 
> where something could go wrong and not be detected.
> 

It might be worth it to write a Coccinelle script for this.

--
Gustavo
