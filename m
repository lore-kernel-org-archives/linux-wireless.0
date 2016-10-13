Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:35815 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755215AbcJMFqy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 01:46:54 -0400
Received: by mail-vk0-f46.google.com with SMTP id q126so13912219vkd.2
        for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2016 22:46:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476282127.5271.30.camel@sipsolutions.net>
References: <20161010150358.GA514@swordfish> <20161010153050.GA836@swordfish>
 <1476263106.5271.23.camel@sipsolutions.net> <20161012141245.GA436@swordfish> <1476282127.5271.30.camel@sipsolutions.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Oct 2016 22:39:49 -0700
Message-ID: <CALCETrXg9-OpJx5Rqz8afyaug+0DjzxvpdbOV9q6i01=zCZbcQ@mail.gmail.com> (sfid-20161013_074658_415008_ECF80295)
Subject: Re: [mac80211] BUG_ON with current -git (4.8.0-11417-g24532f7)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 12, 2016 at 7:22 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> > Can you elaborate on how exactly it kills your system?
>>
>> the last time I saw it it was a NULL deref at
>> ieee80211_aes_ccm_decrypt.
>
> Hm. I was expecting something within the crypto code would cause the
> crash, this seems strange.
>
> Anyway, I'm surely out of my depth wrt. the actual cause. Something
> like the patch below probably works around it, but it's horribly
> inefficient due to the locking and doesn't cover CMAC/GMAC either.

In a pinch, I have these patches sitting around:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vmap_stack&id=0a39cfa6fbb5d5635c85253cc7d6b44b54822afd
https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vmap_stack&id=bf8cfa200b5a01383ea39fc8ce2f32909767baa8

I don't like them, though.  I think it's rather silly that we can't
just pass virtual addresses to the crypto code.
