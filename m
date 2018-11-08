Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1CDECDE4B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 16:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3848320825
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 16:05:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="BAFx68xG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3848320825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbeKIBmD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 20:42:03 -0500
Received: from nbd.name ([46.4.11.11]:58738 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbeKIBmD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 20:42:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=I/T4+DOrlrHMD6JUBsTZXsm5ViDt1Qa0P5wvv8skX8c=; b=BAFx68xG2tDe2Vo1ifvvpvKjiV
        rFdHhqir9vLTjD2Wqp9hOi6srVt2sdsuHMb2g5CEUtI7G8NUGEIOKKp9tWCwcKk6TgnnivvFHvY1U
        DEkoppwc632CZQyGCBIAR0dtRFXGXhJn/LD4DkgMLyla62YuEre+gTOgfLJDEdGaaEJg=;
Subject: Re: [RFC/RFT 2/4] mt76x02: reserve wcid 0 for global traffic
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
References: <1541688430-31855-1-git-send-email-sgruszka@redhat.com>
 <1541688430-31855-3-git-send-email-sgruszka@redhat.com>
 <CAJ0CqmXS6zkJf3FHb5wYyPPzvqG5OBZDfcYWSjbaJY_nhcErzA@mail.gmail.com>
 <20181108155403.GB13621@redhat.com>
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
Message-ID: <714c8e65-da0d-3043-ff4c-33c8931e4710@nbd.name>
Date:   Thu, 8 Nov 2018 17:05:51 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181108155403.GB13621@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-08 16:54, Stanislaw Gruszka wrote:
> On Thu, Nov 08, 2018 at 04:01:54PM +0100, Lorenzo Bianconi wrote:
>> > Restore behaviour on mt76x0 before commit  1bb04bb4b838 ("mt76: move
>> > mt76x02_init_device in mt76x02-lib module"). This will allow to use
>> > wcid 1 for AP when we work in station mode. It's not clear if this
>> > is needed, but this is how vendor driver assign wcid's in STA mode.
>> > This should be harmless for mt76x2.
>> >
>> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> > ---
>> >  drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 6 +++++-
>> >  1 file changed, 5 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
>> > index 2be4b527477f..e624397b3d8b 100644
>> > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
>> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
>> > @@ -113,7 +113,11 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
>> >         ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
>> >         ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
>> >
>> > -       dev->mt76.global_wcid.idx = 255;
>> > +       /* Reserve WCID 0 for mcast - thanks to this APs WCID will go to
>> > +        * entry no. 1 like it does in the vendor driver.
>> > +        */
>> > +       dev->mt76.wcid_mask[0] |= 1;
>> > +       dev->mt76.global_wcid.idx = 0;
>> >         dev->mt76.global_wcid.hw_key_idx = -1;
>> >         dev->slottime = 9;
>> >
>> 
>> Does it make any difference in AP mode?
> 
> First sta will get wcid = 1 instead of 0.
> 
>> What about using 0 instead of
>> 255 for global_wcid.idx?
> 
> Patch do exactly that , it assigns:
> 
> 	dev->mt76.global_wcid.idx = 0;
I don't think we should reserve WCID0 just because the vendor driver
does it, unless we can find a case where it actually makes a meaningful
difference. WCID entries >128 are useless for normal stations, so let's
use those for reserved entries instead of reducing the effective station
number limit.

- Felix
