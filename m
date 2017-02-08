Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35523 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754289AbdBHPCu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 10:02:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAK8P3a2fHm9j7roYjTAXJ_zsdXF88p_6Y-hCF6aWjJzcAaQ3Uw@mail.gmail.com>
References: <20170203163607.3488037-1-arnd@arndb.de> <20170206.120318.1268240226202516488.davem@davemloft.net>
 <4910112.l20yySyWnA@wuerfel> <1486556665.24745.6.camel@sipsolutions.net> <CAK8P3a2fHm9j7roYjTAXJ_zsdXF88p_6Y-hCF6aWjJzcAaQ3Uw@mail.gmail.com>
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Date: Wed, 8 Feb 2017 17:58:44 +0300
Message-ID: <CAPAsAGx4UoUv3tyef56Dfvo7bfinY-hUHhUeDTGWbCxsw72Bqw@mail.gmail.com> (sfid-20170208_160256_088109_E7208B0C)
Subject: Re: KASAN+netlink, was: [PATCH] [net-next?] hns: avoid stack overflow
 with CONFIG_KASAN
To: Arnd Bergmann <arnd@arndb.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nikolay@cumulusnetworks.com, nicolas.dichtel@6wind.com,
        adobriyan@gmail.com,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2017-02-08 16:10 GMT+03:00 Arnd Bergmann <arnd@arndb.de>:
> On Wed, Feb 8, 2017 at 1:24 PM, Johannes Berg <johannes@sipsolutions.net> wrote:

>
>> Btw, what's causing this to start with? Can't the compiler reuse the
>> stack places?
>
> I have no idea. It's trying to find out of bounds accesses for
> objects on the stack, so maybe it gives each variable a separate
> stack location in order to see which one caused problems?
>

If compiler cannot prove that access to the local variable is valid it
will add redzones around that variable
to be able to detect out of bounds accesses.

For example:
    static inline int nla_put_u8(struct sk_buff *skb, int attrtype, u8 value)
    {
           return nla_put(skb, attrtype, sizeof(u8), &value);
    }
compiler will surround 'value' with redzones to catch potential oob
access in nla_put().


Another way to fix this, would be something like this:

#ifdef CONFIG_KASAN
/* don't bloat stack */
#define __noinline_for_kasan    __noinline __maybe_unused
#else
#define __noinline_for_kasan    inline
#endif

static __noinline_for_kasan int nla_put_u8(struct sk_buff *skb, int
attrtype, u8 value)
{
       return nla_put(skb, attrtype, sizeof(u8), &value);
}
