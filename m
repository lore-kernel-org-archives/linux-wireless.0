Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34444 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753296AbdFPKQ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 06:16:59 -0400
Received: by mail-wm0-f44.google.com with SMTP id d64so2836755wmf.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 03:16:59 -0700 (PDT)
Subject: Re: [RFC] networking: add and use skb_put_u8()
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
References: <20170616090300.13805-1-johannes@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <b7ba5145-b4f0-0f86-e93d-ad8700483ff2@broadcom.com> (sfid-20170616_121708_971534_E3520960)
Date: Fri, 16 Jun 2017 12:16:56 +0200
MIME-Version: 1.0
In-Reply-To: <20170616090300.13805-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 6/16/2017 11:03 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Joe and Bjørn suggested that it'd be nicer to not have the
> cast in the fairly common case of doing
> 	*(u8 *)skb_put(skb, 1) = c;
> 
> Add skb_put_u8() for this case, and use it across the code,
> using the following spatch:
> 
>      @@
>      expression SKB, C, S;
>      typedef u8;
>      identifier fn = {skb_put};
>      fresh identifier fn2 = fn ## "_u8";
>      @@
>      - *(u8 *)fn(SKB, S) = C;
>      + fn2(SKB, C);
> 
> Note that due to the "C", the spatch isn't perfect, it should
> have checked that C is 1, but there's also places that use a

Don't you mean "S" here?

Regards,
Arend
