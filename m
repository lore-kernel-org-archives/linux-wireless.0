Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D434CECDE47
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 16:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FD5D20857
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 16:02:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="erOTdvtA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FD5D20857
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbeKIBiZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 20:38:25 -0500
Received: from nbd.name ([46.4.11.11]:58630 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbeKIBiZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 20:38:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=m0Rpe9eQZdpkIPP6bRBiGVVi6GNcspB/LWkpLDO3REo=; b=erOTdvtAlwApRS88cp2lktEuHk
        iEnRRdhEcjlrwMRJCF6NKulnl7bbvd2Sk6zR0xE/30vwChZGckbflqXZYg8lo1UAwcDD+ddjS1AFN
        1mZwp5u4Mp1F1sjezwUFkLs0wymKVfzauHvNhBVrw/gI/FP59ePOmFeENySOKhi9MoR0=;
Subject: Re: [RFC/RFT 1/4] mt76x02: configure basic rates and fallback on STA
 mode
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
References: <1541688430-31855-1-git-send-email-sgruszka@redhat.com>
 <1541688430-31855-2-git-send-email-sgruszka@redhat.com>
 <CAJ0CqmXdvqdfQNXqxBmPn_t_EA7wg2hCd87rrwC+7N_y+8bh=g@mail.gmail.com>
 <20181108155202.GA13621@redhat.com>
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
Message-ID: <d89224d5-da5b-a4ac-d6a8-7d9f5cdf779d@nbd.name>
Date:   Thu, 8 Nov 2018 17:02:14 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181108155202.GA13621@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-08 16:52, Stanislaw Gruszka wrote:
> On Thu, Nov 08, 2018 at 03:58:29PM +0100, Lorenzo Bianconi wrote:
>> > For STA mode configure legacy basic rates according to info
>> > mac80211 provides to us, as well as follback registers, which
>> > are setup in vendor driver under CONFIG_STA_SUPPORT .
>> > For LB_FBK_CFG1 register use values from vendor driver, which
>> > are different for mt76x0 and mt76x2 .
>> >
>> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> > ---
>> >  drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 12 ++++++++++++
>> >  1 file changed, 12 insertions(+)
>> >
>> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
>> > index 87ce6a51fb05..2be4b527477f 100644
>> > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
>> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
>> > @@ -678,6 +678,18 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
>> >                 tasklet_enable(&dev->pre_tbtt_tasklet);
>> >         }
>> >
>> > +       if (changed & BSS_CHANGED_BASIC_RATES &&
>> > +           vif->type == NL80211_IFTYPE_STATION) {
>> > +               mt76_wr(dev, MT_LEGACY_BASIC_RATE, info->basic_rates);
>> > +               mt76_wr(dev, MT_VHT_HT_FBK_CFG0, 0x65432100);
>> > +               mt76_wr(dev, MT_VHT_HT_FBK_CFG1, 0xedcba980);
>> > +               mt76_wr(dev, MT_LG_FBK_CFG0, 0xedcba988);
>> > +               if (is_mt76x2(dev))
>> > +                       mt76_wr(dev, MT_LG_FBK_CFG1, 0x87872100);
>> > +               else
>> > +                       mt76_wr(dev, MT_LG_FBK_CFG1, 0x00872100);
>> > +       }
>> > +
>> 
>> since these values are constant, why not put them init_vals?
> 
> I wanted them to be used only in STA mode like vendor driver does.
> However if we will have AP+STA , we still will configure them,
> so better to configure them anyway and put in init_vals .
Yes, I think we should put them in initvals. Also, I think we should
keep the values the shared between mt76x0 and mt76x2.

For MT_LG_FBK_CFG1 there is no need to make a distinction between 76x2
and 76x0, because 76x0 will simply ignore the upper values (they apply
to 2SS transmission only).
Also, I don't think MT_VHT_HT_FBK_CFG1 even gets used on mt76x0, because
it is for 2SS rates only. However, the value in there seems more useful
than the one we currently use on mt76x2, because it allows fallback from
2SS MCS0 to 1SS MCS0.
The contents of MT_LG_FBK_CFG0 also match the default initialization
values documented in the 7612E datasheet.

I don't think there is any meaningful difference between the 76x2 and
the 76x0 MAC except for the missing 2SS support.

- Felix
