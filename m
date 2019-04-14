Return-Path: <SRS0=0lX+=SQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83AFAC10F13
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 11:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23AD82148E
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 11:19:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="fNDy4yie"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfDNLTs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Apr 2019 07:19:48 -0400
Received: from nbd.name ([46.4.11.11]:41626 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbfDNLTr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Apr 2019 07:19:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JaP7ddrDmOqpIvzFVL/RSCwryBZO79Ma+zceU7tSjW4=; b=fNDy4yiewKuU41xRSF8XNJFJ5e
        hxTi2CalEktY/9yeTSkbxRJIBnlbINko5n9Qqngkg8u8rW395AgRbLd9LcfAdyTmgzWPhYeEeckGx
        oR7TUGinXBDtzNwbgR6p0S7/4Re/kHJoOsZGvqOb0DWYTD8fzF6JtUZVXzzRLIHTK2nk=;
Received: from p4ff13bac.dip0.t-ipconnect.de ([79.241.59.172] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1hFdAm-0007El-4K; Sun, 14 Apr 2019 13:19:44 +0200
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate tx
 queues
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, Herbert Xu <herbert@gondor.apana.org.au>
References: <20190316170634.13125-1-nbd@nbd.name>
 <20190316170634.13125-5-nbd@nbd.name> <87sgvmvg9g.fsf@toke.dk>
 <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com>
From:   Felix Fietkau <nbd@nbd.name>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 mQGiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwbQcRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPohgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQuQINBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabiEkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <e912d736-a3ad-1e21-0cdd-6a065df96fbb@nbd.name>
Date:   Sun, 14 Apr 2019 13:19:43 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-04-14 11:44, Arend Van Spriel wrote:
> + Herbert
> 
> On 3/16/2019 7:14 PM, Toke Høiland-Jørgensen wrote:
>> Felix Fietkau <nbd@nbd.name> writes:
>> 
>>> When using iTXQ, tx sequence number allocation and statistics are run at
>>> dequeue time. Because of that, it is safe to enable NETIF_F_LLTX, which
>>> allows tx handlers to run on multiple CPUs in parallel.
>> 
>> Cool, didn't know about that flag.
> 
> It is water under the bridge as this patch got applied already, but I 
> stumbled upon it just recently and didn't know about that flag either. 
> So I looked for more information about it and found the definition [1], 
> but the comment seemed important enough to send this reply.
> 
> 	NETIF_F_LLTX_BIT,	/* LockLess TX - deprecated. Please */
> 				/* do not use LLTX in new drivers */
> 
> Here is the commit that marked it deprecated:
> 
> commit e24eb521fbf2a350ce879dfc1d8e56d4ffa2aa22
> Author: Christian Borntraeger <borntraeger@de.ibm.com>
> Date:   Tue Sep 25 19:42:02 2007 -0700
> 
>      [NET]: note that NETIF_F_LLTX is deprecated
> 
> So I am not sure we should really do this in mac80211. Maybe Herbert can 
> comment although it has been over a decade ago.
There is a lot of comparable code that also uses this flag, e.g.
batman-adv, bridge, vlan, various tunnel implementations. I think
mac80211 fits well with those kinds of use cases.
If I remember correctly, the deprecation was added to avoid quirky
custom locking schemes in ethernet drivers.

- Felix
