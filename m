Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F85C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 05:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60E5D20878
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 05:27:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="DQQvYAXi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60E5D20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbeJBMJN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 08:09:13 -0400
Received: from nbd.name ([46.4.11.11]:55556 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbeJBMJN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 08:09:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4LNxU5iZP2VFuUp2Yek1McxY/NjLSmOEf2M67B5K+VM=; b=DQQvYAXiPJ/UQToCccc1aMuG7k
        2sKLga2o5je6jF7JT8U77bR7RKjbEF4QXxsXTVozG7nc4tfnWi+vM+hprDsGw8ZXCO8ZnctENcWzC
        vZxYad3f35vqjLT++LgiToEb+LWwvPpOnCQhzF3Z8a0+unVVgjfYtfBvRzjZDVrdPI2w=;
Subject: Re: [PATCH 02/10] mt76: move mt76x02_rx_get_sta and
 mt76x02_rx_get_sta_wcid in mt76x02_util.c
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
References: <20181001221908.16005-3-lorenzo.bianconi@redhat.com>
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
Message-ID: <97478608-a454-7bc0-8478-e4a8e87ac7b0@nbd.name>
Date:   Tue, 2 Oct 2018 07:27:49 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181001221908.16005-3-lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-02 00:19, Lorenzo Bianconi wrote:
> Move mt76x02_rx_get_sta and mt76x02_rx_get_sta_wcid utility routines in
> mt76x02-lib module since it will be used by mt76x0 driver in order to
> unify rxwi parsing
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
>  .../net/wireless/mediatek/mt76/mt76x02_util.c | 29 +++++++++++++++++
>  .../net/wireless/mediatek/mt76/mt76x02_util.h |  3 ++
>  .../net/wireless/mediatek/mt76/mt76x2/mac.c   | 32 ++-----------------
>  3 files changed, 34 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> index b12db0a108d3..496be05e59a6 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> @@ -531,4 +531,33 @@ void mt76x02_set_beacon_offsets(struct mt76_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(mt76x02_set_beacon_offsets);
>  
> +struct mt76x02_sta *
> +mt76x02_rx_get_sta(struct mt76_dev *dev, u8 idx)
> +{
> +	struct mt76_wcid *wcid;
> +
> +	if (idx >= ARRAY_SIZE(dev->wcid))
> +		return NULL;
> +
> +	wcid = rcu_dereference(dev->wcid[idx]);
> +	if (!wcid)
> +		return NULL;
> +
> +	return container_of(wcid, struct mt76x02_sta, wcid);
> +}
> +EXPORT_SYMBOL_GPL(mt76x02_rx_get_sta);
> +
> +struct mt76_wcid *
> +mt76x02_rx_get_sta_wcid(struct mt76x02_sta *sta, bool unicast)
> +{
> +	if (!sta)
> +		return NULL;
> +
> +	if (unicast)
> +		return &sta->wcid;
> +	else
> +		return &sta->vif->group_wcid;
> +}
> +EXPORT_SYMBOL_GPL(mt76x02_rx_get_sta_wcid);
Both of these functions are trivial and should be inline.

- Felix
