Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34044 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936652AbdAKIuz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 03:50:55 -0500
Received: by mail-pf0-f180.google.com with SMTP id 127so60751173pfg.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2017 00:50:55 -0800 (PST)
Subject: Re: [REGRESSION, bisect] mesh: SAE connection causes kernel crash
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Cedric.Izoard@ceva-dsp.com
References: <b72bc51c-1873-6178-9990-7d9e99ee4b88@gmail.com>
 <1484121737.23671.0.camel@sipsolutions.net>
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <aa60ffb2-b756-b807-4976-20f2eca6665d@gmail.com> (sfid-20170111_095059_406415_EC708AFC)
Date: Wed, 11 Jan 2017 17:50:52 +0900
MIME-Version: 1.0
In-Reply-To: <1484121737.23671.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017年01月11日 17:02, Johannes Berg wrote:
> I don't think this makes sense - if you only have two peers then you
> shouldn't even run into forwarding code paths?
>
> johannes

Though it looks odd, the code has run into forwarding code path even 
though peer to peer mesh connection.

	fwd_skb = skb_copy(skb, GFP_ATOMIC);

I checked it with printk().

# I know printk() should not be used in the context, just for checking.

Masashi Honma.
