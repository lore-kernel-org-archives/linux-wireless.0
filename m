Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B186C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 17:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2F892186A
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 17:23:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="aGPb1vmi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbfCNRXs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 13:23:48 -0400
Received: from nbd.name ([46.4.11.11]:54966 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbfCNRXs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 13:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lL6fpHmgQ3hGT7ImJq7hIfL09+z+ccj6B8lOCEHk4i4=; b=aGPb1vmiMN3AuQdwTCV7LIGPrZ
        GqjineA4AwD80XG7aEmtzD4pFbiXAbuC7qfE9pwDo7F8YTLiGUaRFzTuaqL6Ql3/TiDfmAnTbpvLg
        qi6em0mVgfnhsWGVuvROmt315xmz+9S6/bemrOIwzVx/TFIdfrPYoPFvPaO1s+Zoyoq0=;
Received: from x590cbb58.dyn.telefonica.de ([89.12.187.88] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h4U53-0004bu-RC; Thu, 14 Mar 2019 18:23:45 +0100
Subject: Re: [RFC] mac80211: rework locking for txq scheduling / airtime
 fairness
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
References: <20190313181531.62539-1-nbd@nbd.name> <87va0mz8nu.fsf@toke.dk>
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
Message-ID: <50e3ab54-4e8c-171c-28f0-7e3ad5a02c99@nbd.name>
Date:   Thu, 14 Mar 2019 18:23:45 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <87va0mz8nu.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-13 23:55, Toke Høiland-Jørgensen wrote:
> Felix Fietkau <nbd@nbd.name> writes:
> 
>> Holding the lock around the entire duration of tx scheduling can
>> create some nasty lock contention, especially when processing airtime
>> information from the tx status or the rx path.
> 
> Right, I can see how that could become an issue at higher loads than
> what I tested with :)
I stumbled onto this when I was doing perf runs with mt76 (before even
adding support for this API) and I noticed that a visible amount of lock
contention was caused by mac80211 tx calls being blocked by mt76 tx
scheduling.
I wanted to fix these issues by switching to the mac80211 txq scheduling
API, but when reading the code I noticed that using this API had the
very same issue I was trying to fix. That's why I made this patch :)

>> Improve locking by only holding the active_txq_lock for lookups /
>> scheduling list modifications.
> 
> So the (potential) issue I see with this modification is that it
> requires the driver to ensure that it will not interleave two different
> scheduling rounds for the same acno. I.e., another call to
> schedule_start() will reset the round counter and something needs to
> guarantee that this doesn't happen until the driver has actually
> finished the previous round.
> 
> I am not sure to what extent this would *actually* be a problem. For
> ath9k, for instance, there's already the in-driver chan_lock (although
> the call to ieee80211_txq_schedule_start() would then have to be moved
> into the section covered by that lock). But it does introduce an
> implicit dependency in the API, which should at least be documented.
With ath9k it's also protected by the per-txq lock.
With ath10k it's protected by having scheduling calls come from the NAPI
poll function.

> If memory serves, avoiding this implicit dependency was the original
> reason I had for adding the full lock around everything. I can't think
> of any other reason right now, but if I do think of something I'll be
> sure to let you know :)
I'll change the patch to make this more explicit and resubmit.
Thanks for your comments.

- Felix
