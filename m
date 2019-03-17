Return-Path: <SRS0=pME5=RU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 038D5C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 12:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B54E2087F
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 12:34:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="jdJIJXYv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbfCQMcc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Mar 2019 08:32:32 -0400
Received: from nbd.name ([46.4.11.11]:57638 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbfCQMcc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Mar 2019 08:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XWJRtPz4XyBVVZ/yPjMxmhcphbqgeidfMFYtK6FOYoc=; b=jdJIJXYv1fxyAp3QRIPtjsGyWN
        pJBBK5Pxow1schqd+v77vH1CJ0zVoLDEqXE5KULmjxKAPwESUtAErsRFibdid/RJDuYu+FZxXGHiE
        tj/99F5/MoBFNI3egpFHboyCZb/GXZPXqj5xY/Zi1x+YIOkDzD0pAtaTm2awHk+elEo4=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5Uxq-0000Oc-9u; Sun, 17 Mar 2019 13:32:30 +0100
Subject: Re: [PATCH 1/6] mt76: use mac80211 txq scheduling
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org
References: <20190316204242.73560-1-nbd@nbd.name> <87muluv4hd.fsf@toke.dk>
 <7b9a0a24-14b0-9b96-0010-ce9f96308ad0@nbd.name> <875zshviqg.fsf@toke.dk>
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
Message-ID: <2cc1f1d4-f07e-faa0-ede7-95dd2917a64a@nbd.name>
Date:   Sun, 17 Mar 2019 13:32:29 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <875zshviqg.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-17 12:32, Toke Høiland-Jørgensen wrote:
> Felix Fietkau <nbd@nbd.name> writes:
> 
>> On 2019-03-16 23:28, Toke Høiland-Jørgensen wrote:
>>> Felix Fietkau <nbd@nbd.name> writes:
>>> 
>>>> Performance improvement and preparation for adding airtime fairness
>>>> support
>>> 
>>> Great to see this! Do you have a plan for the airtime fairness part?
>>> I.e., how to get the airtime information?
>> Not yet. Still need to investigate what kind of information the hardware
>> can provide. On a first glance it seems rather limited, so we may have
>> to approximate based on tx status rates/retry and average packet size.
> 
> OK, cool. A byte-based estimator can also be useful for preventing dumb
> firmware from buffering too much. The Chromium guys did that for ath10k:
> 
> https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/588190/13/drivers/net/wireless-4.2/ath/ath10k/mac.c#3826
Interesting, thanks. I can probably use some ideas from that.

>>> The call to ieee80211_return_txq() is really meant to be unconditional.
>>> The TXQ will only actually be scheduled if it still has packets queued.
>>> I know it's slightly more expensive to have the check in mac80211, but
>>> this is what makes it possible to change the implementation without
>>> touching the drivers (such as in the RFC patch I sent earlier that
>>> switches the scheduling algorithm)...
>> I think this API needs to be extended to allow the driver to specify
>> that it has buffered packets for a txq. Otherwise there's a small window
>> where the driver has packets for a txq but mac80211 doesn't, and
>> mac80211 won't schedule the queue in that case.
>> I'll send a patch for this soon.
> 
> Right, makes sense. As long as mac80211 is in control over how it will
> react to that information (thus allowing to e.g., invert the logic if
> needed), I have no objections to extending the API... :)I'm thinking of changing the code to make ieee80211_schedule_txq add the
txq to the list, even if mac80211 does not have any frames buffered for it.

I've looked at ath9k (the only user at the moment), and it seems to call
the function in that way already: at PS wake or tx status time if it has
frames in its internal retry queue.
While it does not match the current documented behavior for that
function, it nicely fits ath9k's currently unfulfilled expectations ;)

- Felix
