Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:50580 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab3JHOwT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 10:52:19 -0400
Received: by mail-lb0-f171.google.com with SMTP id u14so6888539lbd.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Oct 2013 07:52:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381239951.13359.13.camel@jlt4.sipsolutions.net>
References: <1381231915-24232-1-git-send-email-ard.biesheuvel@linaro.org>
	<1381233152.13359.10.camel@jlt4.sipsolutions.net>
	<AE90C24D6B3A694183C094C60CF0A2F6026B737B@saturn3.aculab.com>
	<23D74823-0DE3-4A87-9E89-310F437A328D@linaro.org>
	<1381239908.13359.12.camel@jlt4.sipsolutions.net>
	<1381239951.13359.13.camel@jlt4.sipsolutions.net>
Date: Tue, 8 Oct 2013 16:52:17 +0200
Message-ID: <CAKv+Gu8D_7d=u1PGWuxoLEETHe8uJMby3K98uQWQn7tk=t_t_w@mail.gmail.com> (sfid-20131008_165332_539746_57ED6D73)
Subject: Re: [PATCH] mac80211: port CCMP to cryptoapi's CCM driver
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Laight <David.Laight@aculab.com>,
	"<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
	"<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
	"<patches@linaro.org>" <patches@linaro.org>,
	"<linville@tuxdriver.com>" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 October 2013 15:45, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2013-10-08 at 15:45 +0200, Johannes Berg wrote:
>> On Tue, 2013-10-08 at 15:41 +0200, Ard Biesheuvel wrote:
>>
>> > Actually, as the size is always the same, it should be feasible to
>> > alloc a couple of request structs at init time. would one for rx and
>> > one for tx be sufficient? or is this code more reentrant than that?
>>
>> TX can run concurrently on multiple (four) queues using the same key.
>
> And maybe even more with injection ... I wouldn't go there.
>

OK, clear.

If you think this patch has any merit at all, I am happy to modify it
so that it kmalloc()s the request struct with GFP_ATOMIC at every
invocation.
However, personally I don't think this should be necessary and in fact
my patch removes a stack allocation of u8[48] (from
ieee80211_crypto_ccmp_decrypt() and from ccmp_encrypt_skb() in wpa.c)
so it does even out a bit.

regards,
Ard.
