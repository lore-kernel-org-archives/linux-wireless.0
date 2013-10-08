Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:41497 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3JHNlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 09:41:40 -0400
Received: by mail-we0-f178.google.com with SMTP id q59so8565763wes.37
        for <linux-wireless@vger.kernel.org>; Tue, 08 Oct 2013 06:41:39 -0700 (PDT)
References: <1381231915-24232-1-git-send-email-ard.biesheuvel@linaro.org> <1381233152.13359.10.camel@jlt4.sipsolutions.net> <AE90C24D6B3A694183C094C60CF0A2F6026B737B@saturn3.aculab.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B737B@saturn3.aculab.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <23D74823-0DE3-4A87-9E89-310F437A328D@linaro.org> (sfid-20131008_154153_503025_63179856)
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
	"<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
	"<patches@linaro.org>" <patches@linaro.org>,
	"<linville@tuxdriver.com>" <linville@tuxdriver.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] mac80211: port CCMP to cryptoapi's CCM driver
Date: Tue, 8 Oct 2013 15:41:33 +0200
To: David Laight <David.Laight@ACULAB.COM>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 8 okt. 2013, at 15:01, "David Laight" <David.Laight@ACULAB.COM> wrote:

>> Hmm, thanks I guess. I'll need to review this in more detail, but I have
>> a question first:
>> 
>>> +    /* allocate the variable sized aead_request on the stack */
>>> +    int l = DIV_ROUND_UP(crypto_aead_reqsize(tfm),
>>> +                 sizeof(struct aead_request));
>>> +    struct aead_request req[1 + l];
>> 
>> This looks a bit odd, why round up first and then add one? Why even
>> bother using a struct array rather than some local struct like
> 
> Is it even a good idea to be allocating variable sized items
> on the kernel stack?
> 
> There has to be enough stack available for the maximum number
> of entries - so there is little point in dynamically sizing it.

Actually, as the size is always the same, it should be feasible to alloc a couple of request structs at init time. would one for rx and one for tx be sufficient? or is this code more reentrant than that?

