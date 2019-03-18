Return-Path: <SRS0=49bh=RV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8767C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 10:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99B9020850
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 10:37:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="YKMkqSEG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfCRKhj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 06:37:39 -0400
Received: from nbd.name ([46.4.11.11]:41178 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbfCRKhj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 06:37:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JGU11qV/lQIwf09+MasmlhAInzZcn/E/KyUYEk5/kQ0=; b=YKMkqSEGGsHK2nzfnOOjZ/x1xW
        zcnbjLEC1Idp2PIesGvjn7BUNDQofdiwvz1/dWuKyMcMxRTSa6CwkWjtsiEg4W6z5O08hZilv9EV1
        E+6LGItJ8I26DxPWCfVUvRGu6zxbCKROzTrO+iAocbkerwJRM46GyQCJeARB8aRwX7F4=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5peE-00040b-5P; Mon, 18 Mar 2019 11:37:38 +0100
Subject: Re: [PATCH 4/6] mt76: store software PN/IV in wcid
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org
References: <20190316204242.73560-1-nbd@nbd.name>
 <20190316204242.73560-4-nbd@nbd.name> <20190318102134.GC3323@redhat.com>
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
Message-ID: <c9cba708-e70b-e40a-a019-3447aabcc8dd@nbd.name>
Date:   Mon, 18 Mar 2019 11:37:37 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190318102134.GC3323@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-18 11:21, Stanislaw Gruszka wrote:
> On Sat, Mar 16, 2019 at 09:42:40PM +0100, Felix Fietkau wrote:
>> Avoids expensive 64-bit atomic access in the data path
> <snip>
>> diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
>> index d6e260ca1423..fb1961ac9dc6 100644
>> --- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
>> +++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
>> @@ -924,7 +924,11 @@ mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
>>  	txwi[3] = cpu_to_le32(val);
>>  
>>  	if (key) {
>> -		u64 pn = atomic64_inc_return(&key->tx_pn);
>> +		u64 pn;
>> +
>> +		spin_lock(&dev->mt76.lock);
>> +		pn = ++wcid->tx_pn;
>> +		spin_unlock(&dev->mt76.lock);
> 
> It's interesting that atomic op is more expensive that taking spinlock
> and do the operation under spinlock protection. This should not be
> the case, atomic ops are provided exactly to avoid locking and should
> be faster than spin_lock. Perhaps on architecture where this happen
> (presumably MIPS 32bit) either atomic ops assembly code should be fixed
> or arch should switch generic lib/atomic64.c .
The fact that lib/atomic64.c is being used is the problem here.
The generic implementation takes a spin_lock_irqsave, which is more
expensive than the bh lock.

- Felix
