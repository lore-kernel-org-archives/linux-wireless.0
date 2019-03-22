Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C2AC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 01:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 818C4218E2
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 01:48:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="BIEd30VU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbfCVBsQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 21:48:16 -0400
Received: from mout.gmx.net ([212.227.17.21]:49607 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbfCVBsP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 21:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553219281;
        bh=/MMzAhlmcJWn/Kdv4gvfA5Jp0HNucrPLSNN+zs+GZnI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=BIEd30VUJOHJBq5aTIFlIEVxYRfQgGPksvr2YDHiD8kBmpIGM2ss5ww23r+WsGO02
         H78SsNP63TNVw0YEH5rrOl6ocA1nnHJ6jCWCZKvMjCZ4IobssWTRCLL7ND3iD82vfK
         6SewMT806mV/pnEgK++QkXMeLJwS3dOy/44MH1hM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.2.0.3] ([217.250.41.73]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LeeNW-1ge4TP0lGY-00qTeu; Fri, 22
 Mar 2019 02:48:01 +0100
Subject: Re: [PATCH] ath9k: Check for errors when reading SREV register
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190318190557.21599-1-timschumi@gmx.de>
 <87va0cpmt4.fsf@codeaurora.org>
From:   Tim Schumacher <timschumi@gmx.de>
Openpgp: preference=signencrypt
Autocrypt: addr=timschumi@gmx.de; keydata=
 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
Message-ID: <95ca6443-a3ad-1eda-db6a-c684cc358fc9@gmx.de>
Date:   Fri, 22 Mar 2019 02:47:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <87va0cpmt4.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EjVaiXIcww1PynL1C8ZJIGUAwcIh0+HXctuDci2ICj0jaxQllBx
 mFphi8brz1O0qra0Hv5wBNZDK2R75Ls0uBSH6FDoj6dRi26PpPSQ0REYOq4yFuUyUy1zvLn
 rek+bF8OHdlU/tL9AZLLXwoSPIXNVDtfWNNtUP3e6OY+nJveocCo2yQYisCPq6vwTQEwIo1
 UcBaRjEz+iTaZZS9I4F0g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:et4wDSwIfeE=:vLwjYNaoClKblmtplRxqqF
 KzYV0yf64J+QK/Z9mY4pjR2nwBsjcR9Re+uDc9c9HzqzuokmIO7u1YgFCta40IgjExr+B1UUW
 cUPVsajV754VRKAY3X7Z3FbEjNIQdbdv6JQvf1gQwjiaCpiD51kMSuQ+1nihSlFiN48Z5f9iN
 egFJmCmkOPabaZfkcqM+BLiLbgrk5FPXcXG0gbxy+UjRAUfoFcXo+amCQcH7+vAA86L1HhSwh
 MZgCW600tjnNhJHD0L+tmIzkwatC2lNUdlFxTLU+b54b6wx/r1f7cFiuYEwWhUiwGaOZ+Nf1u
 DHPcRdzC4Yhu1CsD1QamICaPhUBwCLcMbJ+hON7awSgpDidF5+kno9SngQzTWlxG+1UPAQK2s
 AqcTFErYH+ORK0No9lzb7Bz9YXBfUYZrJGGlsVI25KwusDfE4Yr+LU4E9Ys8LZvwOKmZSVYLB
 FG28OZhNjovO7ZgJyLcxQbWdQdAvBlmc61fpe8PB8xXJsucT+fPoFRCnIuRZaiJZi72QpG4T1
 1Vn+7UZifwNCAAKpJx1NT/bJBATls0DXmYWh8tYuiea5w/eIj2s44eCtZavHMsiUnJCq1WXng
 d71AGiME+/44/4hlnIAyeSQdG5YSLAKR5kKKxIvUL5L2hQz1J1dxUZMR8Jpka1VtKiHLVPZ3Z
 2/ZyosR8VaWRM6CsFM71cnLbTq/g9HY1SbdQHTrOROamorL1n7aYKXcaXbno0xdau74rVCWX6
 xpuQE904uypmARAz3H9YoX7ITiyfXxxPhtjCtM2v9JCUuHT+iCXx+Bz09xjEmdJrQl2Q8wwhm
 SQomYS0FhK/iAuXDYcHCvk15pdVTfUByjFRFhzUVy5A4z5Mz1MfZOCfk2jUoESB8pFe41rnS2
 N75UiUKUJ4eQHYTdltlQ26+1q7/KcgOgv7i9l03rOC3ACRr7GZuwyGYpQxo6Iks18g3BiWhJ/
 bJJ4aeZsIbQ==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 21.03.19 11:02, Kalle Valo wrote:
> Tim Schumacher <timschumi@gmx.de> writes:
>
>> Right now, if an error is encountered during the SREV register
>> read (i.e. an EIO in ath9k_regread()), that error code gets
>> passed all the way to __ath9k_hw_init(), where it is visible
>> during the "Chip rev not supported" message.
>>
>>     ath9k_htc 1-1.4:1.0: ath9k_htc: HTC initialized with 33 credits
>>     ath: phy2: Mac Chip Rev 0x0f.3 is not supported by this driver
>>     ath: phy2: Unable to initialize hardware; initialization status: -9=
5
>>     ath: phy2: Unable to initialize hardware; initialization status: -9=
5
>>     ath9k_htc: Failed to initialize the device
>>
>> Check for -EIO explicitly in ath9k_hw_read_revisions() and return
>> a boolean based on the success of the operation. Check for that in
>> __ath9k_hw_init() and abort with a more debugging-friendly message
>> if reading the revisions wasn't successful.
>>
>>     ath9k_htc 1-1.4:1.0: ath9k_htc: HTC initialized with 33 credits
>>     ath: phy2: Failed to read SREV register
>>     ath: phy2: Could not read hardware revision
>>     ath: phy2: Unable to initialize hardware; initialization status: -9=
5
>>     ath: phy2: Unable to initialize hardware; initialization status: -9=
5
>>     ath9k_htc: Failed to initialize the device
>>
>> This helps when debugging by directly showing the first point of
>> failure and it could prevent possible errors if a 0x0f.3 revision
>> is ever supported.
>>
>> Signed-off-by: Tim Schumacher <timschumi@gmx.de>
>
> [...]
>
>> -	val =3D REG_READ(ah, AR_SREV) & AR_SREV_ID;
>> +	srev =3D REG_READ(ah, AR_SREV);
>> +
>> +	if (srev =3D=3D -EIO) {
>> +		ath_err(ath9k_hw_common(ah),
>> +			"Failed to read SREV register");
>> +		return false;
>> +	}
>
> I really don't like how the error handling is implemented in REG_READ().
> If the register has value 0xfffffffb (=3D -EIO =3D=3D-5) won't this inte=
rpret
> that as an error?
>

If the register had that value, it would indeed report an error. However
(at least if I read the current code and the data sheet correctly), to mak=
e
use of the higher 24 bits of the register, the "small"/old version of the
SREV_ID (i.e. the rightmost 8 bit) need to be set to 0xFF. Therefore, a
register read of 0xfffffffb should never happen in this register.

But the error handling is indeed a bit weird. Making the return value a pu=
re
status indicator and saving the value from the register by passing a
reference would probably be the best solution to fixing this up.
