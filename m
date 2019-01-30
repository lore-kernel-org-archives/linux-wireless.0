Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA2CC282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 09:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ADE220882
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 09:26:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ogwtnfC1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730297AbfA3J0A (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 04:26:00 -0500
Received: from nbd.name ([46.4.11.11]:56768 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbfA3JZ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 04:25:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nCl+XHOwU+oAJ06P+DhBQGCppHXoha0NsAZC/rYoMpc=; b=ogwtnfC1zZ4ragcSn//qjlUA7b
        Sn9iKDd1V6Dwi39nLFblEIExOrWrJrTL/SjRuRt0YcX88528EVdt9YrHp5bl26CH76r9XmZ7y4XKy
        C6/uhpWWW7TnRfuj+dx9DN3JIQF7pDB4Q5yb11z7a8iES4k/EUPRKAn+fx+6ZVDyrsVM=;
Subject: Re: [PATCH v2 0/7] mt76x02: Beacon support for USB
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
References: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
 <87a7jju1mv.fsf@purkki.adurom.net>
 <8ec3b133-49eb-3c5f-4c3c-bc2bb4e84cde@nbd.name>
 <87k1inwtu5.fsf@codeaurora.org>
 <b6fb4aec-5e65-53aa-e14b-c1230e797786@nbd.name>
 <20190130082937.GA2720@redhat.com>
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
Message-ID: <8ec9c506-a43f-7274-65ed-a1734365e184@nbd.name>
Date:   Wed, 30 Jan 2019 10:25:57 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190130082937.GA2720@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-01-30 09:29, Stanislaw Gruszka wrote:
> On Tue, Jan 29, 2019 at 01:10:08PM +0100, Felix Fietkau wrote:
>> On 2019-01-29 13:07, Kalle Valo wrote:
>> > Felix Fietkau <nbd@nbd.name> writes:
>> > 
>> >> On 2019-01-29 12:47, Kalle Valo wrote:
>> >>> Stanislaw Gruszka <sgruszka@redhat.com> writes:
>> >>> 
>> >>>> We can configure beaconing, but without TBTT interrupt we
>> >>>> can not support PS buffering. This can be added later using
>> >>>> kernel hrtimer, if we can keep it in sycn with device timer.
>> >>>>
>> >>>> I tested AP and IBSS modes.
>> >>> 
>> >>> So how does this work reliably so that there's no packet loss with
>> >>> clients using power save?
>> >>
>> >> There will be multicast packet loss for clients using power save.
>> > 
>> > Isn't that a problem? At least as a normal user I would very frustrated
>> > if sometimes my connection work and sometimes not, for example if I'm
>> > trying discover devices from my network. Hopefully nobody won't use USB
>> > devices for any real AP stuff, but still enabling something which we
>> > know doesn't work realiably is concerning.
>> I agree. Maybe we should leave out the flag for AP mode in this patch
>> until we have PS buffering and leave the rest of the code intact.
> 
> But how serious problem of dropping multicast frames for PS stations is?
> I don't think from user perspective this is "sometimes my connection
> work and sometimes not", but something much less annoying. 
Actually, if you're considering two stations on an AP trying to connect
to each other, it is exactly "sometimes my connection work and sometimes
not", because of ARP. Clients won't see the ARP requests sent to each
other, if the client being asked is in powersave mode.

> Another thing is that this (D)TIM PS is not reliable by design,
> that why UAPSD was introduced.
UAPSD doesn't replace TIM based powersave indication, and I'm pretty
sure it doesn't handle multicast either.

> Moreover in the tree we have already bunch of drivers that do 
> advertise AP mode support without HOST_BROADCAST_PS_BUFFERING 
> like iwlwifi or brcm80211 .
I haven't looked at the code, but they may be handling buffered
multicast in a different way, possibly with firmware involvement.

- Felix
