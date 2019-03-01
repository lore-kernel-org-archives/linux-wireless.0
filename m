Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD1FC10F03
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 16:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD0772085A
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 16:06:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="WoNQ+cHn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388855AbfCAQGw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 11:06:52 -0500
Received: from nbd.name ([46.4.11.11]:57018 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbfCAQGw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 11:06:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=K8jR4Oq+8wTX075lC3UXO9BAEiKpnRH1hK/RY23mxU4=; b=WoNQ+cHnj+pPHQpUVjZlyKTV3n
        Req0KYnY8c11HMmOJYJLolgA+d+befl7GCAl2WLStV7gbZzklD5CPw+M/KS9D77Ve22O4SrPhzwVL
        fi6yCccrofQI1TjXXrH1tpwmfhuDllNu6rMEY629RLyjQgYL91/O/lZZB4bsBrvgbKLw=;
Subject: Re: [PATCH] mac80211: do not call driver wake_tx_queue op during
 reconfig
To:     Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, stable@vger.kernel.org
References: <20190301134837.88087-1-nbd@nbd.name>
 <09a12ed0-dd86-2077-9ecb-c62a52186952@candelatech.com>
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
Message-ID: <c39a8e18-4a6b-a4db-3b25-c7d9d417d247@nbd.name>
Date:   Fri, 1 Mar 2019 17:06:48 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <09a12ed0-dd86-2077-9ecb-c62a52186952@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-01 16:29, Ben Greear wrote:
> On 3/1/19 5:48 AM, Felix Fietkau wrote:
>> There are several scenarios in which mac80211 can call drv_wake_tx_queue
>> after ieee80211_restart_hw has been called and has not yet completed.
>> Driver private structs are considered uninitialized until mac80211 has
>> uploaded the vifs, stations and keys again, so using private tx queue
>> data during that time is not safe.
>> 
>> The driver can also not rely on drv_reconfig_complete to figure out when
>> it is safe to accept drv_wake_tx_queue calls again, because it is only
>> called after all tx queues are woken again.
>> 
>> To fix this, bail out early in drv_wake_tx_queue if local->in_reconfig
>> is set.
> 
> This reminded me of a patch I posted back in 2016.  The discussion just sort of
> ended on it, but curious if you have a new opinion on it after debugging the
> issue in this patch:
> 
> https://patchwork.kernel.org/patch/9457709/
> 
> For what its worth, I've been using the patch above since I posted it, and
> it seems to work well for ath9k and ath10k.
I agree with what Johannes wrote about that patch. Fixing this could
likely be as simple as clearing IEEE80211_SDATA_IN_DRIVER on all
interfaces before bringing any of them back up. That way the normal
interface add logic applies without nasty special cases.
The reconfig code checks for ieee80211_sdata_running (which is
unaffected), so I don't think we need to save the previous value of that
flag.

- Felix
