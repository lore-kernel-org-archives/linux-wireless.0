Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D247DC04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 11:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E0CE2083C
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 11:19:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="mFAS4hdm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E0CE2083C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbeJPTJw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 15:09:52 -0400
Received: from nbd.name ([46.4.11.11]:33772 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbeJPTJw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 15:09:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IX+h0HJXdFO2fZlJOwaICgLqYo0xii42xwL28X3Q3dI=; b=mFAS4hdmn/BMiCr2PzGtE56/lk
        nw6++hW9ChS/5seRTd2QnjDsaUR4IqPdpaXIEody1RFsfN8b0Oo2ll0VybG3NU7SM26X9ZFsFcfle
        ZYlMGAuqbOGXdj/HvWn24JdqeEYZWadZ3LL3Ppwy5B7zw9eJ5RDFcIEITIoPaaCf2RXA=;
Subject: Re: [PATCH v4 4/8] rt2800: fix registers init for MT7620
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>
References: <1539334591-9965-1-git-send-email-sgruszka@redhat.com>
 <1539334591-9965-5-git-send-email-sgruszka@redhat.com>
 <CAKR_QVJ60VTDjyC59BEDsRKrKR495xjGwob0QqvX333L+L+=Zg@mail.gmail.com>
 <20181012113656.GB2118@redhat.com>
 <CAKR_QVKU8ZFs6SC0Bm8VFKv82uNah+mZMKfCqCB+PRe6Ew2pcA@mail.gmail.com>
 <20181012120329.GD2118@redhat.com>
 <CAKR_QVKKiRFASfB=Rs7eUXKNt-Sqm7dTp2tBikOBatJxKvkJ0w@mail.gmail.com>
 <20181012122630.GB2668@redhat.com>
 <CAKR_QVLtJGzpBuz-BBi5yzFPoTUnadDdEXcwnR4XrB3DuWchjQ@mail.gmail.com>
 <20181016080922.GB4158@redhat.com>
From:   Felix Fietkau <nbd@nbd.name>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <e18b2f17-9403-f17a-babb-c4f56dedd2ca@nbd.name>
Date:   Tue, 16 Oct 2018 13:19:52 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181016080922.GB4158@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-16 10:09, Stanislaw Gruszka wrote:
> On Fri, Oct 12, 2018 at 02:41:41PM +0200, Tom Psyborg wrote:
>> On 12/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> > On Fri, Oct 12, 2018 at 02:20:07PM +0200, Tom Psyborg wrote:
>> >> > On upstream tree where this patch is intended
>> >> > additional registers where never programmed as proper branch
>> >> > were never used, because of additional check in RT5390 branch.
>> >> >
>> >>
>> >> on my hardware additional registers were programmed in regardless of
>> >> redundant check. that why i opened whole thread on forum since i
>> >> couldn't understand how's that happening
>> >
>> > I don't understand how that possible either.
>> 
>> i'd assume because device use external lna
> 
> I have no idea how this could be related. But I think I found
> somewhat reasonable explenation where the problem is.
> I think below code :
> 
> 	if (a || b || c) {
> 		CODE1();
> 	} else if (c) {
> 		CODE2();
> 	}
> 
> can not be deterministic and can be compiled differently depending
> on compiler version and used options. Sometimes it could result
> in this 
> 
> 	if (a || b || c) {
> 		CODE1();
> 	}
> 
> and sometimes in this:
> 
> 	if (a || b) {
> 		CODE1();
> 	} else if (c) {
> 		CODE2();
> 	}
> 
> So that would explain the problems you see. And indeed patch
> could cause regression on systems where second variant of
> initalizing RT6352 registers was used.
I don't see how that can be non-deterministic at all. The 'else if' part
can only be hit if the first if did not match.

- Felix
