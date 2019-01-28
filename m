Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE1AC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 12:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 864F02087F
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 12:29:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="KcPRf+HV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfA1M3a (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 07:29:30 -0500
Received: from nbd.name ([46.4.11.11]:32780 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfA1M3a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 07:29:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6g0FWr2XaVd2xuM4cRyJI79KPYxnHvS3WdjrgFtGbCI=; b=KcPRf+HVogLJRby4tMom3mrjCI
        7QunpJGbF/YKeUZPky7Ldh8oZxXadO87avsf56JmqbLheSMMLjJja1TAL35XESRxSNNHVEHyM+nRp
        o8cO/3oj2rV2/5vkCVZ3cuqEtuhkIZ2z2mUcszPRpdgkGRtzQYqA2/OYqYJ9qf0QPLVo=;
Subject: Re: [PATCH 1/7] mt76x02: use mask for vifs
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
References: <20190124162040.GA5136@redhat.com>
 <20190124163541.GB10806@localhost.localdomain>
 <20190124222040.GA2873@localhost.localdomain>
 <20190125082556.GA2180@redhat.com>
 <20190125090236.GA2761@p1372.fit.wifi.vutbr.cz>
 <20190125094757.GA11700@redhat.com>
 <20190125102545.GA27731@p1372.fit.wifi.vutbr.cz>
 <20190125124148.GB4079@redhat.com>
 <fd79b85d-5b73-aa77-f17a-00ff182ee94c@nbd.name>
 <20190128090201.GB4132@redhat.com> <20190128111601.GA6002@redhat.com>
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
Message-ID: <f73122c1-3106-eee6-c288-78287273494c@nbd.name>
Date:   Mon, 28 Jan 2019 13:29:27 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190128111601.GA6002@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-01-28 12:16, Stanislaw Gruszka wrote:
> On Mon, Jan 28, 2019 at 10:02:01AM +0100, Stanislaw Gruszka wrote:
>> On Mon, Jan 28, 2019 at 09:41:45AM +0100, Felix Fietkau wrote:
>> > >> Moreover I am a little worried about tpt regressions with this patch.
>> > >> Are you sure that if you use complete different mac addresses on a multivif scenario
>> > >> you can get the same tpt on all the interfaces? Could you please provide some
>> > >> tpt results?
>> > > 
>> > > How exactly posted patch can cause tpt regression ?
>> > > 
>> > > Posted patch just add possibility to configure HW MAC address
>> > > by this:
>> > > 
>> > > iw dev wlan0 del
>> > > iw phy phy0 interface add wlan0 type managed addr 00:11:22:33:44:55
>> > > 
>> > > what is feature of mt76x2u. Patch just extend that possibly to other
>> > > mt76x02 devices and allow to remove custom mt76x2u add_interfacea
>> > > callback.
>> > The main part that could cause issues is that you're changing the way
>> > that the vif index is calculated. Without the patch, it's calculated
>> > from the MAC address in a way consistent with what the hardware expects.
>> > With the patch, it's just allocated from a mask.
>> > The vif index ends up being passed down to the hardware as a BSS index
>> > WCID attribute in mt76x02_mac_wcid_setup.
>> > We would have to run some tests with multiple AP interfaces, bringing up
>> > secondary interfaces in a different order to see if there are any
>> > regressions there if the BSS index no longer matches the MAC address
>> > based index.
>> 
>> Ok, that objection make sense.  I'll check that.
> 
> I'm not sure if I'm doing something wrong or current code is
> wrong. But when I configure multi bssid's is hostapd.conf like this:
> 
> 02:aa:bb:cc:dd:e0
> 06:aa:bb:cc:dd:e0
> 0a:aa:bb:cc:dd:e0
> 
> hostapd fail with "Too many bits in the BSSID mask" error . To make hostapd
> work, I have configure bssid's like this:
Do you have a bssid mask set? I don't think the current code does that.
Also, in OpenWrt, I didn't see any issue like that.

> 02:aa:bb:cc:dd:e0
> 02:aa:bb:cc:dd:e4
> 02:aa:bb:cc:dd:e8
> 
> But this ends up with the same index in mt76 for diffrent vif's. Seems like
> calculating of the index should be fixed by:
> 
>         if (vif->addr[0] & BIT(1))
>                 idx = 1 + (((dev->mt76.macaddr[5] ^ vif->addr[5]) >> 2) & 7);
This MAC adddress allocation scheme will cause problems if you have
multiple devices next to each other that have consecutive MAC addresses.

While it may sound unlikely, I do know people that encountered this
issue (though with QCA based hardware), and it took us quite a while to
figure out what was messing up their network ;)

- Felix
